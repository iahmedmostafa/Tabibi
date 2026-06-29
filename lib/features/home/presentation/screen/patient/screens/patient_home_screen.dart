import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:tabibi/core/routing/app_routes.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';
import 'package:tabibi/features/home/presentation/screen/patient/widgets/categories_section.dart';
import 'package:tabibi/features/home/presentation/screen/patient/widgets/customCarouselSlider.dart';
import 'package:tabibi/features/home/presentation/screen/patient/widgets/home_header.dart';
import 'package:tabibi/features/home/presentation/screen/patient/widgets/home_search_bar.dart';
import 'package:tabibi/features/home/presentation/screen/patient/widgets/quick_actions_row.dart';
import 'package:tabibi/features/home/presentation/screen/patient/widgets/recommended_doctors_section.dart';
import 'package:tabibi/features/home/presentation/screen/patient/widgets/section_header.dart';
import 'package:tabibi/features/home/presentation/screen/patient/widgets/upcoming_appointment_section.dart';

class PatientHomeScreen extends StatelessWidget {
  const PatientHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: isDark
                      ? [
                          AppColors.darkBackground,
                          AppColors.darkBackground,
                        ]
                      : [
                          AppColors.paleBlue.withValues(alpha: .3),
                          AppColors.white,
                          AppColors.grey50,
                        ],
                ),
              ),
            ),
          ),
          Positioned(
            top: -60,
            right: -40,
            child: Container(
              width: 180.r,
              height: 180.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withOpacity(isDark ? 0.10 : 0.08),
              ),
            ),
          ),
          Positioned(
            top: 160,
            left: -70,
            child: Container(
              width: 180.r,
              height: 180.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.actionGreen.withOpacity(isDark ? 0.06 : 0.05),
              ),
            ),
          ),
          SafeArea(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 120.h),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      const HomeHeader(),
                      SizedBox(height: 18.h),
                      const HomeSearchBar(),
                      SizedBox(height: 18.h),
                      const CustomCarouselSlider(),
                      SizedBox(height: 6.h),
                      const QuickActionsRow(),
                      SizedBox(height: 24.h),
                      SectionHeader(
                        title: 'Categories',
                        onTap: () => context.pushNamed(AppRoutes.allDepartments),
                      ),
                      SizedBox(height: 14.h),
                      const CategoriesSection(),
                      SizedBox(height: 26.h),
                      SectionHeader(
                        title: 'Recommended Doctors',
                        onTap: () => context.pushNamed(AppRoutes.allDoctors),
                      ),
                      SizedBox(height: 14.h),
                      const RecommendedDoctorsSection(),
                      SizedBox(height: 26.h),
                      const SectionHeader(title: 'Upcoming Appointment'),
                      SizedBox(height: 14.h),
                      const UpcomingAppointmentSection(),
                    ]),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
