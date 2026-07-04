import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';
import 'package:tabibi/features/doctors_map/data/models/doctor_map_model.dart';
import 'package:easy_localization/easy_localization.dart';

class DoctorDetailsCard extends StatelessWidget {
  final DoctorMapModel doctor;
  final ScrollController scrollController;
  final VoidCallback onClose;
  final VoidCallback onGoNow;

  const DoctorDetailsCard({
    super.key,
    required this.doctor,
    required this.scrollController,
    required this.onClose,
    required this.onGoNow,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surface = isDark ? AppColors.grey900 : AppColors.white;
    final borderColor = isDark ? AppColors.grey800 : AppColors.grey200;
    final titleColor = isDark ? AppColors.white : AppColors.black;
    final bodyColor = isDark ? AppColors.grey400 : AppColors.grey600;
    final chipColor = isDark ? AppColors.grey800 : AppColors.grey100;

    return Material(
      color: surface,
      elevation: 18,
      shadowColor: Colors.black.withValues(alpha: isDark ? 0.35 : 0.14),
      borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
      child: Container(
        decoration: BoxDecoration(
          color: surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
          border: Border(top: BorderSide(color: borderColor)),
        ),
        child: ListView(
          controller: scrollController,
          padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 20.h),
          physics: const BouncingScrollPhysics(),
          children: [
            Center(
              child: Container(
                width: 48.w,
                height: 5.h,
                decoration: BoxDecoration(
                  color: isDark ? AppColors.grey700 : AppColors.grey300,
                  borderRadius: BorderRadius.circular(999.r),
                ),
              ),
            ),
            SizedBox(height: 14.h),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _DoctorAvatar(imageUrl: doctor.avatarUrl),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              doctor.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w800,
                                color: titleColor,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: onClose,
                            splashRadius: 18,
                            icon: Icon(Icons.close_rounded, color: bodyColor),
                          ),
                        ],
                      ),
                      SizedBox(height: 6.h),
                      _InfoChip(
                        label: doctor.displaySpecialty,
                        backgroundColor: chipColor,
                        textColor: isDark
                            ? AppColors.grey100
                            : AppColors.primary,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 18.h),
            Row(
              children: [
                _MetricTile(
                  icon: Icons.star_rounded,
                  label: doctor.displayRating,
                  value: '${doctor.reviewsCount ?? 0} reviews',
                  accentColor: AppColors.actionGreen,
                  isDark: isDark,
                ),
                SizedBox(width: 12.w),
                _MetricTile(
                  icon: Icons.straighten_rounded,
                  label: doctor.displayDistance,
                  value: 'from you',
                  accentColor: AppColors.primary,
                  isDark: isDark,
                ),
              ],
            ),
            SizedBox(height: 14.h),
            Container(
              padding: EdgeInsets.all(14.r),
              decoration: BoxDecoration(
                color: isDark ? AppColors.grey800 : AppColors.grey50,
                borderRadius: BorderRadius.circular(18.r),
              ),
              child: Row(
                children: [
                  Container(
                    width: 44.w,
                    height: 44.w,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                    child: Icon(
                      Icons.payments_rounded,
                      color: AppColors.primary,
                      size: 22.sp,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Consultation fee',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: bodyColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          doctor.displayFee,
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w800,
                            color: titleColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 12.h),
            _AddressRow(
              address: doctor.displayLocation,
              isDark: isDark,
              bodyColor: bodyColor,
              titleColor: titleColor,
            ),
            SizedBox(height: 18.h),
            SizedBox(
              height: 52.h,
              child: ElevatedButton.icon(
                onPressed: onGoNow,
                icon: const Icon(Icons.navigation_rounded),
                label: Text('goNow'.tr()),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  elevation: 0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DoctorAvatar extends StatelessWidget {
  final String? imageUrl;

  const _DoctorAvatar({this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final placeholder = isDark ? AppColors.grey800 : AppColors.grey100;

    return Hero(
      tag: 'doctor-avatar-$imageUrl',
      child: Container(
        width: 74.w,
        height: 74.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
          color: placeholder,
        ),
        clipBehavior: Clip.antiAlias,
        child: imageUrl != null && imageUrl!.isNotEmpty
            ? CachedNetworkImage(
                imageUrl: imageUrl!,
                fit: BoxFit.cover,
                placeholder: (_, __) => Container(color: placeholder),
                errorWidget: (_, __, ___) => Icon(
                  Icons.person_rounded,
                  color: isDark ? AppColors.grey400 : AppColors.grey400,
                  size: 38.sp,
                ),
              )
            : Icon(
                Icons.person_rounded,
                color: isDark ? AppColors.grey400 : AppColors.grey400,
                size: 38.sp,
              ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final String label;
  final Color backgroundColor;
  final Color textColor;

  const _InfoChip({
    required this.label,
    required this.backgroundColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
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
          fontSize: 12.sp,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _MetricTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color accentColor;
  final bool isDark;

  const _MetricTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.accentColor,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final surface = isDark ? AppColors.grey800 : AppColors.grey50;
    final titleColor = isDark ? AppColors.white : AppColors.black;
    final bodyColor = isDark ? AppColors.grey400 : AppColors.grey500;

    return Expanded(
      child: Container(
        padding: EdgeInsets.all(12.r),
        decoration: BoxDecoration(
          color: surface,
          borderRadius: BorderRadius.circular(18.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: accentColor, size: 18.sp),
                SizedBox(width: 6.w),
                Expanded(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w800,
                      color: titleColor,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 4.h),
            Text(
              value,
              style: TextStyle(
                fontSize: 12.sp,
                color: bodyColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AddressRow extends StatelessWidget {
  final String address;
  final bool isDark;
  final Color bodyColor;
  final Color titleColor;

  const _AddressRow({
    required this.address,
    required this.isDark,
    required this.bodyColor,
    required this.titleColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: isDark ? AppColors.grey800 : AppColors.grey50,
        borderRadius: BorderRadius.circular(18.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.location_on_rounded,
            color: AppColors.primary,
            size: 20.sp,
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Clinic location',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: bodyColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  address,
                  style: TextStyle(
                    fontSize: 14.sp,
                    height: 1.4,
                    color: titleColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
