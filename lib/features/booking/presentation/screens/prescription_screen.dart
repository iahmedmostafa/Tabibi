import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tabibi/core/routing/app_routes.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';
import 'package:tabibi/core/utils/constants/app_strings.dart';
import 'package:tabibi/core/utils/enums/enums.dart';
import 'package:tabibi/features/booking/data/models/prescription_model.dart';
import 'package:tabibi/features/booking/presentation/controller/prescription_cubit.dart';
import 'package:tabibi/features/booking/presentation/widgets/empty_prescription_view.dart';
import 'package:tabibi/features/booking/presentation/widgets/medicine_card.dart';
import 'package:tabibi/features/booking/presentation/widgets/prescription_date_card.dart';
import 'package:tabibi/features/booking/presentation/widgets/prescription_section_card.dart';

class PrescriptionScreen extends StatelessWidget {
  const PrescriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final scaffoldBackground = isDark ? AppColors.darkBackground : AppColors.grey50;
    final appBarBackground = isDark ? AppColors.darkBackground : Colors.white;
    final titleColor = isDark ? AppColors.white : AppColors.grey900;
    final iconColor = isDark ? AppColors.white : AppColors.black;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _goBack(context);
      },
      child: Scaffold(
        backgroundColor: scaffoldBackground,
        appBar: AppBar(
          title: Text(
            AppStrings.prescription,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: titleColor,
              fontWeight: FontWeight.w800,
            ),
          ),
          centerTitle: true,
          backgroundColor: appBarBackground,
          surfaceTintColor: appBarBackground,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, size: 24.sp, color: iconColor),
            onPressed: () => _goBack(context),
          ),
        ),
        body: BlocBuilder<PrescriptionCubit, PrescriptionState>(
          builder: (context, state) {
            if (state.status == PrescriptionStatus.loading) {
              return Center(
                child: CircularProgressIndicator(
                  color: AppColors.primary,
                  backgroundColor: isDark ? AppColors.grey800 : AppColors.grey200,
                ),
              );
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
      ),
    );
  }

  void _goBack(BuildContext context) {
    if (context.canPop()) {
      context.pop();
      return;
    }

    context.goNamed(AppRoutes.myBookings, extra: BookingStatus.completed);
  }

  Widget _buildPrescriptionContent(
    BuildContext context,
    PrescriptionModel prescription,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bodyColor = isDark ? AppColors.grey300 : AppColors.grey700;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 28.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PrescriptionDateCard(createdAt: prescription.createdAt),
          SizedBox(height: 18.h),
          PrescriptionSectionCard(
            icon: Iconsax.health,
            title: AppStrings.diagnosis,
            subtitle: 'Clinical summary from your completed visit',
            child: Text(
              prescription.diagnosis,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: bodyColor,
                fontSize: 15.sp,
                height: 1.5,
              ),
            ),
          ),
          SizedBox(height: 14.h),
          if (prescription.notes != null && prescription.notes!.isNotEmpty) ...[
            PrescriptionSectionCard(
              icon: Iconsax.note_1,
              title: AppStrings.notes,
              subtitle: 'Additional guidance from your doctor',
              child: Text(
                prescription.notes!,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: bodyColor,
                  fontSize: 15.sp,
                  height: 1.5,
                ),
              ),
            ),
            SizedBox(height: 14.h),
          ],
          _MedicinesHeader(count: prescription.medicines.length),
          SizedBox(height: 12.h),
          ...prescription.medicines.asMap().entries.map(
            (entry) => Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: MedicineCard(medicine: entry.value, index: entry.key + 1),
            ),
          ),
        ],
      ),
    );
  }
}

class _MedicinesHeader extends StatelessWidget {
  final int count;

  const _MedicinesHeader({required this.count});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surfaceColor = isDark ? AppColors.grey900 : Colors.white;
    final borderColor = isDark ? AppColors.grey800 : AppColors.grey200;
    final titleColor = isDark ? AppColors.white : AppColors.grey900;
    final subtitleColor = isDark ? AppColors.grey400 : AppColors.grey500;
    final iconBackground = isDark
        ? AppColors.grey800
        : AppColors.teal.withValues(alpha: 0.12);
    final iconColor = isDark ? AppColors.teal20 : AppColors.teal;
    final chipBackground = isDark
        ? AppColors.grey800
        : AppColors.midnightBlue.withValues(alpha: 0.08);
    final chipTextColor = isDark ? AppColors.grey100 : AppColors.midnightBlue;

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.26 : 0.045),
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
              color: iconBackground,
              borderRadius: BorderRadius.circular(13.r),
            ),
            child: Icon(Iconsax.hospital, color: iconColor, size: 22.sp),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.medicines,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: titleColor,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  'Follow the dosage and timing exactly as prescribed',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: subtitleColor,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 12.w),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: chipBackground,
              borderRadius: BorderRadius.circular(999.r),
            ),
            child: Text(
              '$count ${count == 1 ? 'item' : AppStrings.items}',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: chipTextColor,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
