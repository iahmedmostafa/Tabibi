import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:tabibi/core/routing/app_routes.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';
import 'package:tabibi/core/widgets/primary_button.dart';

class BookingSuccessScreen extends StatelessWidget {
  const BookingSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 150.w,
              height: 150.h,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check_rounded,
                color: AppColors.primary,
                size: 80.sp,
              ),
            ),
            SizedBox(height: 32.h),
            Text(
              "Congratulations!",
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.dark,
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              "Your appointment with Dr. David Patel is confirmed for June 30, 2023, at 10:00 AM.",
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(color: AppColors.grey500),
            ),
            SizedBox(height: 48.h),
            PrimaryButton(
              title: "Done",
              onPress: () {
                context.go(AppRoutes.patientHome); // Or wherever home is
              },
            ),
            SizedBox(height: 16.h),
            TextButton(
              onPressed: () {
                // Edit appointment logic
              },
              child: Text(
                "Edit your appointment",
                style: TextStyle(color: AppColors.grey500, fontSize: 14.sp),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
