import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tabibi/core/widgets/primary_button.dart';
import 'package:tabibi/core/utils/constants/app_strings.dart';
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
            const  SizedBox(height: 32),
            const  ArrowBack(nameRoute: AppRoutes.forgotPassword),
            const  SizedBox(height: 32),
            const  TopSection(
                title: AppStrings.verifyCode,
                supTitle:AppStrings.supTitleVerifyCode
              ),
          const    SizedBox(height: 32),
            const  PinCode(),
            const  SizedBox(height: 32),
              PrimaryButton(
                onPress: () {
                  context.go(AppRoutes.createNewPassword);
                },
                height: 48,
                width: double.infinity,
                title: AppStrings.verify,
              ),
            const  SizedBox(height: 24),
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
