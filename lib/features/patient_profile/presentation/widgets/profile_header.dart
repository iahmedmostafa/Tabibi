import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';
import 'package:tabibi/core/utils/constants/app_images.dart';
import 'package:tabibi/features/patient_profile/domain/entities/patient_profile.dart';

class ProfileHeader extends StatelessWidget {
  final PatientProfile? profile;

  const ProfileHeader({super.key, this.profile});

  @override
  Widget build(BuildContext context) {
    final avatarUrl = profile?.avatarUrl;
    final hasImage = avatarUrl != null && avatarUrl.isNotEmpty;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (_) => GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  color: Colors.black.withValues(alpha: 0.6),
                  child: Center(
                    child: GestureDetector(
                      onTap: () {},
                      child: Container(
                        width: 280.r,
                        height: 280.r,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 4.w),
                          image: DecorationImage(
                            image: hasImage
                                ? CachedNetworkImageProvider(avatarUrl)
                                : const AssetImage(AppImages.carouselImage)
                                      as ImageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
          child: Container(
            width: 120.r,
            height: 120.r,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.15),
                width: 6.r,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  blurRadius: 16,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: ClipOval(
              child: hasImage
                  ? CachedNetworkImage(
                      imageUrl: avatarUrl,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: AppColors.paleBlueLight,
                        child: const Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                      errorWidget: (context, url, error) => Image.asset(
                        AppImages.carouselImage,
                        fit: BoxFit.cover,
                      ),
                    )
                  : Image.asset(
                      AppImages.carouselImage,
                      fit: BoxFit.cover,
                    ),
            ),
          ),
        ),
        SizedBox(height: 16.h),
        Text(
          profile?.name ?? "User",
          style: TextStyle(
            fontSize: 22.sp,
            fontWeight: FontWeight.w800,
            color: isDark ? Colors.white : AppColors.black,
          ),
        ),
        if (profile?.city?.name.isNotEmpty == true) ...[
          SizedBox(height: 6.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Iconsax.location,
                size: 14.sp,
                color: AppColors.grey500,
              ),
              SizedBox(width: 4.w),
              Text(
                profile!.city!.name,
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.grey500,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
