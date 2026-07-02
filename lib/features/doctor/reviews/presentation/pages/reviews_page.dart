import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:tabibi/core/DI/service_locator.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';
import 'package:tabibi/core/utils/constants/app_styles.dart';
import 'package:tabibi/features/doctor/core/widgets/doctor_card.dart';
import 'package:tabibi/features/doctor/core/widgets/doctor_empty_state.dart';
import 'package:tabibi/features/doctor/core/widgets/doctor_error_state.dart';
import 'package:tabibi/features/doctor/core/widgets/doctor_loading_state.dart';
import 'package:tabibi/features/doctor/core/widgets/doctor_section_header.dart';
import 'package:tabibi/features/doctor/reviews/domain/entities/review.dart';
import 'package:tabibi/features/doctor/reviews/presentation/cubit/reviews_cubit.dart';
import 'package:tabibi/features/doctor/reviews/presentation/cubit/reviews_state.dart';

class ReviewsPage extends StatelessWidget {
  const ReviewsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return BlocProvider(
      create: (context) => sl<ReviewsCubit>()..getReviews(),
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          title: Text('Reviews & Ratings', style: theme.textTheme.titleLarge),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new_rounded, size: 20.sp),
            onPressed: () => context.pop(),
          ),
          actions: [
            IconButton(
              icon: Icon(
                Icons.filter_list,
                size: 24.sp,
                color: isDark ? Colors.white : AppColors.grey900,
              ),
              onPressed: () {},
            ),
          ],
          surfaceTintColor: Colors.transparent,
        ),
        body: BlocBuilder<ReviewsCubit, ReviewsState>(
          builder: (context, state) {
            if (state.status == ReviewsStatus.loading) {
              return const DoctorLoadingState();
            }
            if (state.status == ReviewsStatus.failure) {
              return DoctorErrorState(
                message: state.errorMessage ?? 'Failed to load reviews',
                onRetry: () => context.read<ReviewsCubit>().getReviews(),
              );
            }
            return const SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _RatingSummaryCard(),
                  SizedBox(height: 16),
                  _FilterChips(),
                  SizedBox(height: 16),
                  _ReviewsList(),
                  SizedBox(height: 80),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _RatingSummaryCard extends StatelessWidget {
  const _RatingSummaryCard();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<ReviewsCubit, ReviewsState>(
      buildWhen: (previous, current) => previous.summary != current.summary,
      builder: (context, state) {
        final summary = state.summary;
        return DoctorCard(
          padding: EdgeInsets.all(24.w),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    Text(
                      summary.averageRating.toStringAsFixed(1),
                      style: AppTextStyle.h1.copyWith(
                        fontSize: 48.sp,
                        color: isDark ? Colors.white : AppColors.grey900,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        5,
                        (index) => Icon(
                          Icons.star,
                          color: const Color(0xFFFFB74D),
                          size: 20.sp,
                        ),
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      '${summary.totalReviews} reviews',
                      style: AppTextStyle.bodyXsMedium.copyWith(
                        color: isDark ? AppColors.grey400 : AppColors.grey500,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 24.w),
              Expanded(
                flex: 3,
                child: Column(
                  children: [
                    for (int i = 5; i >= 1; i--)
                      Padding(
                        padding: EdgeInsets.only(bottom: 8.h),
                        child: _RatingBar(
                          rating: i,
                          count: summary.getRatingCount(i),
                          percentage: summary.getRatingPercentage(i),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _RatingBar extends StatelessWidget {
  final int rating;
  final int count;
  final double percentage;

  const _RatingBar({
    required this.rating,
    required this.count,
    required this.percentage,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      children: [
        Text(
          '$rating',
          style: AppTextStyle.bodyXsMedium.copyWith(
            color: isDark ? Colors.white : AppColors.grey900,
          ),
        ),
        SizedBox(width: 4.w),
        Icon(Icons.star, color: const Color(0xFFFFB74D), size: 14.sp),
        SizedBox(width: 8.w),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4.r),
            child: LinearProgressIndicator(
              value: percentage / 100,
              backgroundColor: isDark ? AppColors.grey800 : AppColors.grey200,
              valueColor: const AlwaysStoppedAnimation<Color>(
                Color(0xFFFFB74D),
              ),
              minHeight: 6.h,
            ),
          ),
        ),
        SizedBox(width: 8.w),
        SizedBox(
          width: 30.w,
          child: Text(
            count.toString(),
            textAlign: TextAlign.end,
            style: AppTextStyle.bodyXsMedium.copyWith(
              color: isDark ? AppColors.grey400 : AppColors.grey500,
            ),
          ),
        ),
      ],
    );
  }
}

class _FilterChips extends StatelessWidget {
  const _FilterChips();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReviewsCubit, ReviewsState>(
      buildWhen: (previous, current) =>
          previous.selectedRatingFilter != current.selectedRatingFilter,
      builder: (context, state) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _FilterChip(
                  label: 'All',
                  isSelected: state.selectedRatingFilter == null,
                  onTap: () =>
                      context.read<ReviewsCubit>().filterByRating(null),
                ),
                SizedBox(width: 8.w),
                for (int i = 5; i >= 2; i--)
                  Padding(
                    padding: EdgeInsets.only(right: 8.w),
                    child: _FilterChip(
                      label: '$i ⭐',
                      isSelected: state.selectedRatingFilter == i,
                      onTap: () =>
                          context.read<ReviewsCubit>().filterByRating(i),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.midnightBlue
              : (isDark ? AppColors.darkSurface : Colors.white),
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: isSelected
                ? AppColors.midnightBlue
                : (isDark ? AppColors.grey800 : AppColors.grey200),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected
                ? Colors.white
                : (isDark ? AppColors.grey400 : AppColors.grey700),
            fontSize: 14.sp,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

class _ReviewsList extends StatelessWidget {
  const _ReviewsList();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: DoctorSectionHeader(title: 'Patient Reviews'),
        ),
        SizedBox(height: 12.h),
        BlocBuilder<ReviewsCubit, ReviewsState>(
          buildWhen: (previous, current) =>
              previous.filteredReviews != current.filteredReviews,
          builder: (context, state) {
            if (state.filteredReviews.isEmpty) {
              return const DoctorEmptyState(
                icon: Icons.reviews_outlined,
                message: 'No reviews found for this rating',
              );
            }
            return Column(
              children: state.filteredReviews.map(
                (review) => _ReviewCard(review: review),
              ).toList(),
            );
          },
        ),
      ],
    );
  }
}

class _ReviewCard extends StatelessWidget {
  final Review review;

  const _ReviewCard({required this.review});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return DoctorCard(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48.w,
                height: 48.w,
                decoration: BoxDecoration(
                  color: isDark ? AppColors.grey800 : AppColors.grey200,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Center(
                  child: Text(
                    review.initials,
                    style: AppTextStyle.bodySBold.copyWith(
                      color: isDark ? Colors.white : AppColors.grey700,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.patientName,
                      style: AppTextStyle.bodySMedium.copyWith(
                        color: isDark ? Colors.white : AppColors.grey900,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      DateFormat('MMM d, yyyy').format(review.date),
                      style: AppTextStyle.bodyXsMedium.copyWith(
                        color: isDark ? AppColors.grey400 : AppColors.grey500,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: List.generate(
                  5,
                  (index) => Icon(
                    index < review.rating ? Icons.star : Icons.star_border,
                    color: const Color(0xFFFFB74D),
                    size: 16.sp,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            review.comment,
            style: AppTextStyle.bodySRegular.copyWith(
              color: isDark ? AppColors.grey300 : AppColors.grey700,
              height: 1.5,
            ),
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Icon(
                Icons.thumb_up_outlined,
                size: 16.sp,
                color: isDark ? AppColors.grey400 : AppColors.grey500,
              ),
              SizedBox(width: 4.w),
              Text(
                'Helpful (${review.helpfulCount})',
                style: AppTextStyle.bodyXsMedium.copyWith(
                  color: isDark ? AppColors.grey400 : AppColors.grey500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
