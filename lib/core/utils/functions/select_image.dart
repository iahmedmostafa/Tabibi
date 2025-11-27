import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';
import 'package:tabibi/core/widgets/primary_button.dart';

Future<void> selectImage(
  Function(File) onImagePicked,
  BuildContext context,
) async {
  showBottomSheet(
    context: context,

    builder: (context) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(
            width: double.infinity,
            height: 56.h,
            child: PrimaryButton(
              title: "Photo Gallery",
              onPress: () async {
                File? file = await pickImageAtGallery();
                if (file != null) {
                  onImagePicked(file);
                  Navigator.pop(context);
                }
              },
            ),
          ),
          const Divider(
            color: AppColors.grey,
            indent: 10,
            height: 1,
            thickness: 1,
            endIndent: 10,
          ),
          SizedBox(
            width: double.infinity,
            height: 56.h,
            child: PrimaryButton(
              title: "Camera",
              onPress: () async {
                File? file = await pickImageAtCamera();
                if (file != null) {
                  onImagePicked(file);
                  Navigator.pop(context);
                }
              },
            ),
          ),
        ],
      );
    },
    backgroundColor: Colors.transparent,
  );
}

Future<File?> pickImageAtCamera() async {
  try {
    final ImagePicker picker = ImagePicker();
    XFile? image = await picker.pickImage(source: ImageSource.camera);
    return image != null ? File(image.path) : null;
  } catch (e) {
    log('Error picking image: $e');
  }
  return null;
}

Future<File?> pickImageAtGallery() async {
  try {
    final ImagePicker picker = ImagePicker();
    XFile? image = await picker.pickImage(source: ImageSource.gallery);
    return image != null ? File(image.path) : null;
  } catch (e) {
    log('Error picking image: $e');
  }
  return null;
}
