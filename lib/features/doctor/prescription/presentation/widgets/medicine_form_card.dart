import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';
import 'package:tabibi/core/utils/constants/app_styles.dart';
import 'package:tabibi/features/doctor/core/widgets/doctor_card.dart';
import 'package:tabibi/features/doctor/prescription/presentation/cubit/create_prescription_state.dart';
import 'package:tabibi/features/doctor/prescription/presentation/widgets/prescription_text_field.dart';
import 'package:easy_localization/easy_localization.dart';

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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return DoctorCard(
      padding: EdgeInsets.all(18.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 38.w,
                height: 38.w,
                decoration: BoxDecoration(
                  color: AppColors.teal.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Center(
                  child: Text(
                    '$index',
                    style: AppTextStyle.bodySBold.copyWith(
                      color: AppColors.teal,
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
                      'medicineFormTitle'.tr(namedArgs: {'index': '$index'}),
                      style: AppTextStyle.h3.copyWith(
                        color: isDark ? Colors.white : AppColors.grey900,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      'medicineDoseHint'.tr(),
                      style: AppTextStyle.bodyXsMedium.copyWith(
                        color: isDark ? AppColors.grey400 : AppColors.grey500,
                      ),
                    ),
                  ],
                ),
              ),
              if (canRemove)
                Container(
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.red.shade900.withValues(alpha: 0.2)
                        : AppColors.lightPink,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: IconButton(
                    onPressed: onRemove,
                    icon: Icon(
                      Iconsax.trash,
                      color: isDark ? Colors.red.shade300 : AppColors.error,
                    ),
                    tooltip: 'removeMedicine'.tr(),
                  ),
                ),
            ],
          ),
          SizedBox(height: 18.h),
          PrescriptionTextField(
            initialValue: medicine.medicineName,
            onChanged: onMedicineNameChanged,
            label: 'medicineName'.tr(),
            hintText: 'medicineNameHint'.tr(),
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
                  label: 'dosageLabel'.tr(),
                  hintText: 'dosageHint'.tr(),
                  icon: Iconsax.health,
                  validator: _requiredValidator,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: PrescriptionTextField(
                  initialValue: medicine.frequency,
                  onChanged: onFrequencyChanged,
                  label: 'frequencyLabel'.tr(),
                  hintText: 'frequencyHint'.tr(),
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
            label: 'durationLabel'.tr(),
            hintText: 'durationHint'.tr(),
            icon: Iconsax.calendar,
            validator: _requiredValidator,
          ),
          SizedBox(height: 14.h),
          PrescriptionTextField(
            initialValue: medicine.instructions,
            onChanged: onInstructionsChanged,
            label: 'instructionsLabel'.tr(),
            hintText: 'instructionsHint'.tr(),
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
      return 'requiredField'.tr();
    }
    return null;
  }
}
