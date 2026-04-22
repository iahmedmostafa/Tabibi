import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibi/core/utils/theme/theme.dart';
import 'package:tabibi/features/doctor/appointments/domain/entities/appointment_details_entity.dart';

class AppointmentPatientInfoCard extends StatelessWidget {
  final PatientEntity patient;
  final bool isUpcoming;

  const AppointmentPatientInfoCard({
    super.key,
    required this.patient,
    required this.isUpcoming,
  });

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final hasImage = patient.avatarUrl != null && patient.avatarUrl!.isNotEmpty;
    final statusLabel = isUpcoming ? 'Upcoming' : 'Completed';
    final statusColor = isUpcoming ? AppTheme.blueIcon : AppTheme.greenIcon;
    final statusBg = isUpcoming ? AppTheme.bluePastel : AppTheme.greenPastel;

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 64.w,
            height: 64.w,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: hasImage
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(12.r),
                    child: CachedNetworkImage(
                      imageUrl: patient.avatarUrl!,
                      fit: BoxFit.cover,
                      placeholder: (_, __) => const Center(
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      errorWidget: (_, __, ___) =>
                          Icon(Icons.person, size: 32.sp, color: Colors.grey[400]),
                    ),
                  )
                : Icon(Icons.person, size: 32.sp, color: Colors.grey[400]),
          ),
          SizedBox(width: 16.w),
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  patient.name,
                  style: tt.bodyLarge?.copyWith(color: Colors.black),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (patient.email != null && patient.email!.isNotEmpty) ...[
                  SizedBox(height: 4.h),
                  Text(
                    patient.email!,
                    style: tt.labelSmall?.copyWith(color: Colors.grey[600]),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                SizedBox(height: 8.h),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: statusBg,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: Text(
                    statusLabel,
                    style: tt.bodySmall?.copyWith(color: statusColor),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
