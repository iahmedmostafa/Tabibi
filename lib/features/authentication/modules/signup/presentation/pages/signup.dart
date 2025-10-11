import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tabibi/core/routing/app_routes.dart';
import 'package:tabibi/core/style/spacing/vertical_space.dart';
import 'package:tabibi/core/utils/constants/app_dimensions.dart';
import 'package:tabibi/core/utils/constants/app_images.dart';
import 'package:tabibi/core/utils/constants/app_padding.dart';
import 'package:tabibi/core/utils/constants/app_strings.dart';
import 'package:tabibi/core/widgets/custom_input_field.dart';
import 'package:tabibi/core/widgets/primary_button.dart';
import 'package:tabibi/features/authentication/modules/widgets/auth_prompt_text.dart';
import 'package:tabibi/features/authentication/modules/widgets/or_section.dart';
import 'package:tabibi/features/authentication/modules/widgets/social_button.dart';
import 'package:tabibi/features/authentication/modules/widgets/top_section.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppPadding.p24),
        child: Column(
          children: [
            VerticalSpace(height: AppHeight.h85),
            const TopSection(
              title: AppStrings.createAccount,
              supTitle: AppStrings.subTitleCreateAccount,
            ),

            VerticalSpace(height: AppHeight.h32),
            const CustomInputField(
              hintText: AppStrings.email,
              icon: Iconsax.sms,
              isPassword: false,
            ),

            VerticalSpace(height: AppHeight.h20),
            const CustomInputField(
              hintText: AppStrings.name,
              icon: Iconsax.user,
              isPassword: false,
            ),

            VerticalSpace(height: AppHeight.h20),
            const CustomInputField(
              hintText: AppStrings.password,
              icon: Iconsax.password_check,
              isPassword: true,
            ),

            VerticalSpace(height: AppHeight.h24),
            PrimaryButton(
              onPress: () {
                context.go(AppRoutes.fillProfile);
              },

              title: AppStrings.createAccount,
            ),

            VerticalSpace(height: AppHeight.h24),
            const OrSection(),

            const VerticalSpace(height: 24),
            SocialButton(
              text: AppStrings.signWithGoogle,
              iconPath: AppImages.google,
              onPressed: () {},
            ),

            VerticalSpace(height: AppHeight.h16),
            SocialButton(
              text: AppStrings.signWithFacebook,
              iconPath: AppImages.facebook,
              onPressed: () {},
            ),

            VerticalSpace(height: AppHeight.h24),
            AuthPromptText(
              text: AppStrings.haveAccount,
              gestureDetectorName: AppStrings.signIn,
              onPress: () {
                context.go(AppRoutes.login);
              },
            ),
            VerticalSpace(height: AppHeight.h24),
          ],
        ),
      ),
    );
  }
}
