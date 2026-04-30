import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibi/core/utils/theme/theme.dart';
import 'package:tabibi/features/doctor/doctor_appointment_status.dart';
import 'package:tabibi/features/doctor/appointments/domain/entities/appointment_details_entity.dart';

class AppointmentInfoCard extends StatelessWidget {
  final AppointmentDetailsEntity details;

  const AppointmentInfoCard({
    super.key,
    required this.details,
  });

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final typeLabel = details.type == 1 ? 'Video Call' : 'Consultation';
    final statusColor = _statusColor(details.status);
    final statusBg = _statusBg(details.status);

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Appointment Information',
            style: tt.titleLarge?.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 16.h),
          _buildInfoRow(
            context: context,
            icon: Icons.calendar_today,
            iconColor: AppTheme.blueIcon,
            bgIconColor: AppTheme.bluePastel,
            label: 'Date',
            value: _formatDate(details.appointmentDate),
            
          ),
          SizedBox(height: 16.h),
          _buildInfoRow(
            context: context,
            icon: Icons.access_time,
          
            iconColor: AppTheme.orangeIcon,
            bgIconColor: AppTheme.orangePastel,
            label: 'Time',
            value: _formatTime(details.appointmentDate),
          ),
          SizedBox(height: 16.h),
          _buildInfoRow(
            context: context,
            icon: Icons.medical_services_outlined,
            iconColor: AppTheme.greenIcon,
            bgIconColor: AppTheme.greenPastel,
            label: 'Type',
            value: typeLabel,
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: statusBg,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  Icons.info_outline,
                  color: statusColor,
                  size: 20.sp,
                ),
              ),
              SizedBox(width: 16.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Status',
                    style: tt.labelSmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 3.h,
                    ),
                    decoration: BoxDecoration(
                      color: statusBg,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Text(
                      DoctorAppointmentStatus.label(details.status),
                      style: tt.bodySmall?.copyWith(color: statusColor),
                    ),
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
    final tt = Theme.of(context).textTheme;
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
                style: tt.labelSmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                value,
                style: tt.bodyMedium?.copyWith(
                  height: 1.4,
                  color: Theme.of(context).colorScheme.onSurface,
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

  Color _statusColor(int status) {
    switch (status) {
      case DoctorAppointmentStatus.upcoming:
        return AppTheme.blueIcon;
      case DoctorAppointmentStatus.completed:
        return AppTheme.greenIcon;
      case DoctorAppointmentStatus.refunded:
        return AppTheme.redIcon;
      default:
        return Colors.grey;
    }
  }

  Color _statusBg(int status) {
    switch (status) {
      case DoctorAppointmentStatus.upcoming:
        return AppTheme.bluePastel;
      case DoctorAppointmentStatus.completed:
        return AppTheme.greenPastel;
      case DoctorAppointmentStatus.refunded:
        return AppTheme.redPastel;
      default:
        return Colors.grey.shade100;
    }
  }
}
