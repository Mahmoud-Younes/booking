import 'dart:async';

import 'package:booking/core/error/failure_code.dart';
import 'package:booking/core/error/firebase_error_mapper.dart';
import 'package:booking/features/booking/data/models/booking.dart';
import 'package:booking/features/booking/data/repos/booking_repo.dart';
import 'package:booking/features/booking/logic/cubit/my_bookings_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Live list of the signed-in user's bookings — stream-cubit contract
/// (one subscription, cancelled before re-load and in close()).
class MyBookingsCubit extends Cubit<MyBookingsState> {
  MyBookingsCubit(this._bookingRepo) : super(const MyBookingsState.connecting());

  final BookingRepo _bookingRepo;

  StreamSubscription<List<Booking>>? _subscription;
  List<Booking> _lastBookings = const <Booking>[];

  void load(String userId) {
    _subscription?.cancel();
    _subscription = null;
    emit(const MyBookingsState.connecting());
    _subscription = _bookingRepo.watchMyBookings(userId).listen(
          (List<Booking> bookings) {
            _lastBookings = bookings;
            emit(
              bookings.isEmpty
                  ? const MyBookingsState.empty()
                  : MyBookingsState.live(bookings),
            );
          },
          onError: (Object error) => emit(MyBookingsState.failure(
            _lastBookings,
            BookingFailure(code: FirebaseErrorMapper.map(error)),
          )),
        );
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
