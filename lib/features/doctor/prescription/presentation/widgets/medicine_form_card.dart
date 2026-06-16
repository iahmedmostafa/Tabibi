import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tabibi/core/utils/theme/theme.dart';
import 'package:tabibi/features/doctor/prescription/presentation/cubit/create_prescription_state.dart';
import 'package:tabibi/features/doctor/prescription/presentation/widgets/prescription_text_field.dart';

class MedicineFormCard extends StatelessWidget {
  final PrescriptionMedicineFormInput medicine;
  final int index;
  final bool canRemove;
  final ValueChanged<String> onMedicineNameChanged;
  final ValueChanged<String> onDosageChanged;
  final ValueChanged<String> onFrequencyChanged;
  final ValueChanged<String> onDurationChanged;
  final ValueChanged<String> onInstructionsChanged;
  final VoidCallback onRemove;

  const MedicineFormCard({
    super.key,
    required this.medicine,
    required this.index,
    required this.canRemove,
    required this.onMedicineNameChanged,
    required this.onDosageChanged,
    required this.onFrequencyChanged,
    required this.onDurationChanged,
    required this.onInstructionsChanged,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: theme.cardColor != Colors.transparent ? theme.cardColor : theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: theme.dividerColor),
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
                width: 38.w,
                height: 38.w,
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Center(
                  child: Text(
                    '$index',
                    style: TextStyle(
                      color: AppTheme.primaryColor,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Medicine $index',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      'Dose, schedule, duration, and patient instructions',
                      style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
              if (canRemove)
                Container(
                  decoration: BoxDecoration(
                    color: AppTheme.redIcon.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: IconButton(
                    onPressed: onRemove,
                    icon: const Icon(Iconsax.trash, color: AppTheme.redIcon),
                    tooltip: 'Remove medicine',
                  ),
                ),
            ],
          ),
          SizedBox(height: 18.h),
          PrescriptionTextField(
            initialValue: medicine.medicineName,
            onChanged: onMedicineNameChanged,
            label: 'Medicine Name',
            hintText: 'e.g. Amoxicillin',
            icon: Iconsax.hospital,
            validator: _requiredValidator,
          ),
          SizedBox(height: 14.h),
          Row(
            children: [
              Expanded(
                child: PrescriptionTextField(
                  initialValue: medicine.dosage,
                  onChanged: onDosageChanged,
                  label: 'Dosage',
                  hintText: '500 mg',
                  icon: Iconsax.health,
                  validator: _requiredValidator,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: PrescriptionTextField(
                  initialValue: medicine.frequency,
                  onChanged: onFrequencyChanged,
                  label: 'Frequency',
                  hintText: 'Twice daily',
                  icon: Iconsax.clock,
                  validator: _requiredValidator,
                ),
              ),
            ],
          ),
          SizedBox(height: 14.h),
          PrescriptionTextField(
            initialValue: medicine.duration,
            onChanged: onDurationChanged,
            label: 'Duration',
            hintText: '7 days',
            icon: Iconsax.calendar,
            validator: _requiredValidator,
          ),
          SizedBox(height: 14.h),
          PrescriptionTextField(
            initialValue: medicine.instructions,
            onChanged: onInstructionsChanged,
            label: 'Instructions',
            hintText: 'After meals, avoid dairy products',
            icon: Iconsax.note_1,
            maxLines: 2,
            validator: _requiredValidator,
          ),
        ],
      ),
    );
  }

  String? _requiredValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Required';
    }
    return null;
  }
}
