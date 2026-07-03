import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:tabibi/core/routing/app_routes.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';

class AppointmentActionButtons extends StatelessWidget {
  final String patientId;
  final String patientName;
  final String? patientImage;
  final String bookingId;

  const AppointmentActionButtons({
    super.key,
    required this.patientId,
    required this.patientName,
    this.patientImage,
    required this.bookingId,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 50.h,
          child: ElevatedButton.icon(
            onPressed: () {
              context.push(AppRoutes.callPage, extra: {'bookingId': bookingId});
            },
            icon: Icon(Icons.videocam_outlined, size: 20.sp),
            label: Text('Start Consultation', style: theme.textTheme.labelLarge),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(22.r),
              ),
            ),
          ),
        ),
        SizedBox(height: 16.h),
        Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 46.h,
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.calendar_today, size: 18.sp),
                  label: Text('Reschedule', style: TextStyle(fontSize: 14.sp)),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: isDark ? AppColors.white : AppColors.grey900,
                    side: BorderSide(
                      color: isDark ? AppColors.grey700 : AppColors.grey300,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(22.r),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: SizedBox(
                height: 46.h,
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.cancel_outlined, size: 18.sp),
                  label: Text('Cancel', style: TextStyle(fontSize: 14.sp)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.lightPink,
                    foregroundColor: AppColors.error,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(22.r),
                    ),
                    elevation: 0,
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        SizedBox(
          width: double.infinity,
          height: 50.h,
          child: OutlinedButton.icon(
            onPressed: () => context.pushNamed(
              AppRoutes.doctorChat,
              extra: {
                'patientId': patientId,
                'patientName': patientName,
                'patientImage': patientImage,
              },
            ),
            icon: Icon(Icons.chat_bubble_outline, size: 20.sp),
            label: Text('Message Patient', style: TextStyle(fontSize: 14.sp)),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primary,
              side: BorderSide(color: AppColors.paleBlueLight),
              backgroundColor: AppColors.paleBlueLight,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(22.r),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
