import 'package:booking/core/di/dependency_injection.dart';
import 'package:booking/core/helpers/extensions.dart';
import 'package:booking/core/localization/app_strings.dart';
import 'package:booking/core/routing/routes.dart';
import 'package:booking/core/theming/colors.dart';
import 'package:booking/core/theming/styles.dart';
import 'package:booking/core/widgets/app_text_button.dart';
import 'package:booking/core/widgets/app_text_form_field.dart';
import 'package:booking/features/auth/logic/cubit/sign_up_cubit.dart';
import 'package:booking/features/auth/logic/cubit/sign_up_state.dart';
import 'package:booking/features/auth/ui/widgets/sign_up_bloc_listener.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Sign-up screen — registers the account then writes the profile document.
class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<SignUpCubit>(),
      child: const _SignUpScreenBody(),
    );
  }
}

class _SignUpScreenBody extends StatelessWidget {
  const _SignUpScreenBody();

  @override
  Widget build(BuildContext context) {
    final SignUpCubit cubit = context.read<SignUpCubit>();
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(AppStrings.signUpButton, style: TextStyles.font32BlueBold),
                SizedBox(height: 8.h),
                Text(
                  AppStrings.loginSubtitle,
                  style: TextStyles.font14GrayRegular,
                ),
                SizedBox(height: 32.h),
                const SignUpBlocListener(),
                Form(
                  key: cubit.formKey,
                  child: Column(
                    children: [
                      AppTextFormField(
                        controller: cubit.nameController,
                        hintText: AppStrings.nameLabel,
                        validator: cubit.validateName,
                      ),
                      SizedBox(height: 16.h),
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
                      BlocBuilder<SignUpCubit, SignUpState>(
                        buildWhen: (SignUpState previous, SignUpState current) =>
                            previous is SignUpLoading ||
                            current is SignUpLoading,
                        builder: (BuildContext context, SignUpState state) =>
                            AppTextButton(
                          buttonText: AppStrings.signUpButton,
                          isLoading: state is SignUpLoading,
                          backgroundColor: ColorsManager.mainBlue,
                          textStyle: TextStyles.font16WhiteSemiBold,
                          width: double.infinity,
                          onPressed: cubit.emitSignUpStates,
                        ),
                      ),
                      SizedBox(height: 16.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            AppStrings.haveAccount,
                            style: TextStyles.font14GrayRegular,
                          ),
                          SizedBox(width: 8.w),
                          TextButton(
                            onPressed: () => context
                                .pushReplacementNamed(Routes.loginScreen),
                            child: Text(
                              AppStrings.loginButton,
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
