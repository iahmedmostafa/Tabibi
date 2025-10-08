import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tabibi/core/widgets/primary_button.dart';
import 'package:tabibi/core/utils/constants/app_images.dart';
import 'package:tabibi/core/utils/constants/app_strings.dart';
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
        const    SizedBox(height: 85),
          const  TopSection(
              title: AppStrings.createAccount,
              supTitle: AppStrings.subTitleCreateAccount,
            ),

        const    SizedBox(height: 32),
        const    CustomInputField(
              hintText: AppStrings.email,
              icon: Icons.email_outlined,
              isPassword: false,
            ),

          const  SizedBox(height: 20),
          const  CustomInputField(
              hintText: AppStrings.name,
              icon: Icons.person_outline,
              isPassword: false,
            ),

        const    SizedBox(height: 20),
          const  CustomInputField(
              hintText: AppStrings.password,
              icon: Icons.lock_outline,
              isPassword: true,
            ),

          const  SizedBox(height: 24),
            PrimaryButton(
              onPress: (){
                context.go(AppRoutes.fillProfile);
              },
              height: 48,
              width: double.infinity,
              title: AppStrings.createAccount,
            ),

          const  SizedBox(height: 24),
          const  OrSection(),

          const  SizedBox(height: 24),
            SocialButton(
              text: AppStrings.signWithGoogle,
              iconPath: AppImages.google,
              onPressed: (){},
            ),

        const    SizedBox(height: 16),
            SocialButton(
              text: AppStrings.signWithFacebook,
              iconPath: AppImages.facebook,
              onPressed: (){},
            ),

          const  SizedBox(height: 24,),
            AuthPromptText(
              text: AppStrings.haveAccount,
              gestureDetectorName: AppStrings.signIn,
              onPress: (){
                context.go(AppRoutes.login);
              },
            ),
          const  SizedBox(height: 24,)
          ],
        ),
      ),
    );
  }
}
