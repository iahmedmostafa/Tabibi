import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:tabibi/core/routing/app_routes.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';
import 'package:tabibi/core/utils/constants/app_strings.dart';
import 'package:tabibi/core/widgets/primary_button.dart';
import 'package:tabibi/features/doctor_details/presentation/widgets/doctor_details_header.dart';
import 'package:tabibi/features/doctor_details/presentation/widgets/doctor_stats.dart';
import 'package:tabibi/features/doctor_details/presentation/widgets/review_item.dart';
import 'package:tabibi/features/home/data/models/doctor_model.dart';

class DoctorDetailsScreen extends StatelessWidget {
  final DoctorModel doctor;

  const DoctorDetailsScreen({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.doctorDetails),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border),
            onPressed: () {
              // Toggle favorite
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DoctorDetailsHeader(doctor: doctor),
            SizedBox(height: 24.h),
            DoctorStats(
              patientCount: 2000, // Mock data as per UI
              yearsOfExperience: doctor.yearsOfExperience,
              rating: 5.0, // Mock
              reviewCount: 1872, // Mock
            ),
            SizedBox(height: 24.h),
            Text(
              AppStrings.aboutMe,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.h),
            Text(
              "Dr. ${doctor.name}, a dedicated ${doctor.departmentName}, brings a wealth of experience to Golden Gate Cardiology Center in Golden Gate, CA.",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.grey500,
                height: 1.5,
              ),
            ),
            SizedBox(height: 24.h),
            Text(
              AppStrings.workingTime,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.h),
            Text(
              AppStrings.workingHours,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppColors.grey500),
            ),
            SizedBox(height: 24.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppStrings.reviews,
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text(AppStrings.seeAll),
                ),
              ],
            ),
            const ReviewItem(),
            SizedBox(height: 32.h),
            PrimaryButton(
              title: AppStrings.bookAppointment,
              onPress: () {
                context.push(AppRoutes.bookAppointment, extra: doctor);
              },
            ),
          ],
        ),
      ),
    );
  }
}
