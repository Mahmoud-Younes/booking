import 'package:booking/core/error/result.dart';
import 'package:booking/core/error/failure_code.dart';
import 'package:booking/features/auth/data/models/sign_up_request_body.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:booking/core/helpers/app_regex.dart';
import 'package:booking/features/auth/data/repos/auth_repo.dart';
import 'package:booking/features/auth/logic/cubit/sign_up_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Registration form owner: name/email/password controllers, validation, and
/// the terminal state machine (profile doc write happens inside the repo).
class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit(this._authRepo) : super(const SignUpState.initial());

  final AuthRepo _authRepo;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'أدخل اسمك';
    }
    return null;
  }

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

  Future<void> emitSignUpStates() async {
    if (validateName(nameController.text) != null ||
        validateEmail(emailController.text) != null ||
        validatePassword(passwordController.text) != null) {
      return;
    }
    emit(const SignUpState.signUpLoading());
    final Result<User> result = await _authRepo.signUp(SignUpRequestBody(
      name: nameController.text.trim(),
      email: emailController.text.trim(),
      password: passwordController.text,
    ));
    result.when(
      success: (User user) => emit(SignUpState.signUpSuccess(user)),
      failure: (BookingFailure failure) => emit(SignUpState.signUpFailure(failure)),
    );
  }

  @override
  Future<void> close() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    return super.close();
  }
}
