import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:tabibi/core/DI/service_locator.dart';
import 'package:tabibi/core/routing/app_routes.dart';
import 'package:tabibi/core/style/spacing/vertical_space.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';
import 'package:tabibi/core/utils/constants/app_images.dart';
import 'package:tabibi/core/utils/enums/enums.dart';
import 'package:tabibi/features/favorite/presentation/controller/favorites_cubit.dart';
import 'package:tabibi/features/home/presentation/screen/patient/cubit/doctors_cubit.dart';
import 'package:tabibi/features/home/presentation/screen/patient/cubit/doctors_state.dart';
import 'package:tabibi/features/home/presentation/screen/patient/widgets/custom_doctor_cart.dart';

class AllDoctorsBlocBuilder extends StatelessWidget {
  const AllDoctorsBlocBuilder({
    super.key,
    required ScrollController scrollController,
  }) : _scrollController = scrollController;

  final ScrollController _scrollController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DoctorsCubit, DoctorsState>(
      builder: (context, state) {
        if (state.status == DoctorsStatus.loading) {
          return _AllDoctorsSkeleton();
        }

        if (state.status == DoctorsStatus.failure) {
          return Center(
            child: Text(state.errorMessage ?? 'Error loading doctors'),
          );
        }

        final doctors = state.doctors;
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final titleColor = isDark ? AppColors.white : AppColors.midnightBlue;
        final mutedColor = isDark ? AppColors.grey400 : AppColors.grey500;

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${doctors.length} Doctors found',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: titleColor,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        'Default',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: mutedColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Icon(
                        Icons.unfold_more,
                        size: 16.sp,
                        color: mutedColor,
                      ),
                    ],
                  ),
                ],
              ),
              VerticalSpace(height: 16.h),
              Expanded(
                child: doctors.isEmpty
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            AppImages.doctorNotFound,
                            fit: BoxFit.cover,
                          ),
                          VerticalSpace(height: 16.h),
                          Text(
                            'No doctors found',
                            style: TextStyle(
                              color: isDark ? AppColors.grey400 : AppColors.textSecondary,
                              fontSize: 16.sp,
                            ),
                          ),
                        ],
                      )
                    : BlocBuilder<FavoritesCubit, FavoritesState>(
                        bloc: sl<FavoritesCubit>(),
                        builder: (context, favState) {
                          return ListView.separated(
                            controller: _scrollController,
                            padding: EdgeInsets.only(bottom: 20.h),
                            itemCount: state.hasReachedMax
                                ? doctors.length
                                : doctors.length + 1,
                            separatorBuilder: (context, index) =>
                                VerticalSpace(height: 16.h),
                            itemBuilder: (context, index) {
                              if (index >= doctors.length) {
                                return const Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              }
                              final doctor = doctors[index];
                              final isFav = favState.favoritedIds.contains(
                                doctor.id,
                              );
                              return AnimationConfiguration.staggeredList(
                                position: index,
                                duration: const Duration(milliseconds: 420),
                                child: SlideAnimation(
                                  verticalOffset: 18,
                                  child: FadeInAnimation(
                                    child: GestureDetector(
                                      onTap: () {
                                        context.push(
                                          AppRoutes.doctorDetails,
                                          extra: doctor,
                                        );
                                      },
                                      child: DoctorCard(
                                        doctor: doctor,
                                        isFavorite: isFav,
                                        onFavoriteTap: () {
                                          sl<FavoritesCubit>().toggleFavorite(
                                            doctor,
                                          );
                                        },
                                        onBookTap: () {
                                          context.push(
                                            AppRoutes.doctorDetails,
                                            extra: doctor,
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _AllDoctorsSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final skeleton = isDark ? AppColors.grey800 : Colors.white;
    final cardBg = isDark ? AppColors.grey900 : Colors.white;
    final lineBg = isDark ? AppColors.grey800 : Colors.white;

    return Skeletonizer(
      enabled: true,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.only(bottom: 20.h),
          itemCount: 3,
          separatorBuilder: (context, index) => VerticalSpace(height: 16.h),
          itemBuilder: (context, index) {
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28.r),
                color: cardBg,
                border: Border.all(
                  color: isDark ? AppColors.grey800 : AppColors.grey100,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 190.h,
                    width: double.infinity,
                    color: skeleton,
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 14.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 180.w,
                          height: 18.h,
                          color: lineBg,
                        ),
                        SizedBox(height: 6.h),
                        Container(
                          width: 100.w,
                          height: 20.h,
                          decoration: BoxDecoration(
                            color: lineBg,
                            borderRadius: BorderRadius.circular(999.r),
                          ),
                        ),
                        SizedBox(height: 10.h),
                        Row(
                          children: [
                            Icon(Icons.location_on_rounded, size: 15, color: AppColors.grey500),
                            SizedBox(width: 4.w),
                            Container(
                              width: 150.w,
                              height: 12.h,
                              color: lineBg,
                            ),
                          ],
                        ),
                        SizedBox(height: 10.h),
                        Row(
                          children: [
                            Icon(Icons.star, size: 16, color: AppColors.grey500),
                            SizedBox(width: 4.w),
                            Container(
                              width: 30.w,
                              height: 12.h,
                              color: lineBg,
                            ),
                            SizedBox(width: 8.w),
                            Container(
                              width: 80.w,
                              height: 12.h,
                              color: lineBg,
                            ),
                          ],
                        ),
                        SizedBox(height: 10.h),
                        Row(
                          children: [
                            Container(
                              width: 80.w,
                              height: 16.h,
                              color: lineBg,
                            ),
                            const Spacer(),
                            Container(
                              width: 80.w,
                              height: 30.h,
                              decoration: BoxDecoration(
                                color: lineBg,
                                borderRadius: BorderRadius.circular(999.r),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 2.h),
                        Container(
                          width: 120.w,
                          height: 11.h,
                          color: lineBg,
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

