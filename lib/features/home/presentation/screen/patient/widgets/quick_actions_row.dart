import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:tabibi/core/routing/app_routes.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';
import 'package:tabibi/core/utils/constants/app_images.dart';
import 'package:tabibi/core/utils/enums/enums.dart';
import 'package:tabibi/features/patient_profile/presentation/widgets/medical_profile_bottom_sheet.dart';

class QuickActionsRow extends StatelessWidget {
  const QuickActionsRow({super.key});

  @override
  Widget build(BuildContext context) {
    final actions = [
      _QuickActionData(
        title: 'Book\nAppointment',
        imagePath: AppImages.quickActionDoctor,
        color: AppColors.actionPinkLight,
        onTap: () => context.pushNamed(AppRoutes.allDoctors),
      ),
      _QuickActionData(
        title: 'Symptom\nChecker',
        imagePath: AppImages.quickActionSupport,
        color: AppColors.actionGreenLight,
        badge: 'AI',
        onTap: () => context.pushNamed(AppRoutes.aiSymptomCheck),
      ),
      _QuickActionData(
        title: 'My\nAppointments',
        imagePath: AppImages.quickActionHistory,
        color: AppColors.actionOrangeLight,
        onTap: () => context.pushNamed(
          AppRoutes.myBookings,
          extra: BookingStatus.upcoming,
        ),
      ),
      _QuickActionData(
        title: 'Medical\nHistory',
        imagePath: AppImages.quickActionReport,
        color: AppColors.paleBlueLight,
        onTap: () => MedicalProfileBottomSheet.showForEdit(context),
      ),
    ];

    return Row(
      children: actions
          .map(
            (action) => Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: _QuickActionCard(data: action),
              ),
            ),
          )
          .toList(),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  const _QuickActionCard({required this.data});

  final _QuickActionData data;

  @override
  Widget build(BuildContext context) {
    final surfaceColor = Theme.of(context).cardColor;

    return InkWell(
      onTap: data.onTap,
      borderRadius: BorderRadius.circular(22.r),
      child: Ink(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: BorderRadius.circular(22.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.midnightBlue.withValues(alpha: 0.05),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Column(
              children: [
                Container(
                  width: 58.w,
                  height: 58.w,
                  decoration: BoxDecoration(
                    color: data.color,
                    borderRadius: BorderRadius.circular(18.r),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(10.r),
                    child: Image.asset(
                      data.imagePath,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                SizedBox(height: 12.h),
                Text(
                  data.title,
                  textAlign: TextAlign.center,
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(height: 1.35),
                ),
              ],
            ),
            if (data.badge != null)
              Positioned(
                top: -8.h,
                right: 6.w,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                  decoration: BoxDecoration(
                    color: AppColors.actionGreen,
                    borderRadius: BorderRadius.circular(999.r),
                  ),
                  child: Text(
                    data.badge!,
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _QuickActionData {
  const _QuickActionData({
    required this.title,
    required this.imagePath,
    required this.color,
    required this.onTap,
    this.badge,
  });

  final String title;
  final String imagePath;
  final Color color;
  final VoidCallback onTap;
  final String? badge;
}
