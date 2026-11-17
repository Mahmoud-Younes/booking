import 'package:booking/core/di/dependency_injection.dart';
import 'package:booking/core/helpers/extensions.dart';
import 'package:booking/core/localization/app_strings.dart';
import 'package:booking/core/routing/routes.dart';
import 'package:booking/core/theming/colors.dart';
import 'package:booking/core/theming/styles.dart';
import 'package:booking/core/widgets/app_text_button.dart';
import 'package:booking/core/widgets/app_text_form_field.dart';
import 'package:booking/features/auth/logic/cubit/login_cubit.dart';
import 'package:booking/features/auth/logic/cubit/login_state.dart';
import 'package:booking/features/auth/ui/widgets/login_bloc_listener.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Login screen — Arabic RTL form; the entry route for signed-out users.
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<LoginCubit>(),
      child: const _LoginScreenBody(),
    );
  }
}

class _LoginScreenBody extends StatelessWidget {
  const _LoginScreenBody();

  @override
  Widget build(BuildContext context) {
    final LoginCubit cubit = context.read<LoginCubit>();
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(AppStrings.loginTitle, style: TextStyles.font32BlueBold),
                SizedBox(height: 8.h),
                Text(
                  AppStrings.loginSubtitle,
                  style: TextStyles.font14GrayRegular,
                ),
                SizedBox(height: 32.h),
                const LoginBlocListener(),
                Form(
                  key: cubit.formKey,
                  child: Column(
                    children: [
                      AppTextFormField(
                        controller: cubit.emailController,
                        hintText: AppStrings.emailLabel,
                        keyboardType: TextInputType.emailAddress,
                        validator: cubit.validateEmail,
                      ),
                      SizedBox(height: 16.h),
                      AppTextFormField(
                        controller: cubit.passwordController,
                        hintText: AppStrings.passwordLabel,
                        obscureText: true,
                        validator: cubit.validatePassword,
                      ),
                      SizedBox(height: 24.h),
                      BlocBuilder<LoginCubit, LoginState>(
                        buildWhen: (LoginState previous, LoginState current) =>
                            previous is LoginLoading || current is LoginLoading,
                        builder: (BuildContext context, LoginState state) =>
                            AppTextButton(
                          buttonText: AppStrings.loginButton,
                          isLoading: state is LoginLoading,
                          backgroundColor: ColorsManager.mainBlue,
                          textStyle: TextStyles.font16WhiteSemiBold,
                          width: double.infinity,
                          onPressed: cubit.emitLoginStates,
                        ),
                      ),
                      SizedBox(height: 16.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            AppStrings.noAccount,
                            style: TextStyles.font14GrayRegular,
                          ),
                          SizedBox(width: 8.w),
                          TextButton(
                            onPressed: () => context
                                .pushReplacementNamed(Routes.signUpScreen),
                            child: Text(
                              AppStrings.signUpButton,
                              style: TextStyles.font13BlueRegular,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
