import 'package:booking/core/localization/app_strings.dart';
import 'package:booking/core/theming/colors.dart';
import 'package:booking/core/theming/styles.dart';
import 'package:booking/core/widgets/app_network_image.dart';
import 'package:booking/features/search/data/models/room.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// One room row — image, title, city, capacity, price per night.
class ResultItem extends StatelessWidget {
  const ResultItem({super.key, required this.room, required this.onTap});

  final Room room;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: AppNetworkImage(
                imageUrl: room.imageUrl,
                width: 96.w,
                height: 96.w,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(room.title,
                      style: TextStyles.font16DarkBlueBold,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis),
                  SizedBox(height: 4.h),
                  Text(room.city, style: TextStyles.font14GrayRegular),
                  SizedBox(height: 4.h),
                  Text('${room.capacity} ${AppStrings.guestsLabel}',
                      style: TextStyles.font13BlueRegular),
                  SizedBox(height: 6.h),
                  Text(
                    '${room.pricePerNight} ${AppStrings.perNight}',
                    style: TextStyles.font16DarkBlueBold
                        .copyWith(color: ColorsManager.mainBlue),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
