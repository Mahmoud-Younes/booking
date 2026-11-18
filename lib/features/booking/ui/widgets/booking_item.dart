import 'package:booking/core/helpers/stay_date.dart';
import 'package:booking/core/localization/app_strings.dart';
import 'package:booking/core/theming/colors.dart';
import 'package:booking/core/theming/styles.dart';
import 'package:booking/core/widgets/app_text_button.dart';
import 'package:booking/features/booking/data/models/booking.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// One booking row: dates, status chip, and the cancel action (active only).
class BookingItem extends StatelessWidget {
  const BookingItem({
    super.key,
    required this.booking,
    required this.cancelling,
    required this.onCancel,
  });

  final Booking booking;
  final bool cancelling;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final bool isCancelled = booking.status == Booking.statusCancelled;
    final StayDateRange range = StayDateRange(
      checkIn: StayDate.fromEpochDay(booking.checkInEpochDay),
      checkOut: StayDate.fromEpochDay(booking.checkOutEpochDay),
    );
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${range.checkIn.display} → ${range.checkOut.display}',
                    style: TextStyles.font16DarkBlueBold),
                Chip(
                  backgroundColor: isCancelled
                      ? ColorsManager.errorRed.withValues(alpha: 0.1)
                      : ColorsManager.successGreen.withValues(alpha: 0.1),
                  label: Text(
                    isCancelled
                        ? AppStrings.cancelledStatus
                        : AppStrings.confirmedStatus,
                    style: TextStyle(
                      color: isCancelled
                          ? ColorsManager.errorRed
                          : ColorsManager.successGreen,
                    ),
                  ),
                ),
              ],
            ),
            Text('${range.nights} ${AppStrings.nightsLabel}',
                style: TextStyles.font14GrayRegular),
            SizedBox(height: 8.h),
            if (!isCancelled)
              AppTextButton(
                buttonText:
                    cancelling ? AppStrings.cancellingBooking : AppStrings.cancelButton,
                textStyle: TextStyle(color: ColorsManager.errorRed),
                width: double.infinity,
                isLoading: cancelling,
                onPressed: onCancel,
              ),
          ],
        ),
      ),
    );
  }
}
