import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tabibi/common/widgets/primary_button.dart';
import 'package:tabibi/core/constants/app_strings.dart';
import 'package:tabibi/core/routing/app_routes.dart';
import 'package:tabibi/features/authentication/presentation/screens/verify_code/widgets/pin_code.dart';
import 'package:tabibi/features/authentication/presentation/widgets/arrow_back.dart';
import 'package:tabibi/features/authentication/presentation/widgets/auth_prompt_text.dart';
import 'package:tabibi/features/authentication/presentation/widgets/top_section.dart';

class VerifyCodeScreen extends StatelessWidget {
  const VerifyCodeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              SizedBox(height: 32),
              ArrowBack(nameRoute: AppRoutes.forgotPassword),
              SizedBox(height: 32),
              TopSection(
                title: AppStrings.verifyCode,
                supTitle:AppStrings.supTitleVerifyCode
              ),
              SizedBox(height: 32),
              PinCode(),
              SizedBox(height: 32),
              PrimaryButton(
                onPress: () {
                  context.go(AppRoutes.createNewPassword);
                },
                height: 48,
                width: double.infinity,
                title: AppStrings.verify,
              ),
              SizedBox(height: 24),
              AuthPromptText(
                gestureDetectorName:AppStrings.resend ,
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
