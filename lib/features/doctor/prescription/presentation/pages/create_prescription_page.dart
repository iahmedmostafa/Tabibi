import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';
import 'package:tabibi/features/doctor/prescription/domain/entities/prescription_medicine.dart';
import 'package:tabibi/features/doctor/prescription/presentation/cubit/create_prescription_cubit.dart';
import 'package:tabibi/features/doctor/prescription/presentation/cubit/create_prescription_state.dart';
import 'package:tabibi/features/doctor/prescription/presentation/pages/create_prescription_args.dart';
import 'package:tabibi/features/doctor/prescription/presentation/widgets/medicine_form_card.dart';
import 'package:tabibi/features/doctor/prescription/presentation/widgets/prescription_text_field.dart';

class CreatePrescriptionPage extends StatefulWidget {
  final CreatePrescriptionArgs args;

  const CreatePrescriptionPage({super.key, required this.args});

  @override
  State<CreatePrescriptionPage> createState() => _CreatePrescriptionPageState();
}

class _CreatePrescriptionPageState extends State<CreatePrescriptionPage> {
  final _formKey = GlobalKey<FormState>();
  final _diagnosisController = TextEditingController();
  final _notesController = TextEditingController();
  final List<MedicineFormControllers> _medicines = [MedicineFormControllers()];

  @override
  void dispose() {
    _diagnosisController.dispose();
    _notesController.dispose();
    for (final medicine in _medicines) {
      medicine.dispose();
    }
    super.dispose();
  }

  void _addMedicine() {
    setState(() => _medicines.add(MedicineFormControllers()));
  }

  void _removeMedicine(int index) {
    if (_medicines.length == 1) return;
    final removed = _medicines.removeAt(index);
    removed.dispose();
    setState(() {});
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final medicines = _medicines
        .map(
          (medicine) => PrescriptionMedicine(
            medicineName: medicine.medicineName.text.trim(),
            dosage: medicine.dosage.text.trim(),
            frequency: medicine.frequency.text.trim(),
            duration: medicine.duration.text.trim(),
            instructions: medicine.instructions.text.trim(),
          ),
        )
        .toList();

    context.read<CreatePrescriptionCubit>().createPrescription(
      appointmentId: widget.args.appointmentId,
      diagnosis: _diagnosisController.text,
      notes: _notesController.text,
      medicines: medicines,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreatePrescriptionCubit, CreatePrescriptionState>(
      listener: (context, state) {
        if (state.status == CreatePrescriptionStatus.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Prescription saved and appointment completed.'),
              backgroundColor: AppColors.success,
            ),
          );
          context.pop(true);
        }

        if (state.status == CreatePrescriptionStatus.failure ||
            state.status == CreatePrescriptionStatus.completionFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.errorMessage ?? 'Failed to save prescription.',
              ),
              backgroundColor: AppColors.error,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.grey50,
        appBar: AppBar(
          title: Text(
            'Create Prescription',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: AppColors.grey900,
              fontWeight: FontWeight.w800,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, size: 24.sp, color: Colors.black),
            onPressed: () => context.pop(),
          ),
        ),
        bottomNavigationBar:
            BlocBuilder<CreatePrescriptionCubit, CreatePrescriptionState>(
              builder: (context, state) {
                final isLoading =
                    state.status == CreatePrescriptionStatus.loading;

                return Container(
                  padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 16.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.midnightBlue.withValues(alpha: 0.08),
                        blurRadius: 18,
                        offset: const Offset(0, -8),
                      ),
                    ],
                  ),
                  child: SafeArea(
                    top: false,
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: isLoading ? null : _submit,
                        icon: isLoading
                            ? SizedBox(
                                width: 18.w,
                                height: 18.w,
                                child: const CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Icon(Iconsax.tick_circle),
                        label: Text(
                          isLoading
                              ? 'Saving Prescription...'
                              : 'Save Prescription',
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.midnightBlue,
                          disabledBackgroundColor: AppColors.grey400,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 16.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14.r),
                          ),
                          textStyle: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 28.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _PatientSummaryCard(
                  patientName: widget.args.patient.name,
                  patientId: widget.args.patient.patientId,
                  gender: widget.args.patient.gender,
                  age: widget.args.patient.age,
                  appointmentId: widget.args.appointmentId,
                ),
                SizedBox(height: 20.h),
                _SectionCard(
                  title: 'Clinical Notes',
                  subtitle: 'Capture the diagnosis and guidance for the visit',
                  icon: Iconsax.health,
                  child: Column(
                    children: [
                      PrescriptionTextField(
                        controller: _diagnosisController,
                        label: 'Diagnosis',
                        hintText: 'Enter primary diagnosis',
                        icon: Iconsax.clipboard_text,
                        maxLines: 3,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Diagnosis is required';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 14.h),
                      PrescriptionTextField(
                        controller: _notesController,
                        label: 'Additional Notes',
                        hintText: 'Follow-up notes, lifestyle advice, warnings',
                        icon: Iconsax.note_text,
                        maxLines: 3,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 22.h),
                _MedicinesHeader(
                  count: _medicines.length,
                  onAddMedicine: _addMedicine,
                ),
                SizedBox(height: 14.h),
                ..._medicines.asMap().entries.map(
                  (entry) => Padding(
                    padding: EdgeInsets.only(bottom: 16.h),
                    child: MedicineFormCard(
                      controllers: entry.value,
                      index: entry.key + 1,
                      canRemove: _medicines.length > 1,
                      onRemove: () => _removeMedicine(entry.key),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PatientSummaryCard extends StatelessWidget {
  final String patientName;
  final String patientId;
  final String gender;
  final int age;
  final String appointmentId;

  const _PatientSummaryCard({
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
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: 5.h),
                    Text(
                      patientId,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.white70,
                        fontWeight: FontWeight.w600,
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
                label: age > 0 ? '$age years' : 'Age unavailable',
              ),
              _PatientChip(
                icon: Iconsax.receipt_item,
                label: 'Visit ${_shortAppointmentId(appointmentId)}',
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
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _MedicinesHeader extends StatelessWidget {
  final int count;
  final VoidCallback onAddMedicine;

  const _MedicinesHeader({required this.count, required this.onAddMedicine});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: AppColors.grey200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.045),
            blurRadius: 14,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 42.w,
            height: 42.w,
            decoration: BoxDecoration(
              color: AppColors.teal.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(13.r),
            ),
            child: Icon(Iconsax.hospital, color: AppColors.teal, size: 22.sp),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Medicines',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.grey900,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  '$count ${count == 1 ? 'item' : 'items'} added to this prescription',
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: AppColors.grey500),
                ),
              ],
            ),
          ),
          SizedBox(width: 12.w),
          ElevatedButton.icon(
            onPressed: onAddMedicine,
            icon: Icon(Icons.add, size: 18.sp),
            label: const Text('Add'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.teal,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Widget child;

  const _SectionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: AppColors.grey200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.045),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42.w,
                height: 42.w,
                decoration: BoxDecoration(
                  color: AppColors.teal.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(13.r),
                ),
                child: Icon(icon, color: AppColors.teal, size: 22.sp),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: AppColors.grey900,
                      ),
                    ),
                    SizedBox(height: 3.h),
                    Text(
                      subtitle,
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: AppColors.grey500),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          child,
        ],
      ),
    );
  }
}
