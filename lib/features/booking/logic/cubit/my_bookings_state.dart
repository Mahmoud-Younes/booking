import 'package:booking/core/error/failure_code.dart';
import 'package:booking/features/booking/data/models/booking.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'my_bookings_state.freezed.dart';

/// Stream-cubit contract for the user's bookings (same shape as search).
@freezed
sealed class MyBookingsState with _$MyBookingsState {
  const factory MyBookingsState.connecting() = BookingsConnecting;

  const factory MyBookingsState.live(List<Booking> bookings) = BookingsLive;

  const factory MyBookingsState.empty() = BookingsEmpty;

  const factory MyBookingsState.failure(
      List<Booking> lastBookings, BookingFailure failure) = BookingsFailed;
}
