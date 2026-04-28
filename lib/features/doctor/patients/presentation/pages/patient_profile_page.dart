import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:tabibi/core/utils/theme/theme.dart';
import 'package:tabibi/features/doctor/patients/domain/entities/patient.dart';
import 'package:tabibi/features/doctor/patients/presentation/cubit/patient_profile_flow_cubit.dart';
import 'package:tabibi/features/doctor/patients/presentation/widgets/allergies_card.dart';
import 'package:tabibi/features/doctor/patients/presentation/widgets/contact_information_card.dart';
import 'package:tabibi/features/doctor/patients/presentation/widgets/documents_card.dart';
import 'package:tabibi/features/doctor/patients/presentation/widgets/medical_history_card.dart';
import 'package:tabibi/features/doctor/patients/presentation/widgets/patient_header_card.dart';
import 'package:tabibi/features/doctor/patients/presentation/widgets/prescription_entry_card.dart';
import 'package:tabibi/features/doctor/patients/presentation/widgets/previous_visits_card.dart';
import 'package:tabibi/features/doctor/prescription/presentation/policies/prescription_write_policy.dart';

class PatientProfilePage extends StatelessWidget {
  final Patient patient;
  final String? appointmentId;
  final DateTime? appointmentDate;
  final PrescriptionWritePolicy prescriptionWritePolicy;

  const PatientProfilePage({
    super.key,
    required this.patient,
    this.appointmentId,
    this.appointmentDate,
    this.prescriptionWritePolicy = const PrescriptionWritePolicy.allowed(),
  });

  void _popProfile(BuildContext context) {
    final result = context.read<PatientProfileFlowCubit>().state.popResult;
    context.pop(result);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PatientProfileFlowCubit(),
      child: Builder(
        builder: (context) {
          return PopScope(
            canPop: false,
            onPopInvokedWithResult: (didPop, result) {
              if (didPop) return;
              _popProfile(context);
            },
            child: Scaffold(
              backgroundColor: Colors.grey[50],
              appBar: AppBar(
                title: Text(
                  'Patient Profile',
                  style: TextStyle(fontSize: 20.sp),
                ),
                centerTitle: true,
                backgroundColor: Colors.white,
                elevation: 0,
                leading: IconButton(
                  icon: Icon(Icons.arrow_back, size: 24.sp, color: Colors.black),
                  onPressed: () => _popProfile(context),
                ),
                actions: [
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'Edit',
                      style: TextStyle(
                        color: AppTheme.primaryColor,
                        fontSize: 16.sp,
                      ),
                    ),
                  ),
                ],
              ),
              body: SingleChildScrollView(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PatientHeaderCard(patient: patient),
                    SizedBox(height: 16.h),
                    if (appointmentId != null)
                      BlocBuilder<
                        PatientProfileFlowCubit,
                        PatientProfileFlowState
                      >(
                        builder: (context, flowState) {
                          if (flowState.prescriptionCompleted) {
                            return const SizedBox.shrink();
                          }

                          return Column(
                            children: [
                              PrescriptionEntryCard(
                                appointmentId: appointmentId!,
                                appointmentDate: appointmentDate,
                                patient: patient,
                                policy: prescriptionWritePolicy,
                                onPrescriptionRouteResult: context
                                    .read<PatientProfileFlowCubit>()
                                    .handlePrescriptionRouteResult,
                              ),
                              SizedBox(height: 16.h),
                            ],
                          );
                        },
                      ),
                    ContactInformationCard(patient: patient),
                    SizedBox(height: 16.h),
                    MedicalHistoryCard(patient: patient),
                    SizedBox(height: 16.h),
                    AllergiesCard(patient: patient),
                    SizedBox(height: 16.h),
                    PreviousVisitsCard(patient: patient),
                    SizedBox(height: 16.h),
                    const DocumentsCard(),
                    SizedBox(height: 24.h),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
