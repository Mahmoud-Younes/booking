import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_request_body.freezed.dart';

/// Login form payload — no JSON layer: this goes straight to Firebase Auth.
@freezed
sealed class LoginRequestBody with _$LoginRequestBody {
  const factory LoginRequestBody({
    required String email,
    required String password,
  }) = _LoginRequestBody;
}
