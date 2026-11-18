import 'package:booking/core/theming/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Shared styled text form field with consistent borders
/// and inline error rendering.
class AppTextFormField extends StatelessWidget {
  const AppTextFormField({
    super.key,
    this.controller,
    this.hintText,
    this.labelText,
    this.validator,
    this.obscureText = false,
    this.keyboardType,
    this.suffixIcon,
    this.prefixIcon,
    this.enabled = true,
    this.textInputAction,
    this.onFieldSubmitted,
  });

  final TextEditingController? controller;
  final String? hintText;
  final String? labelText;
  final String? Function(String?)? validator;
  final bool obscureText;
  final TextInputType? keyboardType;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final bool enabled;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onFieldSubmitted;

  @override
  Widget build(BuildContext context) {
    final OutlineInputBorder border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.r),
      borderSide: const BorderSide(color: ColorsManager.lightGray),
    );
    return TextFormField(
      controller: controller,
      validator: validator,
      obscureText: obscureText,
      keyboardType: keyboardType,
      enabled: enabled,
      textInputAction: textInputAction,
      onFieldSubmitted: onFieldSubmitted,
      decoration: InputDecoration(
        hintText: hintText,
        labelText: labelText,
        hintStyle: const TextStyle(color: ColorsManager.gray),
        labelStyle: const TextStyle(color: ColorsManager.gray),
        filled: true,
        fillColor: ColorsManager.offWhite,
        suffixIcon: suffixIcon,
        prefixIcon: prefixIcon,
        contentPadding:
            EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        enabledBorder: border,
        focusedBorder: border.copyWith(
          borderSide: const BorderSide(color: ColorsManager.mainBlue),
        ),
        errorBorder: border.copyWith(
          borderSide: const BorderSide(color: ColorsManager.errorRed),
        ),
        focusedErrorBorder: border.copyWith(
          borderSide: const BorderSide(color: ColorsManager.errorRed),
        ),
      ),
    );
  }
}
