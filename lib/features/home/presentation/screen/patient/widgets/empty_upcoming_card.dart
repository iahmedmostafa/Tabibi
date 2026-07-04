import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';
import 'package:tabibi/features/home/presentation/screen/patient/widgets/soft_card_decoration.dart';
import 'package:easy_localization/easy_localization.dart';

class EmptyUpcomingCard extends StatelessWidget {
  const EmptyUpcomingCard({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18.r),
      child: Ink(
        padding: EdgeInsets.all(14.r),
        decoration: softCardDecoration(context),
        child: Row(
          children: [
            Container(
              width: 56.r,
              height: 56.r,
              decoration: BoxDecoration(
                color: isDark ? AppColors.grey800 : AppColors.grey100,
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
                    'noUpcomingAppointments'.tr(),
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: isDark ? AppColors.white : AppColors.black,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'tapToViewBookings'.tr(),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: isDark ? AppColors.grey400 : AppColors.grey500,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: isDark ? AppColors.grey400 : AppColors.grey500,
              size: 24.sp,
            ),
          ],
        ),
      ),
    );
  }
}
