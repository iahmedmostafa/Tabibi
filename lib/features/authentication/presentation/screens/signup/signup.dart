import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tabibi/common/widgets/primary_button.dart';
import 'package:tabibi/core/constants/app_images.dart';
import 'package:tabibi/core/constants/app_strings.dart';
import 'package:tabibi/core/routing/app_routes.dart';
import 'package:tabibi/features/authentication/presentation/widgets/auth_prompt_text.dart';
import 'package:tabibi/features/authentication/presentation/widgets/custom_input_field.dart';
import 'package:tabibi/features/authentication/presentation/widgets/or_section.dart';
import 'package:tabibi/features/authentication/presentation/widgets/social_button.dart';
import 'package:tabibi/features/authentication/presentation/widgets/top_section.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          children: [
            SizedBox(height: 85),
            TopSection(
              title: AppStrings.createAccount,
              supTitle: AppStrings.subTitleCreateAccount,
            ),

            SizedBox(height: 32),
            CustomInputField(
              hintText: AppStrings.email,
              icon: Icons.email_outlined,
              isPassword: false,
            ),

            SizedBox(height: 20),
            CustomInputField(
              hintText: AppStrings.name,
              icon: Icons.person_outline,
              isPassword: false,
            ),

            SizedBox(height: 20),
            CustomInputField(
              hintText: AppStrings.password,
              icon: Icons.lock_outline,
              isPassword: true,
            ),

            SizedBox(height: 24),
            PrimaryButton(
              onPress: (){
                context.go(AppRoutes.fillProfile);
              },
              height: 48,
              width: double.infinity,
              title: AppStrings.createAccount,
            ),

            SizedBox(height: 24),
            OrSection(),

            SizedBox(height: 24),
            SocialButton(
              text: AppStrings.signWithGoogle,
              iconPath: AppImages.google,
              onPressed: (){},
            ),

            SizedBox(height: 16),
            SocialButton(
              text: AppStrings.signWithFacebook,
              iconPath: AppImages.facebook,
              onPressed: (){},
            ),

            SizedBox(height: 24,),
            AuthPromptText(
              text: AppStrings.haveAccount,
              gestureDetectorName: AppStrings.signIn,
              onPress: (){
                context.go(AppRoutes.login);
              },
            ),
            SizedBox(height: 24,)
          ],
        ),
      ),
    );
  }
}
