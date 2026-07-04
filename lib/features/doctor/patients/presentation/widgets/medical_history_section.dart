import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';
import 'package:tabibi/features/doctor/patients/presentation/cubit/medical_history_cubit.dart';
import 'package:tabibi/features/doctor/patients/presentation/cubit/medical_history_state.dart';
import 'package:tabibi/features/patient_profile/data/models/medical_profile_model.dart';
import 'package:easy_localization/easy_localization.dart';

class MedicalHistorySection extends StatelessWidget {
  const MedicalHistorySection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MedicalHistoryCubit, MedicalHistoryState>(
      builder: (context, state) {
        switch (state.status) {
          case MedicalHistoryStatus.initial:
          case MedicalHistoryStatus.loading:
            return _buildLoadingCard(context);
          case MedicalHistoryStatus.error:
            return _buildErrorCard(context, state.errorMessage);
          case MedicalHistoryStatus.success:
            final profile = state.profile;
            if (profile == null ||
                (!profile.isCompleted &&
                    profile.chronicDiseases.isEmpty &&
                    profile.surgeries.isEmpty &&
                    profile.medications == null &&
                    profile.allergies == null)) {
              return _buildEmptyCard(context);
            }
            return _buildContent(context, profile);
        }
      },
    );
  }

  Widget _buildCard({required BuildContext context, required Widget child}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isDark ? AppColors.grey800 : AppColors.grey200,
        ),
      ),
      child: child,
    );
  }

  Widget _buildLoadingCard(BuildContext context) {
    return _buildCard(
      context: context,
      child: Column(
        children: [
          SizedBox(height: 10.h),
          const CircularProgressIndicator(),
          SizedBox(height: 10.h),
        ],
      ),
    );
  }

  Widget _buildErrorCard(BuildContext context, String? message) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return _buildCard(
      context: context,
      child: Column(
        children: [
          Icon(
            Icons.error_outline,
            size: 32.sp,
            color: isDark ? AppColors.grey400 : AppColors.grey600,
          ),
          SizedBox(height: 8.h),
          Text(
            message ?? 'failedToLoadMedicalHistory'.tr(),
            style: TextStyle(
              fontSize: 14.sp,
              color: isDark ? AppColors.grey400 : AppColors.grey600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyCard(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return _buildCard(
      context: context,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTitle(context, 'medicalHistory'.tr()),
          SizedBox(height: 16.h),
          Icon(
            Icons.assignment_outlined,
            size: 32.sp,
            color: isDark ? AppColors.grey500 : AppColors.grey400,
          ),
          SizedBox(height: 8.h),
          Text(
            'noMedicalHistory'.tr(),
            style: TextStyle(
              fontSize: 14.sp,
              color: isDark ? AppColors.grey400 : AppColors.grey600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context, MedicalProfileModel profile) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return _buildCard(
      context: context,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTitle(context, 'medicalHistory'.tr()),
          SizedBox(height: 16.h),
          if (profile.chronicDiseases.isNotEmpty) ...[
            _buildSectionLabel(context, 'chronicDiseasesList'.tr()),
            SizedBox(height: 8.h),
            _buildChipList(context, profile.chronicDiseases, isDark),
            SizedBox(height: 16.h),
          ],
          if (profile.medications != null &&
              profile.medications!.isNotEmpty) ...[
            _buildSectionLabel(context, 'medicationsList'.tr()),
            SizedBox(height: 8.h),
            _buildValueText(context, profile.medications!),
            SizedBox(height: 16.h),
          ],
          if (profile.allergies != null && profile.allergies!.isNotEmpty) ...[
            _buildSectionLabel(context, 'allergiesCard'.tr()),
            SizedBox(height: 8.h),
            _buildChipList(
              context,
              profile.allergies!
                  .split(',')
                  .map((s) => s.trim())
                  .where((s) => s.isNotEmpty)
                  .toList(),
              isDark,
            ),
            SizedBox(height: 16.h),
          ],
          if (profile.surgeries.isNotEmpty) ...[
            _buildSectionLabel(context, 'surgeriesList'.tr()),
            SizedBox(height: 8.h),
            _buildChipList(context, profile.surgeries, isDark),
            SizedBox(height: 16.h),
          ],
          _buildInfoRow(context, profile),
          SizedBox(height: 12.h),
          _buildUpdatedDate(context, profile.updatedAt),
        ],
      ),
    );
  }

  Widget _buildTitle(BuildContext context, String title) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Text(
      title,
      style: TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.w600,
        color: isDark ? Colors.white : AppColors.grey900,
      ),
    );
  }

  Widget _buildSectionLabel(BuildContext context, String label) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Text(
      label,
      style: TextStyle(
        fontSize: 13.sp,
        fontWeight: FontWeight.w500,
        color: isDark ? AppColors.grey400 : AppColors.grey600,
      ),
    );
  }

  Widget _buildValueText(BuildContext context, String value) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Text(
      value,
      style: TextStyle(
        fontSize: 14.sp,
        color: isDark ? Colors.white : AppColors.grey900,
      ),
    );
  }

  Widget _buildChipList(BuildContext context, List<String> items, bool isDark) {
    if (items.isEmpty) {
      return _buildNotSpecified(context);
    }
    return Wrap(
      spacing: 8.w,
      runSpacing: 8.h,
      children: items.map((item) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: isDark ? AppColors.grey800 : const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(
              color: isDark ? AppColors.grey700 : const Color(0xFFE2E8F0),
            ),
          ),
          child: Text(
            item,
            style: TextStyle(
              fontSize: 13.sp,
              color: isDark ? Colors.white : AppColors.grey900,
              fontWeight: FontWeight.w500,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildNotSpecified(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Text(
      'notSpecified'.tr(),
      style: TextStyle(
        fontSize: 14.sp,
        fontStyle: FontStyle.italic,
        color: isDark ? AppColors.grey500 : AppColors.grey400,
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, MedicalProfileModel profile) {
    return Row(
      children: [
        Expanded(
          child: _buildInfoItem(
            context,
            icon: Icons.monitor_weight_outlined,
            label: 'weightStat'.tr(),
            value: profile.weight != null && profile.weight!.isNotEmpty
                ? '${profile.weight} ${"weightStat".tr()}'
                : null,
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: _buildInfoItem(
            context,
            icon: Icons.height_outlined,
            label: 'heightCm'.tr(),
            value: profile.height != null && profile.height!.isNotEmpty
                ? '${profile.height} ${"heightCm".tr()}'
                : null,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String? value,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.grey800 : AppColors.grey50,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isDark ? AppColors.grey700 : AppColors.grey200,
        ),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20.sp, color: AppColors.midnightBlue),
          SizedBox(width: 10.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 11.sp,
                  color: isDark ? AppColors.grey400 : AppColors.grey500,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                value ?? 'notSpecified'.tr(),
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: value != null
                      ? (isDark ? Colors.white : AppColors.grey900)
                      : (isDark ? AppColors.grey500 : AppColors.grey400),
                  fontStyle: value != null
                      ? FontStyle.normal
                      : FontStyle.italic,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUpdatedDate(BuildContext context, String updatedAt) {
    if (updatedAt.isEmpty) return const SizedBox.shrink();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final displayDate = _formatDate(updatedAt);
    return Row(
      children: [
        Icon(
          Icons.update,
          size: 14.sp,
          color: isDark ? AppColors.grey500 : AppColors.grey400,
        ),
        SizedBox(width: 6.w),
        Text(
          '${'lastUpdated'.tr()} $displayDate',
          style: TextStyle(
            fontSize: 12.sp,
            color: isDark ? AppColors.grey500 : AppColors.grey400,
          ),
        ),
      ],
    );
  }

  String _formatDate(String dateStr) {
    try {
      final dt = DateTime.parse(dateStr);
      final months = [
        'Jan'.tr(),
        'Feb'.tr(),
        'Mar'.tr(),
        'Apr'.tr(),
        'May'.tr(),
        'Jun'.tr(),
        'Jul'.tr(),
        'Aug'.tr(),
        'Sep'.tr(),
        'Oct'.tr(),
        'Nov'.tr(),
        'Dec'.tr(),
      ];
      return '${dt.day} ${months[dt.month - 1]} ${dt.year}';
    } catch (_) {
      return dateStr;
    }
  }
}
