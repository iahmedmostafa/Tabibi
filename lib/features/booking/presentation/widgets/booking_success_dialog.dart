import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:tabibi/core/routing/app_routes.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';
import 'package:tabibi/core/widgets/primary_button.dart';
import 'package:tabibi/core/utils/constants/app_strings.dart';

class BookingSuccessDialog extends StatelessWidget {
  const BookingSuccessDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.r)),
      backgroundColor: AppColors.white,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 100.w,
              height: 100.h,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check_rounded,
                color: AppColors.primary,
                size: 60.sp,
              ),
            ),
            SizedBox(height: 24.h),
            Text(
              AppStrings.congratulations,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.dark,
                fontSize: 22.sp,
              ),
            ),
            SizedBox(height: 12.h),
            Text(
              AppStrings.bookingConfirmedMessage,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.grey500,
                fontSize: 14.sp,
              ),
            ),
            SizedBox(height: 32.h),
            PrimaryButton(
              title: AppStrings.done,
              onPress: () {
                context.go(AppRoutes.bottomNavScreen); // Go to home
              },
            ),
            SizedBox(height: 12.h),
            TextButton(
              onPressed: () {
                context.go(
                  AppRoutes.bottomNavScreen,
                  extra: 2,
                ); // Close dialog to edit
              },
              child: Text(
                AppStrings.editAppointment,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.grey500,
                  fontSize: 14.sp,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
