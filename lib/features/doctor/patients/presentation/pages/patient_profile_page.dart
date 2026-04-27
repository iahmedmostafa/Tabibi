import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tabibi/core/routing/app_routes.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';
import 'package:tabibi/core/utils/theme/theme.dart';
import 'package:tabibi/features/doctor/patients/domain/entities/patient.dart';
import 'package:tabibi/features/doctor/patients/presentation/widgets/allergies_card.dart';
import 'package:tabibi/features/doctor/patients/presentation/widgets/contact_information_card.dart';
import 'package:tabibi/features/doctor/patients/presentation/widgets/documents_card.dart';
import 'package:tabibi/features/doctor/patients/presentation/widgets/medical_history_card.dart';
import 'package:tabibi/features/doctor/patients/presentation/widgets/patient_header_card.dart';
import 'package:tabibi/features/doctor/patients/presentation/widgets/previous_visits_card.dart';
import 'package:tabibi/features/doctor/prescription/presentation/pages/create_prescription_args.dart';

class PatientProfilePage extends StatefulWidget {
  final Patient patient;
  final String? appointmentId;
  final bool canWritePrescription;

  const PatientProfilePage({
    super.key,
    required this.patient,
    this.appointmentId,
    this.canWritePrescription = true,
  });

  @override
  State<PatientProfilePage> createState() => _PatientProfilePageState();
}

class _PatientProfilePageState extends State<PatientProfilePage> {
  bool _prescriptionCompleted = false;

  void _popProfile() {
    context.pop(_prescriptionCompleted ? true : null);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _popProfile();
      },
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          title: Text('Patient Profile', style: TextStyle(fontSize: 20.sp)),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, size: 24.sp, color: Colors.black),
            onPressed: _popProfile,
          ),
          actions: [
            TextButton(
              onPressed: () {},
              child: Text(
                'Edit',
                style: TextStyle(color: AppTheme.primaryColor, fontSize: 16.sp),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PatientHeaderCard(patient: widget.patient),
              SizedBox(height: 16.h),
              if (widget.appointmentId != null &&
                  widget.canWritePrescription &&
                  !_prescriptionCompleted) ...[
                _WritePrescriptionButton(
                  appointmentId: widget.appointmentId!,
                  patient: widget.patient,
                  onPrescriptionCompleted: () {
                    setState(() => _prescriptionCompleted = true);
                  },
                ),
                SizedBox(height: 16.h),
              ],
              ContactInformationCard(patient: widget.patient),
              SizedBox(height: 16.h),
              MedicalHistoryCard(patient: widget.patient),
              SizedBox(height: 16.h),
              AllergiesCard(patient: widget.patient),
              SizedBox(height: 16.h),
              PreviousVisitsCard(patient: widget.patient),
              SizedBox(height: 16.h),
              const DocumentsCard(),
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }
}

class _WritePrescriptionButton extends StatelessWidget {
  final String appointmentId;
  final Patient patient;
  final VoidCallback onPrescriptionCompleted;

  const _WritePrescriptionButton({
    required this.appointmentId,
    required this.patient,
    required this.onPrescriptionCompleted,
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
                      'Prescription Required',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.grey900,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: 3.h),
                    Text(
                      'Finalize diagnosis and medicines for this visit.',
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
              onPressed: () async {
                final completed = await context.pushNamed(
                  AppRoutes.doctorCreatePrescription,
                  extra: CreatePrescriptionArgs(
                    appointmentId: appointmentId,
                    patient: patient,
                  ),
                );
                if (completed == true) {
                  onPrescriptionCompleted();
                }
              },
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
