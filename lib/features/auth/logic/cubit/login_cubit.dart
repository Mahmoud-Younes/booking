import 'package:booking/core/error/result.dart';
import 'package:booking/core/error/failure_code.dart';
import 'package:booking/features/auth/data/models/login_request_body.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:booking/core/helpers/app_regex.dart';
import 'package:booking/features/auth/data/repos/auth_repo.dart';
import 'package:booking/features/auth/logic/cubit/login_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Login form owner: controllers, validation, and the terminal state machine.
class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this._authRepo) : super(const LoginState.initial());

  final AuthRepo _authRepo;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  /// Field validators — used by the form fields AND by [emitLoginStates] so
  /// the logic never depends on a mounted Form widget (unit-testable).
  String? validateEmail(String? value) {
    if (value == null || !AppRegex.isEmailValid(value.trim())) {
      return 'أدخل بريداً إلكترونياً صحيحاً';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || !AppRegex.isPasswordValid(value)) {
      return 'كلمة المرور 6 أحرف على الأقل';
    }
    return null;
  }

  Future<void> emitLoginStates() async {
    if (validateEmail(emailController.text) != null ||
        validatePassword(passwordController.text) != null) {
      return;
    }
    emit(const LoginState.loginLoading());
    final Result<User> result = await _authRepo.signIn(LoginRequestBody(
      email: emailController.text.trim(),
      password: passwordController.text,
    ));
    result.when(
      success: (User user) => emit(LoginState.loginSuccess(user)),
      failure: (BookingFailure failure) => emit(LoginState.loginFailure(failure)),
    );
  }

  @override
  Future<void> close() {
    emailController.dispose();
    passwordController.dispose();
    return super.close();
  }
}
