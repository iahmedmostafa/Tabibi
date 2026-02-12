import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';
import 'package:tabibi/core/utils/constants/app_strings.dart';

class EmptyPrescriptionView extends StatelessWidget {
  const EmptyPrescriptionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.r),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Iconsax.document, size: 64.sp, color: AppColors.grey300),
            SizedBox(height: 16.h),
            Text(
              AppStrings.noPrescriptionFound,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.grey500,
                fontSize: 16.sp,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
