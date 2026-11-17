import 'package:booking/core/error/failure_code.dart';
import 'package:booking/features/booking/data/models/booking.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'booking_state.freezed.dart';

/// Terminal ACTION states for booking and cancellation (never mixed with
/// stream states — the results list lives on its own stream cubit).
///
/// A lost race is NOT a separate state: it surfaces as
/// `BookingFailed(FailureCode.conflictLost)` and the listener routes it to
/// the designed conflict screen. `OfflinePending` is the honest connectivity
/// outcome: no nights were taken, retry re-validates server-side.
@freezed
sealed class BookingState with _$BookingState {
  const factory BookingState.idle() = _Idle;

  const factory BookingState.submitting() = Submitting;

  const factory BookingState.offlinePending() = OfflinePending;

  const factory BookingState.bookingSuccess(Booking booking) = BookingSuccess;

  const factory BookingState.bookingFailure(BookingFailure failure) =
      BookingFailed;

  const factory BookingState.cancelling() = Cancelling;

  const factory BookingState.cancelSuccess(Booking booking) = CancelSuccess;

  const factory BookingState.cancelFailure(BookingFailure failure) =
      CancelFailed;
}
