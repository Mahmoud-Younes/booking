import 'package:booking/core/theming/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Shared styled text button.
class AppTextButton extends StatelessWidget {
  const AppTextButton({
    super.key,
    required this.buttonText,
    required this.onPressed,
    this.backgroundColor,
    this.textStyle,
    this.borderRadius,
    this.verticalPadding,
    this.horizontalPadding,
    this.width,
    this.isLoading = false,
  });

  final String buttonText;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final TextStyle? textStyle;
  final BorderRadius? borderRadius;
  final double? verticalPadding;
  final double? horizontalPadding;
  final double? width;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: isLoading ? null : onPressed,
      style: ButtonStyle(
        backgroundColor: backgroundColor != null
            ? WidgetStateProperty.all(backgroundColor)
            : null,
        padding: WidgetStateProperty.all<EdgeInsets>(
          EdgeInsets.symmetric(
            vertical: verticalPadding ?? 14.h,
            horizontal: horizontalPadding ?? 12.w,
          ),
        ),
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: borderRadius ?? BorderRadius.circular(12.r),
          ),
        ),
      ),
      child: isLoading
          ? const SizedBox(
              height: 22,
              width: 22,
              child: CircularProgressIndicator(color: ColorsManager.white),
            )
          : Text(buttonText, style: textStyle),
    );
  }
}
