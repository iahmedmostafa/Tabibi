import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibi/core/style/spacing/horizental_space.dart';
import 'package:tabibi/core/style/spacing/vertical_space.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';
import 'package:tabibi/core/widgets/premium_animated_button.dart';
import 'package:tabibi/features/home/data/models/doctor_model.dart';

class DoctorCard extends StatelessWidget {
  final DoctorModel doctor;
  final bool isFavorite;
  final VoidCallback? onFavoriteTap;
  final VoidCallback? onBookTap;

  const DoctorCard({
    super.key,
    required this.doctor,
    this.isFavorite = false,
    this.onFavoriteTap,
    this.onBookTap,
  });

  @override
  Widget build(BuildContext context) {
    final rating = doctor.rating ?? 0;
    final reviewCount = doctor.reviewCount ?? 0;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28.r),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.white, AppColors.white.withValues(alpha: .96)],
        ),
        border: Border.all(color: AppColors.black.withValues(alpha: 0.1)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.15),
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 190.h,
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(28.r),
                  ),
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: doctor.avatarUrl != null
                            ? CachedNetworkImage(
                                imageUrl: doctor.avatarUrl!,
                                fit: BoxFit.cover,
                                placeholder: (context, url) =>
                                    Container(color: AppColors.grey100),
                                errorWidget: (context, url, error) => Container(
                                  color: AppColors.grey100,
                                  child: const Icon(
                                    Icons.person,
                                    color: AppColors.grey400,
                                    size: 44,
                                  ),
                                ),
                              )
                            : Container(
                                color: AppColors.grey100,
                                child: const Icon(
                                  Icons.person,
                                  color: AppColors.grey400,
                                  size: 44,
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 12.h,
                  left: 12.w,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 7.h,
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
                          rating > 0 ? rating.toStringAsFixed(1) : 'New',
                          style: TextStyle(
                            color: AppColors.successDark,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
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
                      width: 36.w,
                      height: 36.w,
                      decoration: BoxDecoration(
                        color: AppColors.white.withOpacity(0.92),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? AppColors.error : AppColors.grey500,
                        size: 18.sp,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 14.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  doctor.name,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.2,
                    color: AppColors.black,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                VerticalSpace(height: 6.h),
                _InfoPill(
                  label: doctor.department ?? 'General Medicine',
                  backgroundColor: AppColors.paleBlueLight,
                  textColor: AppColors.primary,
                ),
                VerticalSpace(height: 10.h),
                Row(
                  children: [
                    Icon(
                      Icons.location_on_rounded,
                      size: 15.sp,
                      color: AppColors.grey500,
                    ),
                    const HorizentalSpace(width: 4),
                    Expanded(
                      child: Text(
                        doctor.address ?? 'Clinic address not available',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: AppColors.grey500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                VerticalSpace(height: 10.h),
                Row(
                  children: [
                    Icon(Icons.star, color: AppColors.actionGreen, size: 16.sp),
                    const HorizentalSpace(width: 4),
                    Text(
                      rating > 0 ? rating.toStringAsFixed(1) : 'New',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w800,
                        color: AppColors.black,
                      ),
                    ),
                    const HorizentalSpace(width: 8),
                    Container(height: 12, width: 1, color: AppColors.grey300),
                    const HorizentalSpace(width: 8),
                    Text(
                      '$reviewCount Reviews',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.grey500,
                      ),
                    ),
                  ],
                ),
                VerticalSpace(height: 10.h),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'EGP ${doctor.consultationFee.toStringAsFixed(0)}',
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    PremiumAnimatedButton(
                      text: 'Book Now',
                      icon: Icons.calendar_today_rounded,
                      onTap: onBookTap ?? () {},
                    ),
                  ],
                ),
                VerticalSpace(height: 2.h),
                Text(
                  '${doctor.yearsOfExperience} years experience',
                  style: TextStyle(fontSize: 11.sp, color: AppColors.grey500),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoPill extends StatelessWidget {
  const _InfoPill({
    required this.label,
    required this.backgroundColor,
    required this.textColor,
  });

  final String label;
  final Color backgroundColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 7.h),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(999.r),
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: textColor,
          fontSize: 11.sp,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
