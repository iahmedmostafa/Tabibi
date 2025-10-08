import 'package:flutter/material.dart';
import 'package:tabibi/core/widgets/primary_button.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';
import 'package:tabibi/core/utils/constants/app_strings.dart';
import 'package:tabibi/core/utils/constants/app_styles.dart';
import 'package:tabibi/core/routing/app_routes.dart';
import 'package:tabibi/features/authentication/presentation/screens/fill_profile/widgets/profile_image_picker.dart';
import 'package:tabibi/features/authentication/presentation/widgets/arrow_back.dart';
import 'package:tabibi/features/authentication/presentation/widgets/custom_input_field.dart';

class FillProfile extends StatelessWidget {
  const FillProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              const SizedBox(height: 32),
              Row(
                children: [
                  const ArrowBack(nameRoute: AppRoutes.signUp),
                  const SizedBox(width: 14),
                  Text(
                    "Fill Your Profile",
                    style: AppTextStyles.dark20w600.copyWith(
                      color: AppColors.grey700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              ProfileImagePicker(
                onImageSelected: (file) {
                  if (file != null) {
                    print('${file.path}');
                  }
                },
              ),
              const SizedBox(height: 24),
              const CustomInputField(hintText: AppStrings.nameFillProfile, isPassword: false),

              const SizedBox(height: 20),
              const CustomInputField(hintText: AppStrings.nickNameFillProfile, isPassword: false),

              const SizedBox(height: 20),
              const CustomInputField(hintText: AppStrings.emailFillProfile, isPassword: false),

              const SizedBox(height: 20),
              const CustomInputField(
                hintText: AppStrings.dateFillProfile,
                icon: Icons.date_range_outlined,
                isPassword: false,
              ),
              const SizedBox(height: 20),
              const CustomInputField(
                suffixIcon: Icons.keyboard_arrow_down,
                hintText: AppStrings.genderFillProfile,
                isPassword: false,
              ),
              const SizedBox(height: 32),
              PrimaryButton(
                onPress: () {},
                height: 48,
                width: double.infinity,
                title: AppStrings.saveFillProfile,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
