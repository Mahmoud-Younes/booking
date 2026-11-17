import 'package:booking/core/error/firebase_error_mapper.dart';
import 'package:booking/core/localization/app_strings.dart';
import 'package:booking/core/routing/routes.dart';
import 'package:booking/core/theming/colors.dart';
import 'package:booking/features/auth/logic/cubit/login_cubit.dart';
import 'package:booking/features/auth/logic/cubit/login_state.dart';
import 'package:booking/core/helpers/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Side effects for login states: navigate home on success, mapped Arabic
/// error dialog on failure (no raw Firebase strings).
class LoginBlocListener extends StatelessWidget {
  const LoginBlocListener({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listenWhen: (LoginState previous, LoginState current) =>
          previous is LoginLoading || current is LoginFailure,
      listener: (BuildContext context, LoginState state) {
        state.whenOrNull(
          loginSuccess: (_) =>
              context.pushReplacementNamed(Routes.homeScreen),
          loginFailure: (failure) => showDialog<void>(
            context: context,
            builder: (BuildContext dialogContext) => AlertDialog(
              title: const Text(AppStrings.appName),
              content: Text(FirebaseErrorMapper.message(failure)),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: const Text(AppStrings.retry,
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
