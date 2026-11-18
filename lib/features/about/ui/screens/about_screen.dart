import 'package:booking/core/localization/app_strings.dart';
import 'package:booking/core/theming/colors.dart';
import 'package:booking/core/theming/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// «عن التطبيق» — the in-app project identity: what this app is, what it
/// does, and the engineering guarantee behind it. Written so any reviewer
/// (technical or not) understands the project within one screen.
class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppStrings.aboutTitle)),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Identity block.
            Column(
              children: [
                CircleAvatar(
                  radius: 36.r,
                  backgroundColor: ColorsManager.mainBlue,
                  child:
                      Icon(Icons.hotel, color: ColorsManager.white, size: 36.sp),
                ),
                SizedBox(height: 12.h),
                Text(AppStrings.aboutAppName, style: TextStyles.font32BlueBold),
                SizedBox(height: 4.h),
                Text(
                  AppStrings.aboutTagline,
                  style: TextStyles.font14GrayRegular,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            SizedBox(height: 24.h),
            _Section(
                title: AppStrings.aboutWhatTitle,
                body: AppStrings.aboutWhatBody),
            // The core guarantee — highlighted card, first thing a reviewer
            // should quote about this project.
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: ColorsManager.mainBlue.withAlpha(15),
                borderRadius: BorderRadius.circular(12.r),
                border:
                    Border.all(color: ColorsManager.mainBlue.withAlpha(60)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.verified_outlined,
                          color: ColorsManager.mainBlue, size: 20.sp),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Text(AppStrings.aboutGuaranteeTitle,
                            style: TextStyles.font16DarkBlueBold),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Text(AppStrings.aboutGuaranteeBody,
                      style: TextStyles.font14DarkBlueMedium),
                ],
              ),
            ),
            SizedBox(height: 16.h),
            _Section(
              title: AppStrings.aboutFeaturesTitle,
              bullets: const [
                AppStrings.aboutFeatureSearch,
                AppStrings.aboutFeatureFilters,
                AppStrings.aboutFeatureNights,
                AppStrings.aboutFeatureConflict,
                AppStrings.aboutFeatureCancel,
                AppStrings.aboutFeatureOffline,
              ],
            ),
            _Section(
                title: AppStrings.aboutStackTitle,
                body: AppStrings.aboutStackBody),
            _Section(
                title: AppStrings.aboutReviewersTitle,
                body: AppStrings.aboutReviewersBody),
            SizedBox(height: 8.h),
            Text(
              AppStrings.aboutFooter,
              style: TextStyles.font13BlueRegular,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16.h),
          ],
        ),
      ),
    );
  }
}

/// One titled block: optional paragraph plus optional bullet list.
class _Section extends StatelessWidget {
  const _Section({required this.title, this.body, this.bullets = const []});

  final String title;
  final String? body;
  final List<String> bullets;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyles.font16DarkBlueBold),
        SizedBox(height: 8.h),
        if (body != null)
          Text(body!, style: TextStyles.font14GrayRegular),
        ...bullets.map(
          (String item) => Padding(
            padding: EdgeInsets.only(top: 6.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.check_circle_outline,
                    color: ColorsManager.mainBlue, size: 16.sp),
                SizedBox(width: 8.w),
                Expanded(
                    child: Text(item, style: TextStyles.font14GrayRegular)),
              ],
            ),
          ),
        ),
        SizedBox(height: 16.h),
      ],
    );
  }
}
