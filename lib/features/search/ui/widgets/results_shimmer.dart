import 'package:booking/core/widgets/shimmer_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Loading skeleton for the results list (shimmer).
class ResultsShimmer extends StatelessWidget {
  const ResultsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.all(16.w),
      itemCount: 6,
      itemBuilder: (BuildContext context, int index) => Row(
        children: [
          ShimmerBox(width: 96.w, height: 96.w, radius: 12),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerBox(width: double.infinity, height: 16.h),
                SizedBox(height: 8.h),
                ShimmerBox(width: 120.w, height: 12.h),
                SizedBox(height: 8.h),
                ShimmerBox(width: 80.w, height: 14.h),
              ],
            ),
          ),
        ],
      ),
      separatorBuilder: (BuildContext context, int index) => SizedBox(height: 12.h),
    );
  }
}
