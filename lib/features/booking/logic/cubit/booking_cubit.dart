import 'package:booking/core/error/failure_code.dart';
import 'package:booking/core/error/result.dart';
import 'package:booking/core/helpers/stay_date.dart';
import 'package:booking/features/booking/data/models/booking.dart';
import 'package:booking/features/booking/data/repos/booking_repo.dart';
import 'package:booking/features/booking/logic/cubit/booking_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Booking/cancellation action cubit — owns no stream.
///
/// [submit] keeps the last attempt so the conflict screen's and the
/// offline-pending view's retry re-runs the transaction, which re-validates
/// server-side.
class BookingCubit extends Cubit<BookingState> {
  BookingCubit(this._bookingRepo) : super(const BookingState.idle());

  final BookingRepo _bookingRepo;

  String? _userId;
  String? _roomId;
  StayDateRange? _stayRange;

  Future<void> submit({
    required String userId,
    required String roomId,
    required StayDateRange stayRange,
  }) async {
    _userId = userId;
    _roomId = roomId;
    _stayRange = stayRange;
    await _runAttempt();
  }

  /// Re-runs the last attempt (offline recovery / conflict recovery path).
  Future<void> retry() async {
    final String? userId = _userId;
    final String? roomId = _roomId;
    final StayDateRange? stayRange = _stayRange;
    if (userId == null || roomId == null || stayRange == null) {
      return;
    }
    await _runAttempt();
  }

  Future<void> cancel(Booking booking) async {
    emit(const BookingState.cancelling());
    final Result<Booking> result = await _bookingRepo.cancelBooking(booking);
    result.when(
      success: (Booking cancelled) =>
          emit(BookingState.cancelSuccess(cancelled)),
      failure: (BookingFailure failure) =>
          emit(BookingState.cancelFailure(failure)),
    );
  }

  Future<void> _runAttempt() async {
    emit(const BookingState.submitting());
    final Result<Booking> result = await _bookingRepo.attemptBooking(
      userId: _userId!,
      roomId: _roomId!,
      stayRange: _stayRange!,
    );
    result.when(
      success: (Booking booking) => emit(BookingState.bookingSuccess(booking)),
      failure: (BookingFailure failure) {
        // The offline contract: connectivity failures emit the honest
        // pending state (no nights were taken) instead of a generic error.
        if (failure.code == FailureCode.networkUnavailable) {
          emit(const BookingState.offlinePending());
        } else {
          emit(BookingState.bookingFailure(failure));
        }
      },
    );
  }
}
