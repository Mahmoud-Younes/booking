import 'package:booking/core/localization/app_strings.dart';
import 'package:booking/core/routing/routes.dart';
import 'package:booking/core/theming/colors.dart';
import 'package:booking/core/theming/styles.dart';
import 'package:booking/core/widgets/app_text_button.dart';
import 'package:booking/features/booking/data/models/booking.dart';
import 'package:booking/core/helpers/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// In-place success state of the confirm screen — Arabic confirmation with
/// the booking summary and recovery actions.
class BookingSuccessView extends StatelessWidget {
  const BookingSuccessView({super.key, required this.booking});

  final Booking booking;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle,
                size: 72, color: ColorsManager.successGreen),
            SizedBox(height: 16.h),
            Text(AppStrings.bookingSuccessTitle,
                style: TextStyles.font24BlueBold),
            SizedBox(height: 8.h),
            Text(AppStrings.bookingSuccessSubtitle,
                style: TextStyles.font14GrayRegular, textAlign: TextAlign.center),
            SizedBox(height: 24.h),
            AppTextButton(
              buttonText: AppStrings.myBookingsTitle,
              backgroundColor: ColorsManager.mainBlue,
              textStyle: TextStyles.font16WhiteSemiBold,
              width: double.infinity,
              onPressed: () => context.pushNamed(Routes.myBookingsScreen),
            ),
            SizedBox(height: 12.h),
            AppTextButton(
              buttonText: AppStrings.conflictBackToResults,
              textStyle: TextStyles.font16DarkBlueMedium,
              width: double.infinity,
              onPressed: () => context.pushNamedAndRemoveUntil(
                Routes.homeScreen,
                predicate: (Route<dynamic> route) => false,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
