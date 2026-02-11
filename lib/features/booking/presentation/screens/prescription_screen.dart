import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';
import 'package:tabibi/core/utils/constants/app_strings.dart';
import 'package:tabibi/core/utils/formatters.dart/formatters.dart';
import 'package:tabibi/features/booking/data/models/prescription_model.dart';
import 'package:tabibi/features/booking/presentation/controller/prescription_cubit.dart';

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
            return Center(
              child: Padding(
                padding: EdgeInsets.all(24.r),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Iconsax.document,
                      size: 64.sp,
                      color: AppColors.grey300,
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      AppStrings.noPrescriptionFound,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.grey500,
                        fontSize: 16.sp,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
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
          _buildDateCard(context, prescription.createdAt),
          SizedBox(height: 20.h),

          // Diagnosis Section
          _buildSectionCard(
            context,
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
            _buildSectionCard(
              context,
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
              child: _buildMedicineCard(context, entry.value, entry.key + 1),
            ),
          ),

          SizedBox(height: 24.h),
        ],
      ),
    );
  }

  Widget _buildDateCard(BuildContext context, String createdAt) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.midnightBlue,
            AppColors.midnightBlue.withValues(alpha: 0.85),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.midnightBlue.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.r),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(Iconsax.calendar_1, color: Colors.white, size: 24.sp),
          ),
          SizedBox(width: 14.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppStrings.prescriptionDate,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.7),
                  fontSize: 12.sp,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                Formatter.formatIsoToDateTime(createdAt),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.grey200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20.sp, color: AppColors.midnightBlue),
              SizedBox(width: 8.w),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.midnightBlue,
                  fontSize: 16.sp,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Container(height: 1, color: AppColors.grey100),
          SizedBox(height: 12.h),
          child,
        ],
      ),
    );
  }

  Widget _buildMedicineCard(
    BuildContext context,
    MedicineModel medicine,
    int index,
  ) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.grey200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Medicine Name Header
          Row(
            children: [
              Container(
                width: 32.w,
                height: 32.w,
                decoration: BoxDecoration(
                  color: AppColors.midnightBlue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Center(
                  child: Text(
                    '$index',
                    style: TextStyle(
                      color: AppColors.midnightBlue,
                      fontWeight: FontWeight.bold,
                      fontSize: 14.sp,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  medicine.medicineName,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.midnightBlue,
                    fontSize: 16.sp,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Container(height: 1, color: AppColors.grey100),
          SizedBox(height: 12.h),

          // Medicine Details Grid
          _buildDetailRow(
            context,
            icon: Iconsax.weight,
            label: AppStrings.dosage,
            value: medicine.dosage,
          ),
          SizedBox(height: 10.h),
          _buildDetailRow(
            context,
            icon: Iconsax.repeat,
            label: AppStrings.frequency,
            value: medicine.frequency,
          ),
          SizedBox(height: 10.h),
          _buildDetailRow(
            context,
            icon: Iconsax.timer_1,
            label: AppStrings.duration,
            value: medicine.duration,
          ),
          if (medicine.instructions.isNotEmpty) ...[
            SizedBox(height: 10.h),
            _buildDetailRow(
              context,
              icon: Iconsax.info_circle,
              label: AppStrings.instructions,
              value: medicine.instructions,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16.sp, color: AppColors.grey400),
        SizedBox(width: 8.w),
        SizedBox(
          width: 85.w,
          child: Text(
            label,
            style: TextStyle(
              color: AppColors.grey500,
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              color: AppColors.grey700,
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
