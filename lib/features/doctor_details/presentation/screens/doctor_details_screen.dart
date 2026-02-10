import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:tabibi/core/DI/service_locator.dart';
import 'package:tabibi/core/routing/app_routes.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';
import 'package:tabibi/core/utils/constants/app_strings.dart';
import 'package:tabibi/core/utils/formatters.dart/formatters.dart';
import 'package:tabibi/core/widgets/primary_button.dart';
import 'package:tabibi/features/doctor_details/presentation/controller/doctor_details_cubit.dart';
import 'package:tabibi/features/doctor_details/presentation/controller/doctor_details_state.dart';
import 'package:tabibi/features/doctor_details/presentation/widgets/doctor_details_header.dart';
import 'package:tabibi/features/doctor_details/presentation/widgets/doctor_stats.dart';
import 'package:tabibi/features/doctor_details/presentation/widgets/review_item.dart';
import 'package:tabibi/features/home/data/models/doctor_model.dart';

class DoctorDetailsScreen extends StatelessWidget {
  final DoctorModel doctor;

  const DoctorDetailsScreen({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          sl<DoctorDetailsCubit>()..getDoctorDetails(doctor.id),
      child: Scaffold(
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
        body: BlocBuilder<DoctorDetailsCubit, DoctorDetailsState>(
          builder: (context, state) {
            if (state is DoctorDetailsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is DoctorDetailsFailure) {
              return Center(child: Text(state.message));
            } else if (state is DoctorDetailsSuccess) {
              final details = state.doctorDetails;
              return SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DoctorDetailsHeader(doctor: details),
                    SizedBox(height: 24.h),
                    DoctorStats(
                      patientCount: details.patientCount,
                      yearsOfExperience: details.yearsOfExperience,
                      rating: details.rating,
                      reviewCount: details.reviewCount,
                    ),
                    SizedBox(height: 24.h),
                    Text(
                      AppStrings.aboutMe,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      details.bio ??
                          "Dr. ${details.name}, a dedicated ${details.department}, brings a wealth of experience to our center.",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.grey500,
                        height: 1.5,
                      ),
                    ),
                    SizedBox(height: 24.h),
                    Text(
                      AppStrings.workingTime,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    ...details.schedule.map(
                      (s) => Text(
                        "${_getDayName(s.dayOfWeek)}: ${Formatter.formatTo12Hour(s.openTime)} - ${Formatter.formatTo12Hour(s.closeTime)}",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.grey500,
                        ),
                      ),
                    ),
                    SizedBox(height: 24.h),
                    Text(
                      AppStrings.consultationFee,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "${details.consultationFee} EGP",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.grey500,
                      ),
                    ),
                    SizedBox(height: 24.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppStrings.reviews,
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        TextButton(
                          onPressed: () {
                            context.push(
                              '${AppRoutes.doctorReviews}/${details.id}',
                            );
                          },
                          child: const Text(AppStrings.seeAll),
                        ),
                      ],
                    ),
                    if (details.reviews.isEmpty)
                      const Text("No reviews yet")
                    else
                      ...details.reviews.map(
                        (r) => Padding(
                          padding: EdgeInsets.only(bottom: 12.h),
                          child: ReviewItem(review: r),
                        ),
                      ),
                    SizedBox(height: 32.h),
                    PrimaryButton(
                      title: AppStrings.bookAppointment,
                      onPress: () {
                        context.push(AppRoutes.bookAppointment, extra: details);
                      },
                    ),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  String _getDayName(int day) {
    switch (day) {
      case 1:
        return "Monday";
      case 2:
        return "Tuesday";
      case 3:
        return "Wednesday";
      case 4:
        return "Thursday";
      case 5:
        return "Friday";
      case 6:
        return "Saturday";
      case 0:
        return "Sunday";
      default:
        return "";
    }
  }
}
