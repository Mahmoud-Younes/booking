import 'package:booking/core/error/failure_code.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_state.freezed.dart';

/// Terminal action states (login is a request/response flow, not a stream):
/// initial -> loading -> success | failure.
@freezed
sealed class LoginState with _$LoginState {
  const factory LoginState.initial() = _Initial;

  const factory LoginState.loginLoading() = LoginLoading;

  const factory LoginState.loginSuccess(User user) = LoginSuccess;

  const factory LoginState.loginFailure(BookingFailure failure) = LoginFailure;
}
