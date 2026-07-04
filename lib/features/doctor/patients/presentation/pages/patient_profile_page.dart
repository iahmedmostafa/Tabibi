import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:tabibi/core/DI/service_locator.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';
import 'package:tabibi/features/doctor/patients/domain/entities/patient.dart';
import 'package:tabibi/features/doctor/patients/presentation/cubit/medical_history_cubit.dart';
import 'package:tabibi/features/doctor/patients/presentation/cubit/patient_profile_flow_cubit.dart';
import 'package:tabibi/features/doctor/patients/presentation/widgets/contact_information_card.dart';
import 'package:tabibi/features/doctor/patients/presentation/widgets/medical_history_section.dart';
import 'package:tabibi/features/doctor/patients/presentation/widgets/patient_header_card.dart';
import 'package:tabibi/features/doctor/patients/presentation/widgets/prescription_entry_card.dart';
import 'package:tabibi/features/doctor/prescription/presentation/policies/prescription_write_policy.dart';
import 'package:easy_localization/easy_localization.dart';

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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => PatientProfileFlowCubit()),
        BlocProvider(
          create: (_) =>
              sl<MedicalHistoryCubit>()..getMedicalProfile(patient.id),
        ),
      ],
      child: Builder(
        builder: (context) {
          return PopScope(
            canPop: false,
            onPopInvokedWithResult: (didPop, result) {
              if (didPop) return;
              _popProfile(context);
            },
            child: Scaffold(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              appBar: AppBar(
                title: Text(
                  'patientProfile'.tr(),
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                centerTitle: true,
                leading: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    size: 24.sp,
                    color: isDark ? Colors.white : AppColors.grey900,
                  ),
                  onPressed: () => _popProfile(context),
                ),
                actions: [
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'edit'.tr(),
                      style: TextStyle(
                        color: AppColors.midnightBlue,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
                surfaceTintColor: Colors.transparent,
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
                    const MedicalHistorySection(),
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
