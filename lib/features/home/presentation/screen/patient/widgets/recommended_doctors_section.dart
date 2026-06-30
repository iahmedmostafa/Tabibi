import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:tabibi/core/DI/service_locator.dart';
import 'package:tabibi/core/routing/app_routes.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';
import 'package:tabibi/core/utils/enums/enums.dart';
import 'package:tabibi/features/favorite/presentation/controller/favorites_cubit.dart';
import 'package:tabibi/features/home/data/models/doctor_model.dart';
import 'package:tabibi/features/home/presentation/screen/patient/cubit/doctors_cubit.dart';
import 'package:tabibi/features/home/presentation/screen/patient/cubit/doctors_state.dart';
import 'package:tabibi/features/home/presentation/screen/patient/widgets/home_feedback_panel.dart';

class RecommendedDoctorsSection extends StatelessWidget {
  const RecommendedDoctorsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DoctorsCubit, DoctorsState>(
      builder: (context, state) {
        if (state.status == DoctorsStatus.loading) {
          return _DoctorsSkeleton();
        }

        if (state.status == DoctorsStatus.failure) {
          return ErrorPanel(
            message: state.errorMessage ?? 'Failed to load doctors',
          );
        }

        final doctors = state.doctors.take(8).toList();
        if (doctors.isEmpty) {
          return const EmptyPanel(message: 'No doctors available right now');
        }

        return SizedBox(
          height: 268.h,
          child: BlocBuilder<FavoritesCubit, FavoritesState>(
            bloc: sl<FavoritesCubit>(),
            builder: (context, favoriteState) {
              return ListView.separated(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.only(right: 8.w),
                itemCount: doctors.length,
                separatorBuilder: (_, _) => SizedBox(width: 14.w),
                itemBuilder: (context, index) {
                  final doctor = doctors[index];
                  final isFavorite = favoriteState.favoritedIds.contains(
                    doctor.id,
                  );
                  return _RecommendedDoctorCard(
                    doctor: doctor,
                    isFavorite: isFavorite,
                    onFavoriteTap: () =>
                        sl<FavoritesCubit>().toggleFavorite(doctor),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}

class _RecommendedDoctorCard extends StatelessWidget {
  const _RecommendedDoctorCard({
    required this.doctor,
    required this.isFavorite,
    required this.onFavoriteTap,
  });

  final DoctorModel doctor;
  final bool isFavorite;
  final VoidCallback onFavoriteTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final rating = doctor.rating ?? 0;
    final reviewCount = doctor.reviewCount ?? 0;
    final heroTag = 'doctor-avatar-${doctor.id}';
    final cardSurface = isDark ? AppColors.grey900 : AppColors.white;
    final cardBorder = isDark
        ? AppColors.grey800
        : AppColors.black.withValues(alpha: 0.1);
    final titleColor = isDark ? AppColors.white : AppColors.black;
    final bodyColor = isDark ? AppColors.grey400 : AppColors.grey500;    final imageBg = isDark ? AppColors.grey800 : AppColors.grey300;
    final imageIconColor = isDark ? AppColors.grey400 : AppColors.grey500;

    return InkWell(
      onTap: () => context.push(AppRoutes.doctorDetails, extra: doctor),
      borderRadius: BorderRadius.circular(18.r),
      child: Container(
        width: 244.w,
        decoration: BoxDecoration(
          color: cardSurface,
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(color: cardBorder),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.24 : 0.08),
              blurRadius: isDark ? 18 : 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 150.h,
              child: Stack(
                children: [
                  Hero(
                    tag: heroTag,
                    child: ClipRRect(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(18.r),
                      ),
                      child: Container(
                        width: double.infinity,
                        height: double.infinity,
                        color: imageBg,
                        child: doctor.avatarUrl != null
                            ? CachedNetworkImage(
                                imageUrl: doctor.avatarUrl!,
                                fit: BoxFit.cover,
                                placeholder: (context, url) =>
                                    Container(color: imageBg),
                                errorWidget: (context, url, error) =>
                                    _DoctorImageFallback(color: imageIconColor),
                              )
                            : _DoctorImageFallback(color: imageIconColor),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 12.h,
                    right: 12.w,
                    child: InkWell(
                      onTap: onFavoriteTap,
                      borderRadius: BorderRadius.circular(999.r),
                      child: Container(
                        width: 38.r,
                        height: 38.r,
                        decoration: BoxDecoration(
                          color: isDark
                              ? AppColors.grey800
                              : AppColors.white.withOpacity(0.78),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(
                                isDark ? 0.18 : 0.06,
                              ),
                              blurRadius: 12,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: isFavorite
                              ? AppColors.error
                              : (isDark ? AppColors.grey300 : AppColors.white),
                          size: 19.sp,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 10.w,
                    bottom: 10.h,
                    child: _RatingPill(rating: rating, isDark: isDark),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(14.w, 12.h, 14.w, 14.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    doctor.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: titleColor,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    doctor.department ?? 'General Medicine',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: bodyColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 7.h),
                  Row(
                    children: [
                      Icon(
                        Iconsax.location5,
                        color: AppColors.primary,
                        size: 14.sp,
                      ),
                      SizedBox(width: 4.w),
                      Expanded(
                        child: Text(
                          doctor.address ?? 'Clinic address',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: bodyColor,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 9.h),
                  Row(
                    children: [
                      Text(
                        'EGP ${doctor.consultationFee.toStringAsFixed(0)}',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: titleColor,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '$reviewCount reviews',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: bodyColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DoctorImageFallback extends StatelessWidget {
  const _DoctorImageFallback({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Icon(Iconsax.user, size: 54.sp, color: color),
    );
  }
}

class _RatingPill extends StatelessWidget {
  const _RatingPill({required this.rating, required this.isDark});

  final double rating;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 7.h),
      decoration: BoxDecoration(
        color: isDark ? AppColors.grey800 : AppColors.white,
        borderRadius: BorderRadius.circular(999.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.18 : 0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.star_rounded, color: AppColors.actionAmber, size: 16.sp),
          SizedBox(width: 4.w),
          Text(
            rating > 0 ? rating.toStringAsFixed(1) : 'New',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: isDark ? AppColors.grey100 : AppColors.black,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _DoctorsSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final skeleton = isDark ? AppColors.grey800 : Colors.white;

    return Skeletonizer(
      enabled: true,
      child: SizedBox(
        height: 268.h,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 3,
          separatorBuilder: (_, _) => SizedBox(width: 14.w),
          itemBuilder: (context, index) {
            return Container(
              width: 244.w,
              decoration: BoxDecoration(
                color: isDark ? AppColors.grey900 : Colors.white,
                borderRadius: BorderRadius.circular(18.r),
                border: Border.all(
                  color: isDark ? AppColors.grey800 : AppColors.grey100,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 150.h,
                    width: double.infinity,
                    color: skeleton,
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(14.w, 12.h, 14.w, 14.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(width: 140.w, height: 16.h, color: skeleton),
                        SizedBox(height: 6.h),
                        Container(width: 90.w, height: 12.h, color: skeleton),
                        SizedBox(height: 7.h),
                        Row(
                          children: [
                            const Icon(
                              Iconsax.location5,
                              size: 14,
                              color: AppColors.grey500,
                            ),
                            SizedBox(width: 4.w),
                            Container(
                              width: 100.w,
                              height: 12.h,
                              color: skeleton,
                            ),
                          ],
                        ),
                        SizedBox(height: 9.h),
                        Row(
                          children: [
                            Container(
                              width: 60.w,
                              height: 16.h,
                              color: skeleton,
                            ),
                            const Spacer(),
                            Container(
                              width: 60.w,
                              height: 12.h,
                              color: skeleton,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

