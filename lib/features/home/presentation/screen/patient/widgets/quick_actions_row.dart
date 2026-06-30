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
      _FeatureCardData(
        title: 'Appointment Booking',
        iconPath: AppImages.quickActionDoctor,
        gradientColors: const [Color(0xFFE9DCFF), Color(0xFFD9CCFF)],
        accent: const Color(0xFF8D6BE8),
        onTap: () => context.pushNamed(AppRoutes.allDoctors),
      ),
      _FeatureCardData(
        title: 'AI Medical Assistant',
        iconPath: AppImages.quickActionSupport,
        gradientColors: const [Color(0xFFD7FFF8), Color(0xFFA9EEE4)],
        accent: const Color(0xFF27C7B8),
        badge: 'AI',
        onTap: () => context.pushNamed(AppRoutes.aiSymptomCheck),
      ),
      _FeatureCardData(
        title: 'Medical Records',
        iconPath: AppImages.quickActionHistory,
        gradientColors: const [Color(0xFFE3ECFF), Color(0xFFC9D8FF)],
        accent: const Color(0xFF6288FF),
        onTap: () => context.pushNamed(
          AppRoutes.myBookings,
          extra: BookingStatus.upcoming,
        ),
      ),
      _FeatureCardData(
        title: 'Prescription Manager',
        iconPath: AppImages.quickActionReport,
        gradientColors: const [Color(0xFFFFE3EA), Color(0xFFFFC5D2)],
        accent: const Color(0xFFFF7D9A),
        onTap: () => MedicalProfileBottomSheet.showForEdit(context),
      ),
    ];

    return SizedBox(
      height: 150.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.only(right: 8.w),
        itemCount: actions.length,
        separatorBuilder: (_, _) => SizedBox(width: 14.w),
        itemBuilder: (context, index) {
          return _FeatureGradientCard(data: actions[index]);
        },
      ),
    );
  }
}

class _FeatureGradientCard extends StatelessWidget {
  const _FeatureGradientCard({required this.data});

  final _FeatureCardData data;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: data.onTap,
      borderRadius: BorderRadius.circular(28.r),
      child: Container(
        width: 122.w,
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28.r),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: data.gradientColors,
          ),
          border: Border.all(color: AppColors.black.withValues(alpha: 0.05)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              right: -20,
              top: -18,
              child: Container(
                width: 74.r,
                height: 74.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.white.withOpacity(0.18),
                ),
              ),
            ),
            Positioned(
              right: 24.w,
              top: 26.h,
              child: Container(
                width: 44.r,
                height: 44.r,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.r),
                  color: AppColors.white.withOpacity(0.10),
                ),
              ),
            ),
            Positioned(
              left: -28,
              bottom: -34,
              child: Container(
                width: 104.r,
                height: 104.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.white.withOpacity(0.14),
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 48.r,
                      height: 48.r,
                      padding: EdgeInsets.all(11.r),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.white.withOpacity(0.32),
                        border: Border.all(
                          color: AppColors.white.withOpacity(0.28),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: data.accent.withOpacity(0.18),
                            blurRadius: 18,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Image.asset(data.iconPath, fit: BoxFit.contain),
                    ),
                    const Spacer(),
                    if (data.badge != null)
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 9.w,
                          vertical: 5.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.actionGreen,
                          borderRadius: BorderRadius.circular(999.r),
                        ),
                        child: Text(
                          data.badge!,
                          style: TextStyle(
                            color: AppColors.white,
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: AppColors.black,
                        fontWeight: FontWeight.w800,
                        height: 1.12,
                      ),
                    ),
                    SizedBox(height: 8.h),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _FeatureCardData {
  const _FeatureCardData({
    required this.title,
    required this.iconPath,
    required this.gradientColors,
    required this.accent,
    required this.onTap,
    this.badge,
  });

  final String title;
  final String iconPath;
  final List<Color> gradientColors;
  final Color accent;
  final VoidCallback onTap;
  final String? badge;
}
