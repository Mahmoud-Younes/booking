import 'package:booking/core/data/firestore_paths.dart';
import 'package:booking/core/error/failure_code.dart';
import 'package:booking/core/error/firebase_error_mapper.dart';
import 'package:booking/core/error/result.dart';
import 'package:booking/core/helpers/stay_date.dart';
import 'package:booking/features/booking/data/models/booking.dart';
import 'package:booking/features/booking/data/models/booking_failure_record.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Booking I/O boundary — THE core guarantee lives here.
///
/// TRANSACTION INVARIANT (mirrored in firestore.rules — never change one
/// side without the other): a booking is ONE Firestore transaction that
/// (a) reads every night document in the requested range, (b) aborts with
/// BookingConflictException when any night already exists, and (c) creates
/// the booking document plus one night document per night. Two concurrent
/// bookings for the same nights target the same deterministic paths; the
/// transaction engine serializes them and rules allow create only when the
/// night document does not exist — exactly one wins, server-enforced.
class BookingRepo {
  BookingRepo(this._db, this._paths);

  final FirebaseFirestore _db;
  final FirestorePaths _paths;

  Future<Result<Booking>> attemptBooking({
    required String userId,
    required String roomId,
    required StayDateRange stayRange,
  }) async {
    // Stay policy is enforced before the transaction (mirrored in rules via
    // the epoch-day delta check).
    if (stayRange.exceedsMaxStay) {
      return const Result.failure(BookingFailure(
        code: FailureCode.ruleDenied,
        rawCode: 'max-stay-exceeded',
      ));
    }

    final Booking draft = Booking(
      userId: userId,
      roomId: roomId,
      checkIn: Timestamp.fromMillisecondsSinceEpoch(
          stayRange.checkIn.epochDay * Duration.millisecondsPerDay),
      checkOut: Timestamp.fromMillisecondsSinceEpoch(
          stayRange.checkOut.epochDay * Duration.millisecondsPerDay),
      checkInEpochDay: stayRange.checkIn.epochDay,
      checkOutEpochDay: stayRange.checkOut.epochDay,
      status: Booking.statusActive,
    );
    final List<int> nightKeys = stayRange
        .occupiedNights()
        .map((StayDate night) => night.epochDay)
        .toList();

    try {
      final Booking committed = await _db.runTransaction<Booking>(
        (Transaction transaction) async {
          final DocumentReference<Map<String, dynamic>> bookingRef =
              _db.collection(_paths.bookings()).doc();

          // 1. Read every requested night — any existing night aborts.
          for (final int epochDay in nightKeys) {
            final DocumentSnapshot<Map<String, dynamic>> nightSnap =
                await transaction
                    .get(_db.doc(_paths.nightDoc(roomId, epochDay)));
            if (nightSnap.exists) {
              throw BookingConflictException(
                  '$roomId/${StayDate.fromEpochDay(epochDay).value}');
            }
          }

          // 2. Create the booking + every night doc in one commit — or
          //    nothing is written at all.
          transaction.set(bookingRef, draft.createMap());
          for (final int epochDay in nightKeys) {
            transaction.set(
              _db.collection(_paths.roomNights(roomId)).doc('$epochDay'),
              <String, dynamic>{
                'bookingId': bookingRef.id,
                'epochDay': epochDay,
              },
            );
          }

          return draft.copyWith(id: bookingRef.id);
        },
      );
      return Result.success(committed);
    } catch (error) {
      _recordFailure(
        userId: userId,
        roomId: roomId,
        stayRange: stayRange,
        error: error,
      );
      return Result.failure(_failure(error));
    }
  }

  /// Cancellation frees the nights transactionally and flips the status —
  /// never a bare document delete, and cancelled nights become re-bookable.
  Future<Result<Booking>> cancelBooking(Booking booking) async {
    try {
      await _db.runTransaction<void>((Transaction transaction) async {
        transaction.update(
          _db.collection(_paths.bookings()).doc(booking.id),
          <String, dynamic>{'status': Booking.statusCancelled},
        );
        for (final int epochDay
            in booking.stayRange().map((StayDate n) => n.epochDay)) {
          transaction.delete(_db.doc(_paths.nightDoc(booking.roomId, epochDay)));
        }
      });
      return Result.success(
        booking.copyWith(status: Booking.statusCancelled),
      );
    } catch (error) {
      return Result.failure(_failure(error));
    }
  }

  /// Best-effort audit write OUTSIDE the transaction, errors ignored: the
  /// guarantee is proven by server-committed state alone; this trail exists
  /// so a lost race is reconstructible from the console.
  void _recordFailure({
    required String userId,
    required String roomId,
    required StayDateRange stayRange,
    required Object error,
  }) {
    final FailureCode code = FirebaseErrorMapper.map(error);
    final BookingFailureRecord record = BookingFailureRecord(
      userId: userId,
      roomId: roomId,
      checkIn: stayRange.checkIn.value,
      checkOut: stayRange.checkOut.value,
      code: code.name,
      rawCode: error is FirebaseException ? error.code : error.toString(),
    );
    _db
        .collection(_paths.bookingFailures())
        .add(record.toMap()
          ..['createdAt'] = FieldValue.serverTimestamp())
        .then<void>((_) {}, onError: (Object _) {});
  }

  BookingFailure _failure(Object error) => BookingFailure(
        code: FirebaseErrorMapper.map(error),
        rawCode: error is FirebaseException ? error.code : error.toString(),
      );
}

extension on Booking {
  /// The occupied-night keys of a stored booking (cancellation write set).
  List<StayDate> stayRange() => List<StayDate>.generate(
        checkOutEpochDay - checkInEpochDay,
        (int i) => StayDate.fromEpochDay(checkInEpochDay + i),
      );
}
