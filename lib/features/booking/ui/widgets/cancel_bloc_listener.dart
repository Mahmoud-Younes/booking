import 'package:booking/core/error/firebase_error_mapper.dart';
import 'package:booking/core/localization/app_strings.dart';
import 'package:booking/features/booking/logic/cubit/booking_state.dart';
import 'package:flutter/material.dart';

/// Side effects for cancel states: Arabic snackbar on success/failure (the
/// list updates live from its own stream).
class CancelBlocListener {
  CancelBlocListener._();

  static void handle(BuildContext context, BookingState state) {
    state.maybeWhen(
      cancelSuccess: (_) => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppStrings.cancelSuccessTitle)),
      ),
      cancelFailure: (failure) => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(FirebaseErrorMapper.message(failure))),
      ),
      orElse: () {},
    );
  }
}
