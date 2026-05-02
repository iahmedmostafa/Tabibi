import 'package:flutter/material.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';
import 'package:tabibi/core/utils/theme/theme.dart';
import 'package:tabibi/features/doctor/doctor_appointment_status.dart';

class DoctorStatusUtils {
  DoctorStatusUtils._();

  static Color getStatusColor(int status) {
    switch (status) {
      case DoctorAppointmentStatus.upcoming:
        return AppTheme.blueIcon;
      case DoctorAppointmentStatus.completed:
        return AppTheme.greenIcon;
      case DoctorAppointmentStatus.refunded:
        return AppTheme.redIcon;
      default:
        return AppColors.grey500;
    }
  }

  static Color getStatusBackgroundColor(int status) {
    switch (status) {
      case DoctorAppointmentStatus.upcoming:
        return AppTheme.blueIcon.withValues(alpha: 0.15);
      case DoctorAppointmentStatus.completed:
        return AppTheme.greenIcon.withValues(alpha: 0.15);
      case DoctorAppointmentStatus.refunded:
        return AppTheme.redIcon.withValues(alpha: 0.15);
      default:
        return AppColors.grey500.withValues(alpha: 0.15);
    }
  }
}
