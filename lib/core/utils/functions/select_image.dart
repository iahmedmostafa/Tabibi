import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';

Future<void> selectImage(
  Function(File) onImagePicked,
  BuildContext context,
) async {
  final sheetContext = context;

  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      final isDark = Theme.of(context).brightness == Brightness.dark;
      final surfaceColor = isDark ? AppColors.grey900 : AppColors.white;
      final borderColor = isDark ? AppColors.grey700 : AppColors.grey200;
      final titleColor = isDark ? AppColors.white : AppColors.black;
      final subtitleColor = isDark ? AppColors.grey400 : AppColors.grey500;

      return Padding(
        padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 16.h),
        child: Material(
          color: surfaceColor,
          elevation: 18,
          shadowColor: Colors.black26,
          borderRadius: BorderRadius.circular(28.r),
          child: SafeArea(
            top: false,
            child: Padding(
              padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 20.h),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 44.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.grey700 : AppColors.grey300,
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Choose photo source',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: titleColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Pick a new profile photo from your gallery or camera.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: subtitleColor,
                        height: 1.35,
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  _ImageSourceTile(
                    icon: Iconsax.gallery,
                    title: 'Photo Gallery',
                    subtitle: 'Choose from existing photos',
                    backgroundColor: isDark
                        ? AppColors.grey800
                        : AppColors.grey100,
                    borderColor: borderColor,
                    iconColor: AppColors.primary,
                    onTap: () async {
                      final file = await pickImageAtGallery();
                      if (file != null) {
                        onImagePicked(file);
                        if (Navigator.of(sheetContext).canPop()) {
                          Navigator.of(sheetContext).pop();
                        }
                      }
                    },
                  ),
                  SizedBox(height: 12.h),
                  _ImageSourceTile(
                    icon: Iconsax.camera,
                    title: 'Camera',
                    subtitle: 'Take a new profile picture',
                    backgroundColor: AppColors.primary.withOpacity(0.08),
                    borderColor: AppColors.primary.withOpacity(0.18),
                    iconColor: AppColors.primary,
                    onTap: () async {
                      final file = await pickImageAtCamera();
                      if (file != null) {
                        onImagePicked(file);
                        if (Navigator.of(sheetContext).canPop()) {
                          Navigator.of(sheetContext).pop();
                        }
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}

Future<File?> pickImageAtCamera() async {
  try {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);
    return image != null ? File(image.path) : null;
  } catch (e) {
    log('Error picking image: $e');
  }
  return null;
}

Future<File?> pickImageAtGallery() async {
  try {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    return image != null ? File(image.path) : null;
  } catch (e) {
    log('Error picking image: $e');
  }
  return null;
}

class _ImageSourceTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color backgroundColor;
  final Color borderColor;
  final Color iconColor;
  final VoidCallback onTap;

  const _ImageSourceTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.backgroundColor,
    required this.borderColor,
    required this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).brightness == Brightness.dark
        ? AppColors.white
        : AppColors.black;

    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(20.r),
      child: InkWell(
        borderRadius: BorderRadius.circular(20.r),
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(color: borderColor),
          ),
          child: Row(
            children: [
              Container(
                width: 44.r,
                height: 44.r,
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: iconColor, size: 22.sp),
              ),
              SizedBox(width: 14.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: textColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? AppColors.grey400
                            : AppColors.grey500,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 14.sp,
                color: Theme.of(context).brightness == Brightness.dark
                    ? AppColors.grey500
                    : AppColors.grey400,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
