import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';
import 'package:tabibi/features/home/presentation/screen/patient/widgets/soft_card_decoration.dart';

class EmptyUpcomingCard extends StatelessWidget {
  const EmptyUpcomingCard({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18.r),
      child: Ink(
        padding: EdgeInsets.all(14.r),
        decoration: softCardDecoration(),
        child: Row(
          children: [
            Container(
              width: 56.r,
              height: 56.r,
              decoration: BoxDecoration(
                color: AppColors.grey100,
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: const Icon(Iconsax.calendar_1, color: AppColors.primary),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'No upcoming appointments yet',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: AppColors.black,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'Tap to view your bookings.',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.grey500,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: AppColors.grey500,
              size: 24.sp,
            ),
          ],
        ),
      ),
    );
  }
}
