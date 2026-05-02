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
        return AppColors.grey400;
    }
  }

  static Color getStatusBackgroundColor(int status) {
    switch (status) {
      case DoctorAppointmentStatus.upcoming:
        return AppTheme.bluePastel;
      case DoctorAppointmentStatus.completed:
        return AppTheme.greenPastel;
      case DoctorAppointmentStatus.refunded:
        return AppTheme.redPastel;
      default:
        return Colors.grey.shade200;
    }
  }
}
