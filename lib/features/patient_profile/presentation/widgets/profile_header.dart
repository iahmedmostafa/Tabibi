import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibi/core/utils/constants/app_dimensions.dart';
import 'package:tabibi/core/utils/constants/app_images.dart';
import 'package:tabibi/features/patient_profile/domain/entities/patient_profile.dart';

class ProfileHeader extends StatelessWidget {
  final PatientProfile? profile;

  const ProfileHeader({super.key, this.profile});

  @override
  Widget build(BuildContext context) {
    final avatarUrl = profile?.avatarUrl;
    final hasImage = avatarUrl != null && avatarUrl.isNotEmpty;

    return Column(
      children: [
        GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (_) => GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  color: Colors.transparent,
                  child: Center(
                    child: GestureDetector(
                      onTap: () {}, 
                      child: Container(
                        width: 300.r,
                        height: 300.r,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(context).scaffoldBackgroundColor,
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
              color: Theme.of(context).highlightColor, 
              shape: BoxShape.circle,
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
        SizedBox(height: AppHeight.h16),
        Text(
          profile?.name ?? "User",
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ],
    );
  }
}
