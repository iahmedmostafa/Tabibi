import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';
import 'package:tabibi/core/utils/constants/app_strings.dart';

class EditProfileAvatar extends StatelessWidget {
  final String? networkImageUrl;
  final File? localImageFile;
  final bool isUploading;
  final VoidCallback onTap;

  const EditProfileAvatar({
    super.key,
    this.networkImageUrl,
    this.localImageFile,
    required this.isUploading,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        GestureDetector(
          onTap: isUploading ? null : onTap,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 110.r,
                height: 110.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isDark ? AppColors.grey800 : AppColors.grey200,
                  border: Border.all(
                    color: AppColors.primary.withOpacity(0.3),
                    width: 3,
                  ),
                ),
                child: ClipOval(child: _buildImageContent()),
              ),
              if (isUploading)
                Container(
                  width: 110.r,
                  height: 110.r,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black45,
                  ),
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  ),
                ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 34.r,
                  height: 34.r,
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Iconsax.camera, color: Colors.white, size: 16.sp),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          AppStrings.changePhoto,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildImageContent() {
    if (localImageFile != null) {
      return Image.file(localImageFile!, fit: BoxFit.cover);
    } else if (networkImageUrl != null && networkImageUrl!.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: networkImageUrl!,
        fit: BoxFit.cover,
        placeholder: (context, url) =>
            const Center(child: CircularProgressIndicator(strokeWidth: 2)),
        errorWidget: (context, url, error) =>
            const Icon(Iconsax.user, color: AppColors.grey400, size: 50),
      );
    } else {
      return const Icon(Iconsax.user, color: AppColors.grey400, size: 50);
    }
  }
}
