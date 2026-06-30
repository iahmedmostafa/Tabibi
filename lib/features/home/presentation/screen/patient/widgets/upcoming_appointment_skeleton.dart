import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';
import 'package:tabibi/features/home/presentation/screen/patient/widgets/soft_card_decoration.dart';

class UpcomingAppointmentSkeleton extends StatelessWidget {
  const UpcomingAppointmentSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final skeletonColor = isDark ? AppColors.grey800 : Colors.white;

    return Skeletonizer(
      enabled: true,
      child: Container(
        padding: EdgeInsets.all(14.r),
        decoration: softCardDecoration(context),
        child: Row(
          children: [
            Container(
              width: 78.r,
              height: 78.r,
              decoration: BoxDecoration(
                color: skeletonColor,
                borderRadius: BorderRadius.circular(16.r),
              ),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 120.w,
                        height: 16.h,
                        color: skeletonColor,
                      ),
                      const Spacer(),
                      Container(
                        width: 60.w,
                        height: 20.h,
                        decoration: BoxDecoration(
                          color: skeletonColor,
                          borderRadius: BorderRadius.circular(999.r),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 6.h),
                  Container(width: 100.w, height: 12.h, color: skeletonColor),
                  SizedBox(height: 10.h),
                  Row(
                    children: [
                      Icon(Iconsax.calendar_1, size: 15, color: AppColors.grey500),
                      SizedBox(width: 5.w),
                      Container(width: 60.w, height: 12.h, color: skeletonColor),
                      SizedBox(width: 10.w),
                      Icon(Iconsax.clock, size: 15, color: AppColors.grey500),
                      SizedBox(width: 5.w),
                      Container(width: 50.w, height: 12.h, color: skeletonColor),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Container(width: 70.w, height: 12.h, color: skeletonColor),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
