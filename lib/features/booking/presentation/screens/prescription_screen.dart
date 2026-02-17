import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';
import 'package:tabibi/core/utils/constants/app_strings.dart';
import 'package:tabibi/features/booking/presentation/controller/prescription_cubit.dart';
import 'package:tabibi/features/booking/data/models/prescription_model.dart';
import 'package:tabibi/features/booking/presentation/widgets/empty_prescription_view.dart';
import 'package:tabibi/features/booking/presentation/widgets/medicine_card.dart';
import 'package:tabibi/features/booking/presentation/widgets/prescription_date_card.dart';
import 'package:tabibi/features/booking/presentation/widgets/prescription_section_card.dart';

class PrescriptionScreen extends StatelessWidget {
  const PrescriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          AppStrings.prescription,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.midnightBlue,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.midnightBlue),
          onPressed: () => context.pop(),
        ),
      ),
      body: BlocBuilder<PrescriptionCubit, PrescriptionState>(
        builder: (context, state) {
          if (state.status == PrescriptionStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == PrescriptionStatus.failure) {
            return const EmptyPrescriptionView();
          }

          if (state.status == PrescriptionStatus.success &&
              state.prescription != null) {
            return _buildPrescriptionContent(context, state.prescription!);
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildPrescriptionContent(
    BuildContext context,
    PrescriptionModel prescription,
  ) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Date Card
          PrescriptionDateCard(createdAt: prescription.createdAt),
          SizedBox(height: 20.h),

          // Diagnosis Section
          PrescriptionSectionCard(
            icon: Iconsax.health,
            title: AppStrings.diagnosis,
            child: Text(
              prescription.diagnosis,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.grey700,
                fontSize: 15.sp,
                height: 1.5,
              ),
            ),
          ),
          SizedBox(height: 16.h),

          // Notes Section
          if (prescription.notes != null && prescription.notes!.isNotEmpty) ...[
            PrescriptionSectionCard(
              icon: Iconsax.note_1,
              title: AppStrings.notes,
              child: Text(
                prescription.notes!,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.grey700,
                  fontSize: 15.sp,
                  height: 1.5,
                ),
              ),
            ),
            SizedBox(height: 16.h),
          ],

          // Medicines Section Header
          Row(
            children: [
              Icon(
                Iconsax.hospital,
                size: 22.sp,
                color: AppColors.midnightBlue,
              ),
              SizedBox(width: 8.w),
              Text(
                AppStrings.medicines,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.midnightBlue,
                  fontSize: 18.sp,
                ),
              ),
              const Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: AppColors.midnightBlue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  '${prescription.medicines.length} ${AppStrings.items}',
                  style: TextStyle(
                    color: AppColors.midnightBlue,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),

          // Medicine Cards
          ...prescription.medicines.asMap().entries.map(
            (entry) => Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: MedicineCard(medicine: entry.value, index: entry.key + 1),
            ),
          ),

          SizedBox(height: 24.h),
        ],
      ),
    );
  }
}
