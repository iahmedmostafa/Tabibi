import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:tabibi/core/routing/app_routes.dart';
import 'package:tabibi/core/utils/theme/theme.dart';

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
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {
              context.push(AppRoutes.callPage, extra: {'bookingId': bookingId});
            },
            icon: const Icon(Icons.videocam_outlined),
            label: const Text('Start Consultation'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1A2B42),
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 16.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
              textStyle: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        SizedBox(height: 16.h),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {},
                icon: Icon(Icons.calendar_today, size: 18.sp),
                label: const Text('Reschedule'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.onSurface,
                  side: BorderSide(color: Theme.of(context).dividerColor),

                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {},
                icon: Icon(Icons.cancel_outlined, size: 18.sp),
                label: const Text('Cancel'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppTheme.redIcon,
                  side: const BorderSide(color: AppTheme.redPastel),
                  backgroundColor: AppTheme.redPastel.withValues(alpha: 0.1),
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        SizedBox(
          width: double.infinity,
          child: TextButton.icon(
            onPressed: () => context.pushNamed(
              AppRoutes.doctorChat,
              extra: {
                'patientId': patientId,
                'patientName': patientName,
                'patientImage': patientImage,
              },
            ),

            icon: Icon(Icons.chat_bubble_outline, size: 20.sp),
            label: const Text('Message Patient'),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.onSurfaceVariant,
              backgroundColor: Theme.of(
                context,
              ).colorScheme.surfaceContainerHighest,

              padding: EdgeInsets.symmetric(vertical: 16.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
