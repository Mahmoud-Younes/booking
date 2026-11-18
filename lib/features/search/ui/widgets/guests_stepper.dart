import 'package:booking/core/localization/app_strings.dart';
import 'package:booking/core/theming/colors.dart';
import 'package:booking/core/theming/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// One guests stepper (the adults/children/rooms triple selector was cut —
/// one number feeds `capacity >= guests`).
class GuestsStepper extends StatelessWidget {
  const GuestsStepper({super.key, required this.guests, required this.onChanged});

  final int guests;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: ColorsManager.offWhite,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: ColorsManager.lightGray),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(AppStrings.guestsLabel, style: TextStyles.font14DarkBlueMedium),
          Row(
            children: [
              IconButton(
                onPressed: guests > 1 ? () => onChanged(guests - 1) : null,
                icon: const Icon(Icons.remove_circle_outline,
                    color: ColorsManager.mainBlue),
              ),
              Text('$guests', style: TextStyles.font16DarkBlueBold),
              IconButton(
                onPressed: () => onChanged(guests + 1),
                icon: const Icon(Icons.add_circle_outline,
                    color: ColorsManager.mainBlue),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
