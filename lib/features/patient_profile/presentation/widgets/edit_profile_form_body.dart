import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tabibi/core/utils/constants/app_dimensions.dart';
import 'package:tabibi/core/utils/constants/app_padding.dart';
import 'package:tabibi/core/utils/constants/app_strings.dart';
import 'package:tabibi/core/utils/enums/enums.dart';
import 'package:tabibi/core/widgets/primary_button.dart';
import 'package:tabibi/features/authentication/modules/fill_profile/presentation/cubit/upload_image_cubit.dart';
import 'package:tabibi/features/authentication/modules/fill_profile/presentation/cubit/upload_image_state.dart';
import 'package:tabibi/features/patient_profile/presentation/widgets/edit_profile_avatar.dart';
import 'package:tabibi/features/patient_profile/presentation/widgets/edit_profile_city_dropdown.dart';
import 'package:tabibi/features/patient_profile/presentation/widgets/edit_profile_date_field.dart';
import 'package:tabibi/features/patient_profile/presentation/widgets/edit_profile_dropdown.dart';
import 'package:tabibi/features/patient_profile/presentation/widgets/edit_profile_text_field.dart';

class EditProfileFormBody extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final String? selectedBirthdate;
  final String? selectedCityId;
  final int? selectedGender;
  final String? networkImageUrl;
  final File? localImageFile;
  final ValueChanged<String> onBirthdateChanged;
  final ValueChanged<String?> onCityChanged;
  final ValueChanged<int?> onGenderChanged;
  final VoidCallback onAvatarTap;
  final VoidCallback onSubmit;

  const EditProfileFormBody({
    super.key,
    required this.formKey,
    required this.nameController,
    required this.selectedBirthdate,
    required this.selectedCityId,
    required this.selectedGender,
    required this.networkImageUrl,
    required this.localImageFile,
    required this.onBirthdateChanged,
    required this.onCityChanged,
    required this.onGenderChanged,
    required this.onAvatarTap,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: AppPadding.p24),
        child: Column(
          children: [
            SizedBox(height: AppHeight.h24),

            // Avatar
            BlocBuilder<UploadImageCubit, UploadImageState>(
              builder: (context, uploadState) {
                return EditProfileAvatar(
                  networkImageUrl: networkImageUrl,
                  localImageFile: localImageFile,
                  isUploading: uploadState.status == UploadImageStatus.loading,
                  onTap: onAvatarTap,
                );
              },
            ),

            SizedBox(height: AppHeight.h32),

            // Name Field
            EditProfileTextField(
              controller: nameController,
              label: AppStrings.fullName,
              hint: AppStrings.enterFullName,
              prefixIcon: Iconsax.user,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return AppStrings.nameRequired;
                }
                return null;
              },
            ),

            SizedBox(height: AppHeight.h20),

            // Gender Dropdown
            EditProfileDropdown<int>(
              label: AppStrings.selectGender,
              hint: AppStrings.selectGender,
              value: selectedGender,
              prefixIcon: Iconsax.user_edit,
              items: const [
                DropdownMenuItem(value: 1, child: Text(AppStrings.male)),
                DropdownMenuItem(value: 2, child: Text(AppStrings.female)),
              ],
              onChanged: onGenderChanged,
            ),

            SizedBox(height: AppHeight.h20),

            // Date of Birth
            EditProfileDateField(
              label: AppStrings.dateOfBirth,
              selectedDate: selectedBirthdate,
              onDateSelected: onBirthdateChanged,
            ),

            SizedBox(height: AppHeight.h20),

            // City Dropdown
            EditProfileCityDropdown(
              selectedCityId: selectedCityId,
              onChanged: onCityChanged,
            ),

            SizedBox(height: AppHeight.h40),

            // Save Button
            PrimaryButton(title: AppStrings.saveChanges, onPress: onSubmit),

            SizedBox(height: AppHeight.h40),
          ],
        ),
      ),
    );
  }
}
