import 'package:booking/core/theming/colors.dart';
import 'package:booking/core/theming/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Designed zero-results state (never a bare SizedBox).
class EmptyStateView extends StatelessWidget {
  const EmptyStateView({
    super.key,
    required this.title,
    required this.subtitle,
    this.actionLabel,
    this.onAction,
    this.icon = Icons.search_off,
  });

  final String title;
  final String subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 64.w, color: ColorsManager.lightGray),
            SizedBox(height: 16.h),
            Text(title, style: TextStyles.font16DarkBlueBold, textAlign: TextAlign.center),
            SizedBox(height: 8.h),
            Text(
              subtitle,
              style: TextStyles.font14GrayRegular,
              textAlign: TextAlign.center,
            ),
            if (actionLabel != null && onAction != null) ...[
              SizedBox(height: 16.h),
              TextButton(
                onPressed: onAction,
                child: Text(actionLabel!, style: TextStyles.font13BlueRegular),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
