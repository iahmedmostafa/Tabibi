import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';
import 'package:tabibi/core/utils/theme/theme.dart';
import 'package:tabibi/features/doctor/appointments/domain/entities/appointment_details_entity.dart';

class AppointmentInfoCard extends StatelessWidget {
  final AppointmentDetailsEntity details;

  const AppointmentInfoCard({super.key, required this.details});

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final typeLabel = details.type == 1 ? 'Consultation' : 'Follow-up';
    final statusLabel = _statusLabel(details.status);
    final statusColor = _statusColor(details.status);
    final statusBg = _statusBg(details.status);

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Appointment Information', style: tt.titleLarge?.copyWith(color: AppColors.grey800)),
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
                child: Icon(Icons.info_outline, color: statusColor, size: 20.sp),
              ),
              SizedBox(width: 16.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Status', style: tt.labelSmall?.copyWith(color: AppColors.grey500)),
                  SizedBox(height: 4.h),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 3.h),
                    decoration: BoxDecoration(
                      color: statusBg,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Text(
                      statusLabel,
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
              Text(label, style: tt.labelSmall?.copyWith(color: AppColors.grey500)),
              SizedBox(height: 4.h),
              Text(value, style: tt.bodyMedium?.copyWith(height: 1.4, color: AppColors.grey800)),
            ],
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime dt) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[dt.month - 1]} ${dt.day.toString().padLeft(2, '0')}, ${dt.year}';
  }

  String _formatTime(DateTime dt) {
    final h = dt.hour;
    final m = dt.minute.toString().padLeft(2, '0');
    final hour = h > 12 ? h - 12 : h == 0 ? 12 : h;
    final period = h >= 12 ? 'PM' : 'AM';
    return '$hour:$m $period';
  }

  String _statusLabel(int status) {
    switch (status) {
      case 1: return 'Pending';
      case 2: return 'Approved';
      case 3: return 'Completed';
      case 4: return 'Cancelled';
      default: return 'Unknown';
    }
  }

  Color _statusColor(int status) {
    switch (status) {
      case 1: return AppTheme.blueIcon;
      case 2: return AppTheme.greenIcon;
      case 3: return AppTheme.purpleIcon;
      case 4: return AppTheme.redIcon;
      default: return Colors.grey;
    }
  }

  Color _statusBg(int status) {
    switch (status) {
      case 1: return AppTheme.bluePastel;
      case 2: return AppTheme.greenPastel;
      case 3: return AppTheme.purplePastel;
      case 4: return AppTheme.redPastel;
      default: return Colors.grey.shade100;
    }
  }
}
