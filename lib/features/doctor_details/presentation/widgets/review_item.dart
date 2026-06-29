import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';
import 'package:tabibi/core/utils/constants/app_images.dart';
import 'package:tabibi/features/doctor_details/domain/entities/doctor_details_entity.dart';

class ReviewItem extends StatelessWidget {
  final DoctorReview review;

  const ReviewItem({super.key, required this.review});

  String _getRelativeTime(DateTime dateTime) {
    final duration = DateTime.now().difference(dateTime);
    if (duration.inDays > 365) {
      final years = (duration.inDays / 365).floor();
      return "$years year${years > 1 ? 's' : ''} ago";
    } else if (duration.inDays > 30) {
      final months = (duration.inDays / 30).floor();
      return "$months month${months > 1 ? 's' : ''} ago";
    } else if (duration.inDays > 0) {
      return "${duration.inDays} day${duration.inDays > 1 ? 's' : ''} ago";
    } else if (duration.inHours > 0) {
      return "${duration.inHours} hour${duration.inHours > 1 ? 's' : ''} ago";
    } else {
      return "just now";
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  backgroundImage: review.patientAvatar != null
                      ? CachedNetworkImageProvider(review.patientAvatar!)
                            as ImageProvider
                      : const AssetImage(AppImages.person),
                  radius: 24.r,
                  backgroundColor: AppColors.grey200,
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    padding: EdgeInsets.all(1.5.r),
                    child: Icon(
                      Icons.verified,
                      color: AppColors.primary,
                      size: 13.sp,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    review.patientName,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 15.sp,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.star,
                      color: Colors.amber,
                      size: 18.sp,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      review.rating.toStringAsFixed(1),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 14.sp,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4.h),
                Text(
                  _getRelativeTime(review.createdAt),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.grey400,
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
          ],
        ),
        if (review.comment != null && review.comment!.isNotEmpty) ...[
          SizedBox(height: 12.h),
          Text(
            review.comment!,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: isDark ? AppColors.textDarkSecondary : AppColors.textSecondary,
              height: 1.4,
              fontSize: 13.sp,
            ),
          ),
        ],
        SizedBox(height: 16.h),
        Divider(
          color: isDark ? AppColors.grey800 : AppColors.grey200,
          thickness: 1,
        ),
      ],
    );
  }
}
