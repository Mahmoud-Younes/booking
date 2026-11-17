import 'package:booking/core/error/failure_code.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'sign_up_state.freezed.dart';

/// Terminal action states for registration.
@freezed
sealed class SignUpState with _$SignUpState {
  const factory SignUpState.initial() = _Initial;

  const factory SignUpState.signUpLoading() = SignUpLoading;

  const factory SignUpState.signUpSuccess(User user) = SignUpSuccess;

  const factory SignUpState.signUpFailure(BookingFailure failure) =
      SignUpFailure;
}
