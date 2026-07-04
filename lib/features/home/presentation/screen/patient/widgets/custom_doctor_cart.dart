import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibi/core/style/spacing/horizental_space.dart';
import 'package:tabibi/core/style/spacing/vertical_space.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';
import 'package:tabibi/core/widgets/premium_animated_button.dart';
import 'package:tabibi/features/home/data/models/doctor_model.dart';
import 'package:easy_localization/easy_localization.dart';

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

  static Widget _heroFlightShuttleBuilder(
    BuildContext flightContext,
    Animation<double> animation,
    HeroFlightDirection direction,
    BuildContext fromHeroContext,
    BuildContext toHeroContext,
  ) {
    final fromHero = fromHeroContext.widget as Hero;
    final toHero = toHeroContext.widget as Hero;
    final child = direction == HeroFlightDirection.push
        ? toHero.child
        : fromHero.child;
    final curve = CurvedAnimation(
      parent: animation,
      curve: Curves.easeInOutCubic,
    );

    return FadeTransition(
      opacity: curve,
      child: ScaleTransition(
        scale: Tween<double>(begin: 0.96, end: 1).animate(curve),
        child: Material(color: Colors.transparent, child: child),
      ),
    );
  }

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
    final bodyColor = isDark ? AppColors.grey400 : AppColors.grey500;
    final subtleSurface = isDark ? AppColors.grey800 : AppColors.paleBlueLight;
    final imagePlaceholder = isDark ? AppColors.grey800 : AppColors.grey100;
    final imageIconColor = isDark ? AppColors.grey400 : AppColors.grey400;

    return Container(
      decoration: BoxDecoration(
        color: cardSurface,
        borderRadius: BorderRadius.circular(28.r),
        border: Border.all(color: cardBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.28 : 0.08),
            blurRadius: isDark ? 18 : 10,
            offset: const Offset(0, 4),
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
                Hero(
                  tag: heroTag,
                  flightShuttleBuilder: _heroFlightShuttleBuilder,
                  child: ClipRRect(
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
                                      Container(color: imagePlaceholder),
                                  errorWidget: (context, url, error) =>
                                      Container(
                                        color: imagePlaceholder,
                                        child: Icon(
                                          Icons.person,
                                          color: imageIconColor,
                                          size: 44,
                                        ),
                                      ),
                                )
                              : Container(
                                  color: imagePlaceholder,
                                  child: Icon(
                                    Icons.person,
                                    color: imageIconColor,
                                    size: 44,
                                  ),
                                ),
                        ),
                      ],
                    ),
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
                      color: isDark
                          ? AppColors.actionGreenLight
                          : AppColors.successLight,
                      borderRadius: BorderRadius.circular(999.r),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.star_rounded,
                          color: AppColors.actionGreen,
                          size: 16.sp,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          rating > 0
                              ? rating.toStringAsFixed(1)
                              : 'newLabel'.tr(),
                          style: TextStyle(
                            color: isDark
                                ? AppColors.grey100
                                : AppColors.successDark,
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
                        color: isDark
                            ? AppColors.grey800
                            : AppColors.white.withOpacity(0.92),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite
                            ? AppColors.error
                            : (isDark ? AppColors.grey300 : AppColors.grey500),
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
                    color: titleColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                VerticalSpace(height: 6.h),
                _InfoPill(
                  label: doctor.department ?? 'generalMedicine'.tr(),
                  backgroundColor: subtleSurface,
                  textColor: isDark ? AppColors.grey200 : AppColors.primary,
                ),
                VerticalSpace(height: 10.h),
                Row(
                  children: [
                    Icon(
                      Icons.location_on_rounded,
                      size: 15.sp,
                      color: bodyColor,
                    ),
                    const HorizentalSpace(width: 4),
                    Expanded(
                      child: Text(
                        doctor.address ?? 'clinicAddressNotAvailable'.tr(),
                        style: TextStyle(fontSize: 12.sp, color: bodyColor),
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
                      rating > 0 ? rating.toStringAsFixed(1) : 'newLabel'.tr(),
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w800,
                        color: titleColor,
                      ),
                    ),
                    const HorizentalSpace(width: 8),
                    Container(
                      height: 12,
                      width: 1,
                      color: isDark ? AppColors.grey800 : AppColors.grey300,
                    ),
                    const HorizentalSpace(width: 8),
                    Text(
                      "$reviewCount ${'reviews'.tr()}",
                      style: TextStyle(fontSize: 12.sp, color: bodyColor),
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
                          color: isDark ? AppColors.grey100 : AppColors.primary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    PremiumAnimatedButton(
                      text: 'bookNow'.tr(),
                      icon: Icons.calendar_today_rounded,
                      onTap: onBookTap ?? () {},
                    ),
                  ],
                ),
                VerticalSpace(height: 2.h),
                Text(
                  'yearsExperience'.tr(
                    namedArgs: {'years': doctor.yearsOfExperience.toString()},
                  ),
                  style: TextStyle(fontSize: 11.sp, color: bodyColor),
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
