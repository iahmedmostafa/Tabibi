import 'package:flutter/material.dart';
import 'package:tabibi/core/style/spacing/vertical_space.dart';
import 'package:tabibi/core/utils/constants/app_dimensions.dart';
import 'package:tabibi/core/utils/constants/app_images.dart';
import 'package:tabibi/core/utils/constants/app_strings.dart';
// ...existing code...
import 'package:tabibi/features/authentication/modules/widgets/or_section.dart';
import 'package:tabibi/features/authentication/modules/widgets/social_button.dart';

class BottomLoginSection extends StatelessWidget {
  final VoidCallback onGooglePressed;
  final VoidCallback onFacebookPressed;

  const BottomLoginSection({
    super.key,
    required this.onGooglePressed,
    required this.onFacebookPressed,
    
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const OrSection(),

        VerticalSpace(height: AppHeight.h23),
        SocialButton(
          text: AppStrings.signWithGoogle,
          iconPath: AppImages.google,
          onPressed: onGooglePressed,
        ),

        VerticalSpace(height: AppHeight.h16),
        SocialButton(
          text: AppStrings.signWithFacebook,
          iconPath: AppImages.facebook,
          onPressed: onFacebookPressed,
        ),
      
      ],
    );
  }
}
