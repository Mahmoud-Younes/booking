import 'package:booking/core/theming/colors.dart';
import 'package:booking/core/theming/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Inline retry card for stream failures — the last list stays visible and
/// this card renders under it (never a full-screen dialog for a list).
class FailureRetryCard extends StatelessWidget {
  const FailureRetryCard({
    super.key,
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: ColorsManager.errorRed.withValues(alpha: 0.08),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Row(
          children: [
            const Icon(Icons.cloud_off, color: ColorsManager.errorRed),
            SizedBox(width: 12.w),
            Expanded(child: Text(message, style: TextStyles.font14GrayRegular)),
            TextButton(
              onPressed: onRetry,
              child: const Text('إعادة المحاولة',
                  style: TextStyle(color: ColorsManager.mainBlue)),
            ),
          ],
        ),
      ),
    );
  }
}
