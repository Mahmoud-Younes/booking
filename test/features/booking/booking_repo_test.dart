import 'package:booking/core/data/firestore_paths.dart';
import 'package:booking/core/env/env.dart';
import 'package:booking/core/error/result.dart';
import 'package:booking/core/helpers/constants.dart';
import 'package:booking/core/error/failure_code.dart';
import 'package:booking/core/helpers/stay_date.dart';
import 'package:booking/features/booking/data/models/booking.dart';
import 'package:booking/features/booking/data/repos/booking_repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late FakeFirebaseFirestore db;
  late BookingRepo repo;

  // Deterministic stay: 2026-12-01 -> 2026-12-03 (2 nights, half-open).
  StayDateRange stay() => StayDateRange(
        checkIn: StayDate.parse('2026-12-01'),
        checkOut: StayDate.parse('2026-12-03'),
      );

  setUp(() {
    db = FakeFirebaseFirestore();
    repo = BookingRepo(db, const FirestorePaths(Env.prod));
  });

  group('attemptBooking — the core guarantee (fake-backed)', () {
    test('happy path writes the booking + one night doc per night', () async {
      final Result<Booking> result = await repo.attemptBooking(
        userId: 'user_a',
        roomId: 'room_cairo_01',
        stayRange: stay(),
      );

      expect(result, isA<Success<Booking>>());
      final Booking booking = (result as Success<Booking>).data;
      expect(booking.id, isNotEmpty);
      expect(booking.status, Booking.statusActive);
      expect(booking.policyVersion, Constants.policyVersion);

      final QuerySnapshot<Map<String, dynamic>> nights = await db
          .collection('rooms/room_cairo_01/nights')
          .get();
      expect(nights.docs.length, 2);
      expect(
        nights.docs.map((DocumentSnapshot<Map<String, dynamic>> d) => d.id),
        containsAll(<String>['20788', '20789']),
      );
      final Map<String, dynamic> nightData = nights.docs.first.data();
      expect(nightData['bookingId'], booking.id);
      expect(nightData['epochDay'], isA<int>());

      final DocumentSnapshot<Map<String, dynamic>> stored =
          await db.collection('bookings').doc(booking.id).get();
      expect(stored.data()!['status'], Booking.statusActive);
      expect(stored.data()!['createdAt'], isA<Timestamp>(),
          reason: 'fake resolves serverTimestamp to a Timestamp');
    });

    test('a second overlapping booking loses the race (conflictLost)',
        () async {
      await repo.attemptBooking(
        userId: 'user_a',
        roomId: 'room_cairo_01',
        stayRange: stay(),
      );

      final Result<Booking> loser = await repo.attemptBooking(
        userId: 'user_b',
        roomId: 'room_cairo_01',
        stayRange: stay(),
      );

      expect(loser, isA<Failure<Booking>>());
      final BookingFailure failure = (loser as Failure<Booking>).failure;
      expect(failure.code, FailureCode.conflictLost);
      expect(failure.rawCode, contains('room_cairo_01'));
    });

    test('a transaction that loses writes NOTHING (atomicity)', () async {
      await repo.attemptBooking(
        userId: 'user_a',
        roomId: 'room_cairo_01',
        stayRange: stay(),
      );
      await repo.attemptBooking(
        userId: 'user_b',
        roomId: 'room_cairo_01',
        stayRange: stay(),
      );

      final QuerySnapshot<Map<String, dynamic>> bookings =
          await db.collection('bookings').get();
      expect(bookings.docs.length, 1,
          reason: 'the loser must not leave a booking document behind');
    });

    test('non-overlapping ranges on the same room both succeed', () async {
      final Result<Booking> first = await repo.attemptBooking(
        userId: 'user_a',
        roomId: 'room_cairo_01',
        stayRange: stay(),
      );
      final Result<Booking> second = await repo.attemptBooking(
        userId: 'user_b',
        roomId: 'room_cairo_01',
        stayRange: StayDateRange(
          checkIn: StayDate.parse('2026-12-03'),
          checkOut: StayDate.parse('2026-12-05'),
        ),
      );
      expect(first, isA<Success<Booking>>());
      expect(second, isA<Success<Booking>>());
    });

    test('a stay beyond the pinned 30-night maximum is rejected before I/O',
        () async {
      final Result<Booking> result = await repo.attemptBooking(
        userId: 'user_a',
        roomId: 'room_cairo_01',
        stayRange: StayDateRange(
          checkIn: StayDate.parse('2026-12-01'),
          checkOut: StayDate.parse('2027-01-05'),
        ),
      );
      expect(result, isA<Failure<Booking>>());
      expect((result as Failure<Booking>).failure.rawCode,
          'max-stay-exceeded');
      final QuerySnapshot<Map<String, dynamic>> bookings =
          await db.collection('bookings').get();
      expect(bookings.docs, isEmpty);
    });
  });

  group('cancelBooking — frees nights for re-booking', () {
    test('cancellation deletes night docs and flips status', () async {
      final Booking booking =
          (await repo.attemptBooking(
        userId: 'user_a',
        roomId: 'room_cairo_01',
        stayRange: stay(),
      ) as Success<Booking>)
              .data;

      final Result<Booking> cancelled = await repo.cancelBooking(booking);

      expect(cancelled, isA<Success<Booking>>());
      expect((cancelled as Success<Booking>).data.status,
          Booking.statusCancelled);
      final QuerySnapshot<Map<String, dynamic>> nights = await db
          .collection('rooms/room_cairo_01/nights')
          .get();
      expect(nights.docs, isEmpty,
          reason: 'freed nights make the room bookable again');
    });

    test('a freed night can be booked again', () async {
      final Booking booking =
          (await repo.attemptBooking(
        userId: 'user_a',
        roomId: 'room_cairo_01',
        stayRange: stay(),
      ) as Success<Booking>)
              .data;
      await repo.cancelBooking(booking);

      final Result<Booking> rebooked = await repo.attemptBooking(
        userId: 'user_b',
        roomId: 'room_cairo_01',
        stayRange: stay(),
      );
      expect(rebooked, isA<Success<Booking>>());
    });
  });

  group('failure audit trail — best-effort diagnostics', () {
    test('a conflict attempt writes a booking_failures record', () async {
      await repo.attemptBooking(
        userId: 'user_a',
        roomId: 'room_cairo_01',
        stayRange: stay(),
      );
      await repo.attemptBooking(
        userId: 'user_b',
        roomId: 'room_cairo_01',
        stayRange: stay(),
      );
      // The audit write is fire-and-forget; give it a microtask turn.
      await Future<void>.delayed(Duration.zero);

      final QuerySnapshot<Map<String, dynamic>> failures =
          await db.collection('booking_failures').get();
      expect(failures.docs.length, 1);
      final Map<String, dynamic> record = failures.docs.first.data();
      expect(record['code'], FailureCode.conflictLost.name);
      expect(record['userId'], 'user_b');
      expect(record['checkIn'], '2026-12-01');
    });
  });
}
