import 'package:flutter/material.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';
import 'package:tabibi/core/utils/constants/app_images.dart';
import 'package:tabibi/core/utils/constants/app_strings.dart';
import 'package:tabibi/core/utils/constants/app_styles.dart';
import 'package:tabibi/features/authentication/presentation/widgets/auth_prompt_text.dart';
import 'package:tabibi/features/authentication/presentation/widgets/or_section.dart';
import 'package:tabibi/features/authentication/presentation/widgets/social_button.dart';

class BottomLoginSection extends StatelessWidget {
  final VoidCallback onGooglePressed;
  final VoidCallback onFacebookPressed;
  final VoidCallback onForgotPassword;
  final VoidCallback onSignUp;

  const BottomLoginSection({
    super.key,
    required this.onGooglePressed,
    required this.onFacebookPressed,
    required this.onForgotPassword,
    required this.onSignUp,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const OrSection(),

        const SizedBox(height: 23),
        SocialButton(
          text: AppStrings.signWithGoogle,
          iconPath: AppImages.google,
          onPressed: onGooglePressed,
        ),

        const SizedBox(height: 16),
        SocialButton(
          text: AppStrings.signWithFacebook,
          iconPath: AppImages.facebook,
          onPressed: onFacebookPressed,
        ),

        const SizedBox(height: 23),
        GestureDetector(
          onTap: onForgotPassword,
          child: Text(
            AppStrings.forgotPassword,
            style: AppTextStyles.grey16w500.copyWith(
              color: AppColors.blue600,
              fontSize: 14,
            ),
          ),
        ),

        const SizedBox(height: 23),
        AuthPromptText(
          text: AppStrings.dontHaveAccount,
          gestureDetectorName: AppStrings.signUp,
          onPress: onSignUp,
        ),
      ],
    );
  }
}
