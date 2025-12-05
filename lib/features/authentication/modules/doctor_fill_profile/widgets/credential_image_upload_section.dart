import 'dart:io';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabibi/core/style/spacing/vertical_space.dart';
import 'package:tabibi/core/utils/enums/enums.dart';
import 'package:tabibi/core/utils/functions/select_image.dart';
import 'package:tabibi/core/utils/helper/helper_functions.dart';
import 'package:tabibi/features/authentication/modules/doctor_fill_profile/cubit/credential_upload_image_cubit.dart';
import 'package:tabibi/features/authentication/modules/doctor_fill_profile/widgets/credential_image_picker.dart';
import 'package:tabibi/features/authentication/modules/fill_profile/presentation/cubit/upload_image_state.dart';

class CredentialImageUploadSection extends StatefulWidget {
  const CredentialImageUploadSection({super.key});

  @override
  State<CredentialImageUploadSection> createState() =>
      _CredentialImageUploadSectionState();
}

class _CredentialImageUploadSectionState
    extends State<CredentialImageUploadSection> {
  bool isUploaded = false;
  File? selectedImage;

  @override
  void initState() {
    super.initState();
    final state = context.read<CredentialUploadImageCubit>().state;
    if (state.status == UploadImageStatus.success && state.imageUrl != null) {
      isUploaded = true;
      // Note: We can't easily restore the File object from the URL,
      // but we can show the uploaded state.
      // Ideally CredentialImagePicker should handle showing the URL if File is null but URL is present.
    }
  }

  void _handleImageSelection() {
    selectImage((file) {
      setState(() {
        selectedImage = file;
      });
      context.read<CredentialUploadImageCubit>().uploadImage(file);
    }, context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CredentialUploadImageCubit, UploadImageState>(
      listener: (context, state) {
        if (state.status == UploadImageStatus.loading) {
          isUploaded = false;

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Uploading credential image...'),
              duration: Duration(seconds: 1),
            ),
          );
        } else if (state.status == UploadImageStatus.success) {
          setState(() {
            isUploaded = true;
          });
          AppHelperFunctions.showAwesomeSnackBar(
            title: 'Success',
            message: 'Credential image uploaded successfully',
            contentType: ContentType.success,
            context: context,
          );
        } else if (state.status == UploadImageStatus.failure) {
          isUploaded = false;

          AppHelperFunctions.showAwesomeSnackBar(
            title: 'Error',
            message: state.errorMessage ?? 'Upload failed',
            contentType: ContentType.failure,
            context: context,
          );
        }
      },
      child: Column(
        children: [
          const VerticalSpace(height: 20),
          CredentialImagePicker(
            onImageSelected: _handleImageSelection,
            selectedImage: selectedImage,
            isUploaded: isUploaded,
            imageUrl: context.read<CredentialUploadImageCubit>().state.imageUrl,
          ),
        ],
      ),
    );
  }
}
