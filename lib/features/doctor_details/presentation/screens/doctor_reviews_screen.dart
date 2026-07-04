import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tabibi/core/DI/service_locator.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';
import 'package:tabibi/core/utils/constants/app_strings.dart';
import 'package:tabibi/features/doctor_details/presentation/controller/reviews_cubit.dart';
import 'package:tabibi/features/doctor_details/presentation/controller/reviews_state.dart';
import 'package:tabibi/features/doctor_details/presentation/widgets/review_item.dart';
import 'package:easy_localization/easy_localization.dart';

class DoctorReviewsScreen extends StatefulWidget {
  final String doctorId;

  const DoctorReviewsScreen({super.key, required this.doctorId});

  @override
  State<DoctorReviewsScreen> createState() => _DoctorReviewsScreenState();
}

class _DoctorReviewsScreenState extends State<DoctorReviewsScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<ReviewsCubit>().getMoreReviews(widget.doctorId);
    }
  }

  Widget _buildFilterChip(
    BuildContext context,
    String label, {
    bool isActive = false,
    IconData? icon,
    bool hasDropdown = false,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: isActive
            ? AppColors.primary
            : (isDark ? AppColors.darkSurface : Colors.white),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: isActive
              ? AppColors.primary
              : (isDark ? AppColors.grey800 : AppColors.grey300),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: 16.sp,
              color: isActive
                  ? Colors.white
                  : (isDark ? Colors.white : AppColors.black),
            ),
            SizedBox(width: 6.w),
          ],
          Text(
            label,
            style: TextStyle(
              color: isActive
                  ? Colors.white
                  : (isDark
                        ? AppColors.textDarkSecondary
                        : AppColors.textSecondary),
              fontWeight: FontWeight.w600,
              fontSize: 13.sp,
            ),
          ),
          if (hasDropdown) ...[
            SizedBox(width: 4.w),
            Icon(
              Icons.arrow_drop_down,
              size: 18.sp,
              color: isDark ? Colors.white : AppColors.black,
            ),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return BlocProvider(
      create: (context) => sl<ReviewsCubit>()..getReviews(widget.doctorId),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            AppStrings.reviews,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: BlocBuilder<ReviewsCubit, ReviewsState>(
          builder: (context, state) {
            if (state is ReviewsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ReviewsFailure) {
              return Center(child: Text(state.message));
            } else if (state is ReviewsSuccess ||
                state is ReviewsPaginationLoading) {
              final reviews = state is ReviewsSuccess
                  ? state.reviews
                  : (state as ReviewsPaginationLoading).reviews;
              final hasNextPage = state is ReviewsSuccess
                  ? state.hasNextPage
                  : true;

              return Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 24.w,
                      vertical: 12.h,
                    ),
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: 'searchInReviews'.tr(),
                        prefixIcon: Icon(
                          Iconsax.search_normal,
                          color: AppColors.primary,
                          size: 20.sp,
                        ),
                        hintStyle: TextStyle(
                          color: AppColors.grey400,
                          fontSize: 14.sp,
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 12.h,
                        ),
                        filled: true,
                        fillColor: isDark
                            ? AppColors.darkSurface
                            : Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16.r),
                          borderSide: BorderSide(
                            color: isDark
                                ? AppColors.grey800
                                : AppColors.grey200,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16.r),
                          borderSide: BorderSide(
                            color: isDark
                                ? AppColors.grey800
                                : AppColors.grey200,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16.r),
                          borderSide: const BorderSide(
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 38.h,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      children: [
                        _buildFilterChip(
                          context,
                          'filter'.tr(),
                          icon: Iconsax.setting_4,
                          hasDropdown: true,
                        ),
                        SizedBox(width: 8.w),
                        _buildFilterChip(
                          context,
                          'verified'.tr(),
                          isActive: true,
                        ),
                        SizedBox(width: 8.w),
                        _buildFilterChip(
                          context,
                          'latest'.tr(),
                          isActive: true,
                        ),
                        SizedBox(width: 8.w),
                        _buildFilterChip(context, 'withPhotos'.tr()),
                        SizedBox(width: 8.w),
                        _buildFilterChip(context, 'detailed'.tr()),
                      ],
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Expanded(
                    child: reviews.isEmpty
                        ? Center(child: Text('noReviewsFound'.tr()))
                        : ListView.builder(
                            controller: _scrollController,
                            padding: EdgeInsets.symmetric(
                              horizontal: 24.w,
                              vertical: 8.h,
                            ),
                            itemCount: reviews.length + (hasNextPage ? 1 : 0),
                            itemBuilder: (context, index) {
                              if (index < reviews.length) {
                                return Padding(
                                  padding: EdgeInsets.only(bottom: 8.h),
                                  child: ReviewItem(review: reviews[index]),
                                );
                              } else {
                                return const Center(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 16.0,
                                    ),
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              }
                            },
                          ),
                  ),
                ],
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
