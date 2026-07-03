import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';
import 'package:tabibi/core/utils/constants/app_styles.dart';
import 'package:tabibi/features/doctor/core/doctor_localizations.dart';
import 'package:tabibi/features/doctor/core/widgets/doctor_card.dart';
import 'package:tabibi/features/doctor_profile/domain/entities/doctor_profile.dart';
import 'package:tabibi/features/doctor/profile/presentation/widget/stat_item.dart';

class ProfileHeader extends StatelessWidget {
  final DoctorProfile profile;
  final double rating;
  final int reviews;
  final VoidCallback? onCameraTap;

  const ProfileHeader({
    super.key,
    required this.profile,
    required this.rating,
    required this.reviews,
    this.onCameraTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final loc = DoctorLocalizations.of(context);
    final hasAvatar = profile.avatarUrl != null && profile.avatarUrl!.isNotEmpty;

    return DoctorCard(
      padding: EdgeInsets.all(24.w),
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                width: 100.w,
                height: 100.w,
                decoration: BoxDecoration(
                  color: isDark ? AppColors.grey800 : AppColors.teal200,
                  shape: BoxShape.circle,
                  image: hasAvatar
                      ? DecorationImage(
                          image: CachedNetworkImageProvider(profile.avatarUrl!),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: !hasAvatar
                    ? Center(
                        child: Text(
                          profile.initials,
                          style: AppTextStyle.h1.copyWith(
                            color: isDark ? Colors.white : AppColors.midnightBlue,
                            fontSize: 36.sp,
                          ),
                        ),
                      )
                    : null,
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: onCameraTap,
                  child: Container(
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      color: AppColors.midnightBlue,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isDark ? AppColors.darkSurface : Colors.white,
                        width: 2,
                      ),
                    ),
                    child: Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                      size: 16.sp,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Text(
            profile.name,
            style: AppTextStyle.h1.copyWith(
              color: isDark ? Colors.white : AppColors.grey900,
              fontSize: 20.sp,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            profile.departmentName.isNotEmpty ? profile.departmentName : loc.doctor,
            style: AppTextStyle.bodySRegular.copyWith(
              color: isDark ? AppColors.grey400 : AppColors.grey500,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            profile.email,
            style: AppTextStyle.bodyXsMedium.copyWith(
              color: isDark ? AppColors.grey500 : AppColors.grey400,
            ),
          ),
          SizedBox(height: 20.h),
          Container(
            padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.05)
                  : AppColors.grey50,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                StatItem(
                  value: rating.toStringAsFixed(1),
                  label: loc.rating,
                ),
                Container(
                  width: 1,
                  height: 40.h,
                  color: isDark ? AppColors.grey700 : AppColors.grey200,
                ),
                StatItem(
                  value: reviews.toString(),
                  label: loc.reviews,
                ),
                Container(
                  width: 1,
                  height: 40.h,
                  color: isDark ? AppColors.grey700 : AppColors.grey200,
                ),
                StatItem(
                  value: profile.yearsOfExperience.toString(),
                  label: loc.years,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
