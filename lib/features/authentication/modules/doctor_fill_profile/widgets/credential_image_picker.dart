import 'dart:io';

import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';
import 'package:tabibi/core/utils/constants/sizes.dart';

class CredentialImagePicker extends StatelessWidget {
  final void Function()? onImageSelected;
  final File? selectedImage;
  final bool isUploaded;
  final String? imageUrl;
  final IconData? iconData;

  const CredentialImagePicker({
    super.key,
    this.onImageSelected,
    this.selectedImage,
    this.imageUrl,
    this.isUploaded = false,
    this.iconData
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          Container(
            width: 250,
            height: 168.33,
            decoration: const BoxDecoration(
              color: AppColors.grey200,
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(12)),
              child: _buildImage(),
            ),
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
      return Image.file(selectedImage!, fit: BoxFit.fill);
    } else if (imageUrl != null && imageUrl!.isNotEmpty) {
      return Image.network(imageUrl!, fit: BoxFit.fill);
    } else {
      return Icon(
        iconData?? Icons.credit_card_rounded,
        size: AppSizes.imageThumbSize,
        color: AppColors.grey400,
      );
    }
  }
}
