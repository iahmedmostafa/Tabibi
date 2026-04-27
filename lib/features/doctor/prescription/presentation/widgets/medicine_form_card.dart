import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';
import 'package:tabibi/features/doctor/prescription/presentation/widgets/prescription_text_field.dart';

class MedicineFormControllers {
  final TextEditingController medicineName = TextEditingController();
  final TextEditingController dosage = TextEditingController();
  final TextEditingController frequency = TextEditingController();
  final TextEditingController duration = TextEditingController();
  final TextEditingController instructions = TextEditingController();

  void dispose() {
    medicineName.dispose();
    dosage.dispose();
    frequency.dispose();
    duration.dispose();
    instructions.dispose();
  }
}

class MedicineFormCard extends StatelessWidget {
  final MedicineFormControllers controllers;
  final int index;
  final bool canRemove;
  final VoidCallback onRemove;

  const MedicineFormCard({
    super.key,
    required this.controllers,
    required this.index,
    required this.canRemove,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(18.w),
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
                width: 38.w,
                height: 38.w,
                decoration: BoxDecoration(
                  color: AppColors.teal.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Center(
                  child: Text(
                    '$index',
                    style: TextStyle(
                      color: AppColors.teal,
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
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: AppColors.grey900,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      'Dose, schedule, duration, and patient instructions',
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: AppColors.grey500),
                    ),
                  ],
                ),
              ),
              if (canRemove)
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.lightPink,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: IconButton(
                    onPressed: onRemove,
                    icon: const Icon(Iconsax.trash, color: AppColors.error),
                    tooltip: 'Remove medicine',
                  ),
                ),
            ],
          ),
          SizedBox(height: 18.h),
          PrescriptionTextField(
            controller: controllers.medicineName,
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
                  controller: controllers.dosage,
                  label: 'Dosage',
                  hintText: '500 mg',
                  icon: Iconsax.health,
                  validator: _requiredValidator,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: PrescriptionTextField(
                  controller: controllers.frequency,
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
            controller: controllers.duration,
            label: 'Duration',
            hintText: '7 days',
            icon: Iconsax.calendar,
            validator: _requiredValidator,
          ),
          SizedBox(height: 14.h),
          PrescriptionTextField(
            controller: controllers.instructions,
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
