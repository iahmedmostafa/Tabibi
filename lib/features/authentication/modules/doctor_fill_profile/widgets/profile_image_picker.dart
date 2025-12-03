import 'dart:io';

import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';
import 'package:tabibi/core/utils/constants/sizes.dart';

class ProfileImagePicker extends StatelessWidget {
  final void Function()? onImageSelected;
  final File? selectedImage;
  final bool isUploaded;
  final String? imageUrl;

  const ProfileImagePicker({
    super.key,
    this.onImageSelected,
    this.selectedImage,
    this.imageUrl,
    this.isUploaded = false,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          Container(
            width: 168.33,
            height: 168.33,
            decoration: const BoxDecoration(
              color: AppColors.grey200,
              shape: BoxShape.circle,
            ),
            child: ClipOval(child: _buildImage()),
          ),

          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: onImageSelected,
              child: Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: AppColors.darkTeal,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Iconsax.edit, color: Colors.white, size: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImage() {
    if (selectedImage != null) {
      return Image.file(selectedImage!, fit: BoxFit.cover);
    } else if (imageUrl != null && imageUrl!.isNotEmpty) {
      return Image.network(imageUrl!, fit: BoxFit.cover);
    } else {
      return const Icon(
        Iconsax.user,
        size: AppSizes.imageThumbSize,
        color: AppColors.grey400,
      );
    }
  }
}
