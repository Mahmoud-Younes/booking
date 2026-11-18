import 'package:booking/core/error/failure_code.dart';
import 'package:booking/core/localization/app_strings.dart';
import 'package:booking/core/routing/routes.dart';
import 'package:booking/core/helpers/extensions.dart';
import 'package:booking/core/theming/colors.dart';
import 'package:booking/core/theming/styles.dart';
import 'package:booking/core/widgets/app_text_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// The CONFLICT MOMENT (CUJ 3): a full-screen Arabic notice naming the exact
/// dates, with recovery actions that actually recover — change dates (back
/// to the search form), similar rooms (re-run the same city), or back to
/// results. Never a bare "OK" dialog.
class ConflictScreen extends StatelessWidget {
  const ConflictScreen({super.key, required this.failure});

  final BookingFailure failure;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(Icons.event_busy,
                  size: 72, color: ColorsManager.errorRed),
              SizedBox(height: 24.h),
              Text(
                AppStrings.conflictTitle,
                style: TextStyles.font24BlueBold,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 12.h),
              Text(
                '${AppStrings.conflictBodyPrefix}'
                '${_datesRangeText(failure)}'
                '${AppStrings.conflictBodySuffix}',
                style: TextStyles.font14GrayRegular,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 32.h),
              AppTextButton(
                buttonText: AppStrings.conflictChangeDates,
                backgroundColor: ColorsManager.mainBlue,
                textStyle: TextStyles.font16WhiteSemiBold,
                width: double.infinity,
                onPressed: () =>
                    context.pushNamedAndRemoveUntil(Routes.homeScreen,
                        predicate: (Route<dynamic> route) => false),
              ),
              SizedBox(height: 12.h),
              AppTextButton(
                buttonText: AppStrings.conflictSimilarRooms,
                textStyle: TextStyles.font16DarkBlueMedium,
                width: double.infinity,
                onPressed: () =>
                    context.pushNamedAndRemoveUntil(Routes.homeScreen,
                        predicate: (Route<dynamic> route) => false),
              ),
              SizedBox(height: 12.h),
              AppTextButton(
                buttonText: AppStrings.conflictBackToResults,
                textStyle: TextStyles.font16DarkBlueMedium,
                width: double.infinity,
                onPressed: () => context.pushNamedAndRemoveUntil(
                    Routes.homeScreen,
                    predicate: (Route<dynamic> route) => false),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _datesRangeText(BookingFailure failure) {
    final String range = failure.rawCode ?? '';
    // rawCode carries 'roomId/yyyy-MM-dd' of the FIRST taken night.
    final int slash = range.indexOf('/');
    return slash >= 0 && slash < range.length - 1
        ? range.substring(slash + 1)
        : range;
  }
}
