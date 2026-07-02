import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:tabibi/core/routing/app_routes.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';
import 'package:tabibi/features/doctor/core/widgets/animated_fade_slide.dart';
import 'package:tabibi/features/doctor/dashboard/domain/entities/appointment.dart';
import 'package:tabibi/features/doctor/doctor_appointment_status.dart';
import 'package:tabibi/features/doctor/core/widgets/doctor_status_badge.dart';

class AppointmentCard extends StatelessWidget {
  final Appointment appointment;

  const AppointmentCard({super.key, required this.appointment});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final statusData = _statusData(appointment.status);

    return AnimatedFadeSlide(
      offset: 20,
      child: GestureDetector(
        onTap: () =>
            context.push(AppRoutes.doctorAppointmentDetails, extra: appointment),
        child: Container(
          margin: EdgeInsets.only(bottom: 16.h),
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(18.r),
            border: Border.all(
              color: isDark ? AppColors.grey800 : AppColors.black.withValues(alpha: 0.1),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.28 : 0.05),
                blurRadius: isDark ? 18 : 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 60.w,
                height: 60.w,
                decoration: BoxDecoration(
                  color: isDark ? AppColors.grey800 : AppColors.grey100,
                  borderRadius: BorderRadius.circular(14.r),
                ),
                child: Icon(
                  Icons.person_outline,
                  color: isDark ? AppColors.grey400 : AppColors.grey500,
                  size: 28.sp,
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            appointment.patientName,
                            style: theme.textTheme.titleLarge?.copyWith(
                              color: isDark ? AppColors.white : AppColors.grey900,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        DoctorStatusBadge(
                          label: appointment.statusLabel,
                          color: statusData.color,
                          backgroundColor: statusData.bgColor,
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 16.sp,
                          color: AppColors.grey400,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          '${appointment.time} \u2022 ${appointment.date}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: isDark ? AppColors.grey400 : AppColors.grey500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _StatusColors _statusData(int status) {
    switch (status) {
      case DoctorAppointmentStatus.upcoming:
        return _StatusColors(AppColors.blue, AppColors.paleBlueLight);
      case DoctorAppointmentStatus.completed:
        return _StatusColors(AppColors.actionGreen, AppColors.successLight);
      case DoctorAppointmentStatus.refunded:
        return _StatusColors(AppColors.error, AppColors.lightPink);
      default:
        return _StatusColors(AppColors.grey400, AppColors.grey100);
    }
  }
}

class _StatusColors {
  final Color color;
  final Color bgColor;
  const _StatusColors(this.color, this.bgColor);
}
