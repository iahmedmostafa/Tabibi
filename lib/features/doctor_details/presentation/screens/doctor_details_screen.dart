import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tabibi/core/DI/service_locator.dart';
import 'package:tabibi/core/routing/app_routes.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';
import 'package:tabibi/core/utils/constants/app_strings.dart';
import 'package:tabibi/core/utils/formatters.dart/formatters.dart';
import 'package:tabibi/core/widgets/primary_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:tabibi/features/doctor_details/presentation/controller/doctor_details_cubit.dart';
import 'package:tabibi/features/doctor_details/presentation/controller/doctor_details_state.dart';
import 'package:tabibi/features/doctor_details/presentation/widgets/doctor_details_header.dart';
import 'package:tabibi/features/doctor_details/presentation/widgets/doctor_stats.dart';
import 'package:tabibi/features/doctor_details/presentation/widgets/fav_bloc_builder.dart';
import 'package:tabibi/features/doctor_details/presentation/widgets/review_bloc_builder.dart';
import 'package:tabibi/features/doctor_details/presentation/widgets/review_item.dart';
import 'package:tabibi/features/home/data/models/doctor_model.dart';

class DoctorDetailsScreen extends StatelessWidget {
  final DoctorModel doctor;
  final String? heroTag;
  const DoctorDetailsScreen({super.key, required this.doctor, this.heroTag});

  static String _formatToLocal24Hour(String time24) {
    if (time24.isEmpty) return '';
    try {
      final parts = time24.split(':');
      if (parts.length < 2) return time24;
      final hour = int.parse(parts[0]);
      final minute = int.parse(parts[1]);
      final now = DateTime.now();
      final utcDateTime = DateTime.utc(
        now.year,
        now.month,
        now.day,
        hour,
        minute,
      );
      final localDateTime = utcDateTime.toLocal();
      return '${localDateTime.hour.toString().padLeft(2, '0')}:${localDateTime.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return time24;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final effectiveHeroTag = heroTag ?? 'doctor-avatar-${doctor.id}';

    return BlocProvider(
      create: (context) =>
          sl<DoctorDetailsCubit>()..getDoctorDetails(doctor.id),
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppStrings.doctorDetails),
          centerTitle: true,
          leadingWidth: 64.w,
          leading: Padding(
            padding: EdgeInsets.only(left: 20.w),
            child: Container(
              height: 40.h,
              width: 40.w,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isDark ? AppColors.grey800 : AppColors.borderLight,
                ),
                color: isDark ? AppColors.darkSurface : Colors.white,
              ),
              child: IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: Icon(
                  Iconsax.arrow_left,
                  size: 20.sp,
                  color: isDark ? Colors.white : AppColors.black,
                ),
                onPressed: () => context.pop(),
              ),
            ),
          ),
          actions: [
            FavouriteBlocBuilder(doctor: doctor),
            SizedBox(width: 20.w),
          ],
        ),
        body: BlocBuilder<DoctorDetailsCubit, DoctorDetailsState>(
          builder: (context, state) {
            if (state is DoctorDetailsFailure) {
              return Center(child: Text(state.message));
            }

            if (state is DoctorDetailsSuccess) {
              final details = state.doctorDetails;
              return SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DoctorDetailsHeader(
                      doctor: details,
                      heroTag: effectiveHeroTag,
                    ),
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
                        fontSize: 16.sp,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    ExpandableAboutText(
                      text:
                          details.bio ??
                          'doctorDetailsDescription'.tr(
                            namedArgs: {
                              'name': '${"drPrefix".tr()}${details.name}',
                              'department': details.department,
                            },
                          ),
                    ),
                    SizedBox(height: 24.h),
                    Text(
                      AppStrings.workingTime,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Divider(
                      color: isDark ? AppColors.grey800 : AppColors.borderLight,
                      thickness: 1,
                    ),
                    SizedBox(height: 8.h),
                    ...details.schedule.map(
                      (s) => Padding(
                        padding: EdgeInsets.symmetric(vertical: 6.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              Formatter.getDayName(s.dayOfWeek),
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    color: AppColors.grey500,
                                    fontSize: 14.sp,
                                  ),
                            ),
                            Text(
                              '${_formatToLocal24Hour(s.openTime)} - ${_formatToLocal24Hour(s.closeTime)}',
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    color: isDark
                                        ? Colors.white
                                        : AppColors.black,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14.sp,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 24.h),
                    Text(
                      AppStrings.consultationFee,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'fee'.tr(),
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: AppColors.grey500,
                                fontSize: 14.sp,
                              ),
                        ),
                        Text(
                          '${details.consultationFee} EGP',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 16.sp,
                              ),
                        ),
                      ],
                    ),
                    SizedBox(height: 24.h),
                    ReviewBlocBuilder(details: details),
                    if (details.reviews.isEmpty)
                      Text('noReviewsYet'.tr())
                    else
                      ...details.reviews
                          .take(3)
                          .map(
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

            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _HeroLoadingHeader(doctor: doctor, heroTag: effectiveHeroTag),
                  SizedBox(height: 24.h),
                  const Center(child: CircularProgressIndicator()),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _HeroLoadingHeader extends StatelessWidget {
  const _HeroLoadingHeader({required this.doctor, required this.heroTag});

  final DoctorModel doctor;
  final String heroTag;

  @override
  Widget build(BuildContext context) {
    final title = doctor.name.startsWith('Dr.')
        ? doctor.name
        : '${"drPrefix".tr()}${doctor.name}';

    return Row(
      children: [
        Hero(
          tag: heroTag,
          child: Container(
            width: 90.w,
            height: 90.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.grey100,
              image: doctor.avatarUrl != null && doctor.avatarUrl!.isNotEmpty
                  ? DecorationImage(
                      image: NetworkImage(doctor.avatarUrl!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: doctor.avatarUrl == null || doctor.avatarUrl!.isEmpty
                ? const Icon(Icons.person, color: AppColors.grey400)
                : null,
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.sp,
                ),
              ),
              SizedBox(height: 6.h),
              Text(
                doctor.department ?? '',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.grey500,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                doctor.address ?? '',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.grey500,
                  fontSize: 13.sp,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ExpandableAboutText extends StatefulWidget {
  final String text;
  const ExpandableAboutText({super.key, required this.text});

  @override
  State<ExpandableAboutText> createState() => _ExpandableAboutTextState();
}

class _ExpandableAboutTextState extends State<ExpandableAboutText> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final text = widget.text;
    const maxLength = 120;
    if (text.length <= maxLength) {
      return Text(
        text,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: AppColors.grey500,
          height: 1.5,
          fontSize: 14.sp,
        ),
      );
    }

    return RichText(
      text: TextSpan(
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: AppColors.grey500,
          height: 1.5,
          fontSize: 14.sp,
          fontFamily: Theme.of(context).textTheme.bodyMedium?.fontFamily,
        ),
        children: [
          TextSpan(
            text: isExpanded ? text : '${text.substring(0, maxLength)}... ',
          ),
          WidgetSpan(
            alignment: PlaceholderAlignment.baseline,
            baseline: TextBaseline.alphabetic,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  isExpanded = !isExpanded;
                });
              },
              child: Text(
                isExpanded ? 'showLess'.tr() : 'readMore'.tr(),
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
