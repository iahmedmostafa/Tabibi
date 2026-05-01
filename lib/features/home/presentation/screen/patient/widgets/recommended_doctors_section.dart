import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
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
          return const Center(child: CircularProgressIndicator());
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
          height: 290.h,
          child: BlocBuilder<FavoritesCubit, FavoritesState>(
            bloc: sl<FavoritesCubit>(),
            builder: (context, favoriteState) {
              return ListView.separated(
                scrollDirection: Axis.horizontal,
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
    final surfaceColor = Theme.of(context).cardColor;

    return InkWell(
      onTap: () => context.push(AppRoutes.doctorDetails, extra: doctor),
      borderRadius: BorderRadius.circular(24.r),
      child: Ink(
        width: 180.w,
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: BorderRadius.circular(24.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.midnightBlue.withValues(alpha: 0.06),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(24.r),
                      ),
                      color: AppColors.cardImageBackground,
                      image: doctor.avatarUrl != null
                          ? DecorationImage(
                              image: CachedNetworkImageProvider(
                                doctor.avatarUrl!,
                              ),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: doctor.avatarUrl == null
                        ? Center(
                            child: Icon(
                              Iconsax.user,
                              size: 54.sp,
                              color: AppColors.grey400,
                            ),
                          )
                        : null,
                  ),
                  Positioned(
                    top: 10.h,
                    left: 10.w,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 5.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.successLight,
                        borderRadius: BorderRadius.circular(999.r),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.star_rounded,
                            color: AppColors.actionGreen,
                            size: 16,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            doctor.rating!.toStringAsFixed(1),
                            style: TextStyle(
                              color: AppColors.successDark,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 10.h,
                    right: 10.w,
                    child: InkWell(
                      onTap: onFavoriteTap,
                      borderRadius: BorderRadius.circular(999.r),
                      child: Container(
                        width: 34.w,
                        height: 34.w,
                        decoration: const BoxDecoration(
                          color: AppColors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: isFavorite
                              ? AppColors.error
                              : AppColors.grey500,
                          size: 18.sp,
                        ),
                      ),
                    ),
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
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    doctor.department ?? 'General Medicine',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    doctor.address ?? 'Clinic address not available',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    '${doctor.reviewCount} Reviews',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    'EGP ${doctor.consultationFee.toStringAsFixed(0)}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
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
