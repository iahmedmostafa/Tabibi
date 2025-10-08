import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tabibi/core/constants/app_colors.dart';

class ProfileImagePicker extends StatefulWidget {
  final Function(File?)? onImageSelected;
  final String? initialImageUrl;

  const ProfileImagePicker({
    super.key,
    this.onImageSelected,
    this.initialImageUrl,
  });

  @override
  State<ProfileImagePicker> createState() => _ProfileImagePickerState();
}

class _ProfileImagePickerState extends State<ProfileImagePicker> {
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
      widget.onImageSelected?.call(_selectedImage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          Container(
            width: 168.33,
            height: 168.33,
            decoration: BoxDecoration(
              color: AppColors.grey200,
              shape: BoxShape.circle,
            ),
            child: ClipOval(
              child: _selectedImage != null
                  ? Image.file(
                _selectedImage!,
                fit: BoxFit.cover,
              )
                  : widget.initialImageUrl != null
                  ? Image.network(
                widget.initialImageUrl!,
                fit: BoxFit.cover,
              )
                  : Icon(
                Icons.person,
                size: 80,
                color: AppColors.grey400,
              ),
            ),
          ),

          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: _pickImage,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.darkTeal,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.edit,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}