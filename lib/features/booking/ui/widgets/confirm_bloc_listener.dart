import 'package:booking/core/error/failure_code.dart';
import 'package:booking/core/routing/routes.dart';
import 'package:booking/features/booking/logic/cubit/booking_state.dart';
import 'package:flutter/material.dart';

/// Routing side effects for booking states: a lost race pushes the designed
/// conflict screen; everything else renders in place (success/offline).
class ConfirmBlocListener {
  ConfirmBlocListener._();

  static void handle(BuildContext context, BookingState state) {
    state.maybeWhen(
      bookingFailure: (failure) {
        if (failure.code == FailureCode.conflictLost) {
          Navigator.pushNamed(
            context,
            Routes.conflictScreen,
            arguments: failure,
          );
        }
      },
      orElse: () {},
    );
  }
}
