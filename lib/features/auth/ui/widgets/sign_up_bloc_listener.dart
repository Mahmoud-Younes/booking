import 'package:booking/core/error/firebase_error_mapper.dart';
import 'package:booking/core/routing/routes.dart';
import 'package:booking/core/theming/colors.dart';
import 'package:booking/features/auth/logic/cubit/sign_up_cubit.dart';
import 'package:booking/features/auth/logic/cubit/sign_up_state.dart';
import 'package:booking/core/helpers/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Side effects for sign-up states: home on success, Arabic error dialog on
/// failure (e.g. email-already-in-use mapped from the raw Firebase code).
class SignUpBlocListener extends StatelessWidget {
  const SignUpBlocListener({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignUpCubit, SignUpState>(
      listenWhen: (SignUpState previous, SignUpState current) =>
          previous is SignUpLoading || current is SignUpFailure,
      listener: (BuildContext context, SignUpState state) {
        state.whenOrNull(
          signUpSuccess: (_) =>
              context.pushReplacementNamed(Routes.homeScreen),
          signUpFailure: (failure) => showDialog<void>(
            context: context,
            builder: (BuildContext dialogContext) => AlertDialog(
              content: Text(FirebaseErrorMapper.message(failure)),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: const Text('حسناً',
                      style: TextStyle(color: ColorsManager.mainBlue)),
                ),
              ],
            ),
          ),
        );
      },
      child: const SizedBox.shrink(),
    );
  }
}
