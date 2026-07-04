import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tabibi/features/doctor/prescription/presentation/cubit/create_prescription_cubit.dart';
import 'package:tabibi/features/doctor/prescription/presentation/cubit/create_prescription_state.dart';
import 'package:tabibi/features/doctor/prescription/presentation/pages/create_prescription_args.dart';
import 'package:tabibi/features/doctor/prescription/presentation/widgets/medicine_form_card.dart';
import 'package:tabibi/features/doctor/prescription/presentation/widgets/medicines_header.dart';
import 'package:tabibi/features/doctor/prescription/presentation/widgets/prescription_form_section_card.dart';
import 'package:tabibi/features/doctor/prescription/presentation/widgets/prescription_patient_summary_card.dart';
import 'package:tabibi/features/doctor/prescription/presentation/widgets/prescription_text_field.dart';
import 'package:easy_localization/easy_localization.dart';

class CreatePrescriptionForm extends StatelessWidget {
  final CreatePrescriptionArgs args;

  const CreatePrescriptionForm({super.key, required this.args});

  @override
  Widget build(BuildContext context) {
    return Form(
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 28.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PrescriptionPatientSummaryCard(
              patientName: args.patient.name,
              patientId: args.patient.patientId,
              gender: args.patient.gender,
              age: args.patient.age,
              appointmentId: args.appointmentId,
            ),
            SizedBox(height: 20.h),
            const _ClinicalNotesSection(),
            SizedBox(height: 22.h),
            const _MedicinesSection(),
          ],
        ),
      ),
    );
  }
}

class _ClinicalNotesSection extends StatelessWidget {
  const _ClinicalNotesSection();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CreatePrescriptionCubit>();

    return PrescriptionFormSectionCard(
      title: 'clinicalNotes'.tr(),
      subtitle: 'captureDiagnosis'.tr(),
      icon: Iconsax.health,
      child: Column(
        children: [
          PrescriptionTextField(
            initialValue: '',
            onChanged: cubit.diagnosisChanged,
            label: 'diagnosis'.tr(),
            hintText: 'enterPrimaryDiagnosis'.tr(),
            icon: Iconsax.clipboard_text,
            maxLines: 3,
          ),
          SizedBox(height: 14.h),
          PrescriptionTextField(
            initialValue: '',
            onChanged: cubit.notesChanged,
            label: 'additionalNotes'.tr(),
            hintText: 'followUpNotes'.tr(),
            icon: Iconsax.note_text,
            maxLines: 3,
          ),
        ],
      ),
    );
  }
}

class _MedicinesSection extends StatelessWidget {
  const _MedicinesSection();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreatePrescriptionCubit, CreatePrescriptionState>(
      buildWhen: (previous, current) => previous.medicines != current.medicines,
      builder: (context, state) {
        final cubit = context.read<CreatePrescriptionCubit>();

        return Column(
          children: [
            MedicinesHeader(
              count: state.medicines.length,
              onAddMedicine: cubit.addMedicine,
            ),
            SizedBox(height: 14.h),
            ...state.medicines.asMap().entries.map(
              (entry) => Padding(
                padding: EdgeInsets.only(bottom: 16.h),
                child: MedicineFormCard(
                  key: ValueKey(entry.value.id),
                  medicine: entry.value,
                  index: entry.key + 1,
                  canRemove: state.canRemoveMedicine,
                  onMedicineNameChanged: (value) =>
                      cubit.medicineChanged(entry.key, medicineName: value),
                  onDosageChanged: (value) =>
                      cubit.medicineChanged(entry.key, dosage: value),
                  onFrequencyChanged: (value) =>
                      cubit.medicineChanged(entry.key, frequency: value),
                  onDurationChanged: (value) =>
                      cubit.medicineChanged(entry.key, duration: value),
                  onInstructionsChanged: (value) =>
                      cubit.medicineChanged(entry.key, instructions: value),
                  onRemove: () => cubit.removeMedicine(entry.key),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
