import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:tabibi/core/routing/app_routes.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';
import 'package:tabibi/features/doctor/appointments/presentation/cubit/appointment_details_cubit.dart';
import 'package:tabibi/features/doctor/patients/domain/entities/patient.dart';
import 'package:tabibi/features/doctor/prescription/presentation/policies/prescription_write_policy.dart';

class ViewPatientProfileButton extends StatelessWidget {
  final String appointmentId;
  final DateTime appointmentDate;
  final Patient patient;
  final PrescriptionWritePolicy prescriptionWritePolicy;

  const ViewPatientProfileButton({
    super.key,
    required this.appointmentId,
    required this.appointmentDate,
    required this.patient,
    required this.prescriptionWritePolicy,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: double.infinity,
      height: 52.h,
      child: ElevatedButton.icon(
        onPressed: () async {
          final completed = await context.pushNamed(
            AppRoutes.doctorPatientProfile,
            extra: {
              'patient': patient,
              'appointmentId': appointmentId,
              'appointmentDate': appointmentDate,
              'prescriptionWritePolicy': prescriptionWritePolicy,
            },
          );
          if (context.mounted) {
            context
                .read<AppointmentDetailsCubit>()
                .handlePatientProfileRouteResult(
                  appointmentId: appointmentId,
                  result: completed,
                );
          }
        },
        icon: Icon(Icons.person_search_outlined, size: 20.sp),
        label: Text(
          'viewPatientProfile'.tr(),
          style: theme.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w700,
            letterSpacing: 0.3,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 4,
          shadowColor: AppColors.primary.withValues(alpha: 0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(60.r),
          ),
          padding: EdgeInsets.symmetric(horizontal: 24.w),
        ),
      ),
    );
  }
}
