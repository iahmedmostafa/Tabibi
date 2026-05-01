import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:tabibi/core/routing/app_routes.dart';
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
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 24.h),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  const HomeHeader(),
                  SizedBox(height: 18.h),
                  const HomeSearchBar(),
                  SizedBox(height: 18.h),
                  const CustomCarouselSlider(),
                  SizedBox(height: 4.h),
                  const QuickActionsRow(),
                  SizedBox(height: 22.h),
                  SectionHeader(
                    title: 'Categories',
                    onTap: () => context.pushNamed(AppRoutes.allDepartments),
                  ),
                  SizedBox(height: 14.h),
                  const CategoriesSection(),
                  SizedBox(height: 24.h),
                  SectionHeader(
                    title: 'Recommended Doctors',
                    onTap: () => context.pushNamed(AppRoutes.allDoctors),
                  ),
                  SizedBox(height: 14.h),
                  const RecommendedDoctorsSection(),
                  SizedBox(height: 24.h),
                  const SectionHeader(title: 'Upcoming Appointment'),
                  SizedBox(height: 14.h),
                  const UpcomingAppointmentSection(),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
