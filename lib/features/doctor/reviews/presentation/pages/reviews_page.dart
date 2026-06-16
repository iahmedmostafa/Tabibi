import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:tabibi/core/DI/service_locator.dart';
import 'package:tabibi/core/animations/fade_in_slide.dart';
import 'package:tabibi/core/utils/theme/theme.dart';
import 'package:tabibi/features/doctor/reviews/domain/entities/review.dart';
import 'package:tabibi/features/doctor/reviews/presentation/cubit/reviews_cubit.dart';
import 'package:tabibi/features/doctor/reviews/presentation/cubit/reviews_state.dart';

class ReviewsPage extends StatelessWidget {
  const ReviewsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ReviewsCubit>()..getReviews(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Reviews & Ratings', style: TextStyle(fontSize: 20.sp)),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, size: 24.sp),
            onPressed: () => context.pop(),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.filter_list, size: 24.sp),
              onPressed: () {},
            ),
          ],
        ),
        body: BlocBuilder<ReviewsCubit, ReviewsState>(
          builder: (context, state) {
            if (state.status == ReviewsStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.status == ReviewsStatus.failure) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.all(24.w),
                  child: Text(state.errorMessage ?? 'Failed to load reviews'),
                ),
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
    final theme = Theme.of(context);
    return BlocBuilder<ReviewsCubit, ReviewsState>(
      buildWhen: (previous, current) => previous.summary != current.summary,
      builder: (context, state) {
        final summary = state.summary;
        return Container(
          padding: EdgeInsets.all(24.w),
          color: theme.cardColor,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    Text(
                      summary.averageRating.toStringAsFixed(1),
                      style: TextStyle(
                        fontSize: 48.sp,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        5,
                        (index) => Icon(
                          Icons.star,
                          color: AppTheme.orangeIcon,
                          size: 20.sp,
                        ),
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      '${summary.totalReviews} reviews',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: theme.colorScheme.onSurfaceVariant,
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
    final theme = Theme.of(context);
    return Row(
      children: [
        Text(
          '$rating',
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
            color: theme.colorScheme.onSurface,
          ),
        ),
        SizedBox(width: 4.w),
        Icon(Icons.star, color: AppTheme.orangeIcon, size: 14.sp),
        SizedBox(width: 8.w),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4.r),
            child: LinearProgressIndicator(
              value: percentage / 100,
              backgroundColor: theme.dividerColor,
              valueColor: AlwaysStoppedAnimation<Color>(AppTheme.orangeIcon),
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
            style: TextStyle(
              fontSize: 12.sp,
              color: theme.colorScheme.onSurfaceVariant,
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
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryColor : theme.cardColor,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: isSelected ? AppTheme.primaryColor : theme.dividerColor,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : theme.colorScheme.onSurface,
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
    final theme = Theme.of(context);
    return BlocBuilder<ReviewsCubit, ReviewsState>(
      buildWhen: (previous, current) =>
          previous.filteredReviews != current.filteredReviews,
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Text(
                'Patient Reviews',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ),
            SizedBox(height: 12.h),
            if (state.filteredReviews.isEmpty)
              Padding(
                padding: EdgeInsets.all(32.w),
                child: Center(
                  child: Text(
                    'No reviews found for this rating',
                    style: TextStyle(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontSize: 14.sp,
                    ),
                  ),
                ),
              )
            else
              ...state.filteredReviews.asMap().entries.map(
                (entry) => FadeInSlide(
                  delay: Duration(milliseconds: 80 * entry.key),
                  child: _ReviewCard(review: entry.value),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _ReviewCard extends StatelessWidget {
  final Review review;

  const _ReviewCard({required this.review});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      color: theme.cardColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48.w,
                height: 48.w,
                decoration: BoxDecoration(
                  color: AppTheme.tealDark.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Center(
                  child: Text(
                    review.initials,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.tealDark,
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
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      DateFormat('MMM d, yyyy').format(review.date),
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: theme.colorScheme.onSurfaceVariant,
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
                    color: AppTheme.orangeIcon,
                    size: 16.sp,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            review.comment,
            style: TextStyle(
              fontSize: 14.sp,
              color: theme.colorScheme.onSurfaceVariant,
              height: 1.5,
            ),
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Icon(
                Icons.thumb_up_outlined,
                size: 16.sp,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              SizedBox(width: 4.w),
              Text(
                'Helpful (${review.helpfulCount})',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
