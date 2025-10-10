import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tabibi/core/routing/app_routes.dart';
import 'package:tabibi/core/style/spacing/vertical_space.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';
import 'package:tabibi/core/utils/constants/app_dimensions.dart';
import 'package:tabibi/core/utils/constants/app_padding.dart';
import 'package:tabibi/core/utils/constants/app_strings.dart';
import 'package:tabibi/core/widgets/custom_input_field.dart';
import 'package:tabibi/core/widgets/primary_button.dart';
import 'package:tabibi/features/authentication/modules/login/presentation/widgets/bottom_login_section.dart';
import 'package:tabibi/features/authentication/modules/widgets/auth_prompt_text.dart';
import 'package:tabibi/features/authentication/modules/widgets/top_section.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppPadding.p24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            VerticalSpace(height: AppHeight.h85),

            const TopSection(
              title: AppStrings.welcome,
              supTitle: AppStrings.hope,
            ),

            VerticalSpace(height: AppHeight.h32),

            const CustomInputField(
              hintText: AppStrings.email,
              icon: Icons.email_outlined,
              isPassword: false,
            ),

            VerticalSpace(height: AppHeight.h20),

            const CustomInputField(
              hintText: AppStrings.password,
              icon: Icons.lock_outline,
              isPassword: true,
            ),

            VerticalSpace(height: AppHeight.h23),

            PrimaryButton(
              onPress: () {},
            
              title: AppStrings.signIn,
            ),

            VerticalSpace(height: AppHeight.h23),

            BottomLoginSection(
              onGooglePressed: () {},
              onFacebookPressed: () {},
            ),
            VerticalSpace(height: AppHeight.h23),
            GestureDetector(
              onTap: () {
                context.go(AppRoutes.forgotPassword);
              },
              child: Text(
                AppStrings.forgotPassword,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: AppColors.blue600),
              ),
            ),

            VerticalSpace(height: AppHeight.h23),
            AuthPromptText(
              text: AppStrings.dontHaveAccount,
              gestureDetectorName: AppStrings.signUp,
              onPress: () {
                context.go(AppRoutes.signUp);
              },
            ),
          ],
        ),
      ),
    );
  }
}
