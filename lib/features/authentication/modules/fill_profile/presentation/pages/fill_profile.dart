import 'package:flutter/material.dart';
import 'package:tabibi/core/routing/app_routes.dart';
import 'package:tabibi/core/style/spacing/horizental_space.dart';
import 'package:tabibi/core/style/spacing/vertical_space.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';
import 'package:tabibi/core/utils/constants/app_dimensions.dart';
import 'package:tabibi/core/utils/constants/app_padding.dart';
import 'package:tabibi/core/utils/constants/app_strings.dart';
import 'package:tabibi/core/widgets/custom_input_field.dart';
// ...existing code...
import 'package:tabibi/core/widgets/primary_button.dart';
import 'package:tabibi/features/authentication/modules/fill_profile/presentation/widgets/profile_image_picker.dart';
import 'package:tabibi/features/authentication/modules/widgets/arrow_back.dart';

class FillProfile extends StatelessWidget {
  const FillProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppPadding.p24),
          child: Column(
            children: [
              VerticalSpace(height: AppHeight.h32),
              Row(
                children: [
                  const ArrowBack(nameRoute: AppRoutes.signUp),
                  HorizentalSpace(width: AppWidth.w14),
                  Text(
                    "Fill Your Profile",
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: AppColors.grey700,
                    ),
                  ),
                ],
              ),
              VerticalSpace(height: AppHeight.h32),
              ProfileImagePicker(
                onImageSelected: (file) {
                  if (file != null) {
                    print(file.path);
                  }
                },
              ),
              VerticalSpace(height: AppHeight.h24),
              const CustomInputField(
                hintText: AppStrings.nameFillProfile,
                isPassword: false,
              ),

              VerticalSpace(height: AppHeight.h20),
              const CustomInputField(
                hintText: AppStrings.nickNameFillProfile,
                isPassword: false,
              ),

              VerticalSpace(height: AppHeight.h20),
              const CustomInputField(
                hintText: AppStrings.emailFillProfile,
                isPassword: false,
              ),

              VerticalSpace(height: AppHeight.h20),
              const CustomInputField(
                hintText: AppStrings.dateFillProfile,
                icon: Icons.date_range_outlined,
                isPassword: false,
              ),
              VerticalSpace(height: AppHeight.h20),
              const CustomInputField(
                suffixIcon: Icons.keyboard_arrow_down,
                hintText: AppStrings.genderFillProfile,
                isPassword: false,
              ),
              VerticalSpace(height: AppHeight.h32),
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
