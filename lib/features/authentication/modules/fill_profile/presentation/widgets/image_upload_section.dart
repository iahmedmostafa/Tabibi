import 'dart:io';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabibi/core/utils/enums/enums.dart';
import 'package:tabibi/core/utils/functions/select_image.dart';
import 'package:tabibi/core/utils/helper/helper_functions.dart';
import 'package:tabibi/features/authentication/modules/fill_profile/presentation/cubit/upload_image_cubit.dart';
import 'package:tabibi/features/authentication/modules/fill_profile/presentation/cubit/upload_image_state.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:tabibi/features/authentication/modules/fill_profile/presentation/widgets/profile_image_picker.dart';

class ImageUploadSection extends StatefulWidget {
  const ImageUploadSection({super.key});

  @override
  State<ImageUploadSection> createState() => _ImageUploadSectionState();
}

class _ImageUploadSectionState extends State<ImageUploadSection> {
  bool isUploaded = false;
  File? selectedImage;

  @override
  void initState() {
    super.initState();
    final state = context.read<UploadImageCubit>().state;
    if (state.status == UploadImageStatus.success && state.imageUrl != null) {
      isUploaded = true;
    }
  }

  void _handleImageSelection() {
    selectImage((file) {
      setState(() {
        selectedImage = file;
      });
      context.read<UploadImageCubit>().uploadImage(file);
    }, context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UploadImageCubit, UploadImageState>(
      listener: (context, state) {
        if (state.status == UploadImageStatus.loading) {
          isUploaded = false;

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('uploadingImage'.tr()),
              duration: const Duration(seconds: 1),
            ),
          );
        } else if (state.status == UploadImageStatus.success) {
          setState(() {
            isUploaded = true;
          });
          AppHelperFunctions.showAwesomeSnackBar(
            title: 'success'.tr(),
            message: 'imageUploadedSuccessfully'.tr(),
            contentType: ContentType.success,
            context: context,
          );
        } else if (state.status == UploadImageStatus.failure) {
          isUploaded = false;

          AppHelperFunctions.showAwesomeSnackBar(
            title: 'error'.tr(),
            message: state.errorMessage ?? 'uploadFailed'.tr(),
            contentType: ContentType.failure,
            context: context,
          );
        }
      },
      child: ProfileImagePicker(
        onImageSelected: _handleImageSelection,
        selectedImage: selectedImage,
        isUploaded: isUploaded,
        imageUrl: context.read<UploadImageCubit>().state.imageUrl,
      ),
    );
  }
}
