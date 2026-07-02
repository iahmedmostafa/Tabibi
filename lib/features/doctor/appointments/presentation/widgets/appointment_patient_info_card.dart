import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';
import 'package:tabibi/features/doctor/appointments/domain/entities/appointment_details_entity.dart';
import 'package:tabibi/features/doctor/core/widgets/doctor_card.dart';
import 'package:tabibi/features/doctor/core/widgets/doctor_status_badge.dart';
import 'package:tabibi/features/doctor/doctor_appointment_status.dart';

class AppointmentPatientInfoCard extends StatelessWidget {
  final PatientEntity patient;
  final int status;

  const AppointmentPatientInfoCard({
    super.key,
    required this.patient,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final hasImage = patient.avatarUrl != null && patient.avatarUrl!.isNotEmpty;
    final statusLabel = DoctorAppointmentStatus.label(status);
    final statusData = _statusData(status);

    return DoctorCard(
      padding: EdgeInsets.all(16.w),
      child: Row(
        children: [
          Container(
            width: 64.w,
            height: 64.w,
            decoration: BoxDecoration(
              color: isDark ? AppColors.grey800 : AppColors.grey100,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16.r),
              child: hasImage
                  ? CachedNetworkImage(
                      imageUrl: patient.avatarUrl!,
                      fit: BoxFit.cover,
                      placeholder: (_, __) => Center(
                        child: Icon(
                          Icons.person,
                          size: 32.sp,
                          color: isDark ? AppColors.grey400 : AppColors.grey500,
                        ),
                      ),
                      errorWidget: (_, __, ___) => Icon(
                        Icons.person,
                        size: 32.sp,
                        color: isDark ? AppColors.grey400 : AppColors.grey500,
                      ),
                    )
                  : Icon(
                      Icons.person,
                      size: 32.sp,
                      color: isDark ? AppColors.grey400 : AppColors.grey500,
                    ),
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  patient.name,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (patient.email != null && patient.email!.isNotEmpty) ...[
                  SizedBox(height: 4.h),
                  Text(
                    patient.email!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: isDark ? AppColors.grey400 : AppColors.grey500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                SizedBox(height: 8.h),
                DoctorStatusBadge(
                  label: statusLabel,
                  color: statusData.color,
                  backgroundColor: statusData.bgColor,
                ),
              ],
            ),
          ),
        ],
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
