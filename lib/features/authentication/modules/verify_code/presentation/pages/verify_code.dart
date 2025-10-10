import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tabibi/core/routing/app_routes.dart';
import 'package:tabibi/core/style/spacing/vertical_space.dart';
import 'package:tabibi/core/utils/constants/app_dimensions.dart';
import 'package:tabibi/core/utils/constants/app_padding.dart';
import 'package:tabibi/core/utils/constants/app_strings.dart';
import 'package:tabibi/core/widgets/primary_button.dart';
import 'package:tabibi/features/authentication/modules/verify_code/presentation/widgets/pin_code.dart';
import 'package:tabibi/features/authentication/modules/widgets/arrow_back.dart';
import 'package:tabibi/features/authentication/modules/widgets/auth_prompt_text.dart';
import 'package:tabibi/features/authentication/modules/widgets/top_section.dart';

class VerifyCodeScreen extends StatelessWidget {
  const VerifyCodeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppPadding.p24),
          child: Column(
            children: [
                 VerticalSpace(height: AppHeight.h32),
               const ArrowBack(nameRoute: AppRoutes.forgotPassword),
                 VerticalSpace(height: AppHeight.h32),
              const TopSection(
                title: AppStrings.verifyCode,
                supTitle: AppStrings.supTitleVerifyCode,
              ),
                 VerticalSpace(height: AppHeight.h32),
              const PinCode(),
                 VerticalSpace(height: AppHeight.h32),
              PrimaryButton(
                onPress: () {
                  context.go(AppRoutes.createNewPassword);
                },
                height: 48,
                width: double.infinity,
                title: AppStrings.verify,
              ),
                 VerticalSpace(height: AppHeight.h24),
              AuthPromptText(
                gestureDetectorName: AppStrings.resend,
                text: AppStrings.didntGetCode,
                onPress: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
