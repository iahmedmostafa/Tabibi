import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:tabibi/core/routing/app_routes.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';
import 'package:tabibi/core/widgets/primary_button.dart';
import 'package:tabibi/features/home/presentation/screen/patient/widgets/doctor_details_header.dart';
import 'package:tabibi/features/home/presentation/screen/patient/widgets/doctor_stats.dart';
import 'package:tabibi/features/home/data/models/doctor_model.dart';
import 'package:tabibi/core/utils/constants/app_strings.dart';

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
            _buildReviewItem(context),
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

  Widget _buildReviewItem(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.grey50,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundImage: const AssetImage(
                  'assets/images/review_user.png',
                ), // Placeholder
                radius: 20.r,
                backgroundColor: AppColors.grey200,
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Emily Anderson",
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 16),
                        const Icon(Icons.star, color: Colors.amber, size: 16),
                        const Icon(Icons.star, color: Colors.amber, size: 16),
                        const Icon(Icons.star, color: Colors.amber, size: 16),
                        const Icon(Icons.star, color: Colors.amber, size: 16),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            "Dr. Patel is a true professional who genuinely cares about his patients. I highly recommend Dr. Patel to anyone.",
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.grey600),
          ),
        ],
      ),
    );
  }
}
