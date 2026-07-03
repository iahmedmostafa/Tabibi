import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';
import 'package:tabibi/features/doctor/appointments/domain/entities/appointment_details_entity.dart';
import 'package:tabibi/features/doctor/core/widgets/doctor_card.dart';
import 'package:tabibi/features/doctor/core/widgets/doctor_status_badge.dart';
import 'package:tabibi/features/doctor/doctor_appointment_status.dart';

class AppointmentInfoCard extends StatelessWidget {
  final AppointmentDetailsEntity details;

  const AppointmentInfoCard({
    super.key,
    required this.details,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final typeLabel = details.type == 1 ? 'Video Call' : 'Consultation';
    final statusLabel = DoctorAppointmentStatus.label(details.status);
    final statusData = _statusData(details.status);

    return DoctorCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Appointment Information',
            style: theme.textTheme.titleLarge,
          ),
          SizedBox(height: 16.h),
          _buildInfoRow(
            context: context,
            icon: Icons.calendar_today,
            iconColor: AppColors.blue,
            bgIconColor: AppColors.paleBlueLight,
            label: 'Date',
            value: _formatDate(details.appointmentDate),
          ),
          SizedBox(height: 16.h),
          _buildInfoRow(
            context: context,
            icon: Icons.access_time,
            iconColor: AppColors.actionAmber,
            bgIconColor: AppColors.actionOrangeLight,
            label: 'Time',
            value: _formatTime(details.appointmentDate),
          ),
          SizedBox(height: 16.h),
          _buildInfoRow(
            context: context,
            icon: Icons.medical_services_outlined,
            iconColor: AppColors.actionGreen,
            bgIconColor: AppColors.successLight,
            label: 'Type',
            value: typeLabel,
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: statusData.bgColor,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  Icons.info_outline,
                  color: statusData.color,
                  size: 20.sp,
                ),
              ),
              SizedBox(width: 16.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Status',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: isDark ? AppColors.grey400 : AppColors.grey500,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  DoctorStatusBadge(
                    label: statusLabel,
                    color: statusData.color,
                    backgroundColor: statusData.bgColor,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required BuildContext context,
    required IconData icon,
    required Color iconColor,
    required Color bgIconColor,
    required String label,
    required String value,
  }) {
    final theme = Theme.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(10.w),
          decoration: BoxDecoration(
            color: bgIconColor,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Icon(icon, color: iconColor, size: 20.sp),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: isDark ? AppColors.grey400 : AppColors.grey500,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                value,
                style: theme.textTheme.bodyMedium?.copyWith(
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime dt) {
    final localDateTime = dt.toLocal();
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[localDateTime.month - 1]} ${localDateTime.day.toString().padLeft(2, '0')}, ${localDateTime.year}';
  }

  String _formatTime(DateTime dt) {
    final localDateTime = dt.toLocal();
    final h = localDateTime.hour;
    final m = localDateTime.minute.toString().padLeft(2, '0');
    final hour = h > 12
        ? h - 12
        : h == 0
        ? 12
        : h;
    final period = h >= 12 ? 'PM' : 'AM';
    return '$hour:$m $period';
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
