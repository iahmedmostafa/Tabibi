import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';
import 'package:easy_localization/easy_localization.dart';

class PrescriptionPatientSummaryCard extends StatelessWidget {
  final String patientName;
  final String patientId;
  final String gender;
  final int age;
  final String appointmentId;

  const PrescriptionPatientSummaryCard({
    super.key,
    required this.patientName,
    required this.patientId,
    required this.gender,
    required this.age,
    required this.appointmentId,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: AppColors.midnightBlue,
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.midnightBlue.withValues(alpha: 0.18),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 52.w,
                height: 52.w,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.13),
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.12),
                  ),
                ),
                child: Icon(Iconsax.user, color: Colors.white, size: 25.sp),
              ),
              SizedBox(width: 14.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      patientName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 5.h),
                    Text(
                      patientId,
                      style: TextStyle(
                        color: Colors.white70,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: [
              _PatientChip(icon: Iconsax.profile_2user, label: gender),
              _PatientChip(
                icon: Iconsax.calendar,
                label: age > 0
                    ? 'ageYears'.tr(namedArgs: {'age': age.toString()})
                    : 'ageUnavailable'.tr(),
              ),
              _PatientChip(
                icon: Iconsax.receipt_item,
                label:
                    '${'visitPrefix'.tr()}${_shortAppointmentId(appointmentId)}',
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _shortAppointmentId(String id) {
    if (id.length <= 8) return id;
    return id.substring(0, 8);
  }
}

class _PatientChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _PatientChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 7.h),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.11),
        borderRadius: BorderRadius.circular(999.r),
        border: Border.all(color: Colors.white.withValues(alpha: 0.10)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14.sp, color: Colors.white70),
          SizedBox(width: 6.w),
          Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
