import 'package:freezed_annotation/freezed_annotation.dart';

part 'sign_up_request_body.freezed.dart';

/// Sign-up form payload — the profile document is written after account
/// creation (register-then-write-profile flow).
@freezed
sealed class SignUpRequestBody with _$SignUpRequestBody {
  const factory SignUpRequestBody({
    required String name,
    required String email,
    required String password,
  }) = _SignUpRequestBody;
}
