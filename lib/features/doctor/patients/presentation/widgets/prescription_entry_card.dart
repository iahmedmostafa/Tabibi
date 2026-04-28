import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tabibi/core/routing/app_routes.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';
import 'package:tabibi/features/doctor/patients/domain/entities/patient.dart';
import 'package:tabibi/features/doctor/prescription/presentation/pages/create_prescription_args.dart';
import 'package:tabibi/features/doctor/prescription/presentation/policies/prescription_write_policy.dart';

class PrescriptionEntryCard extends StatelessWidget {
  final String appointmentId;
  final DateTime? appointmentDate;
  final Patient patient;
  final PrescriptionWritePolicy policy;
  final ValueChanged<Object?> onPrescriptionRouteResult;

  const PrescriptionEntryCard({
    super.key,
    required this.appointmentId,
    required this.appointmentDate,
    required this.patient,
    required this.policy,
    required this.onPrescriptionRouteResult,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: AppColors.grey200),
        boxShadow: [
          BoxShadow(
            color: AppColors.midnightBlue.withValues(alpha: 0.08),
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
                width: 46.w,
                height: 46.w,
                decoration: BoxDecoration(
                  color: AppColors.teal.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(14.r),
                ),
                child: Icon(
                  Iconsax.document_text,
                  color: AppColors.teal,
                  size: 23.sp,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      policy.canWrite
                          ? 'Prescription Required'
                          : 'Prescription Unavailable',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.grey900,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: 3.h),
                    Text(
                      policy.canWrite
                          ? 'Finalize diagnosis and medicines for this visit.'
                          : policy.disabledMessage ??
                              'Prescription cannot be written for this appointment.',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.grey500,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: policy.canWrite
                  ? () async {
                      final completed = await context.pushNamed(
                        AppRoutes.doctorCreatePrescription,
                        extra: CreatePrescriptionArgs(
                          appointmentId: appointmentId,
                          patient: patient,
                          appointmentDate: appointmentDate,
                        ),
                      );
                      onPrescriptionRouteResult(completed);
                    }
                  : null,
              icon: Icon(Iconsax.edit_2, size: 18.sp),
              label: const Text('Write Prescription'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.midnightBlue,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 14.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                textStyle: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
