import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tabibi/core/routing/app_routes.dart';
import 'package:tabibi/core/style/spacing/vertical_space.dart';
import 'package:tabibi/core/utils/constants/app_dimensions.dart';
import 'package:tabibi/core/utils/constants/app_padding.dart';
import 'package:tabibi/core/utils/constants/app_strings.dart';
import 'package:tabibi/core/widgets/custom_input_field.dart';
import 'package:tabibi/core/widgets/primary_button.dart';
import 'package:tabibi/features/authentication/modules/widgets/arrow_back.dart';
import 'package:tabibi/features/authentication/modules/widgets/top_section.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppPadding.p24),
          child: Column(
            children: [
              VerticalSpace(height: AppHeight.h32),
              const ArrowBack(nameRoute: AppRoutes.login),
              VerticalSpace(height: AppHeight.h32),
              const TopSection(
                title: AppStrings.forgotPassword,
                supTitle: AppStrings.supTitleForgotPassword,
              ),
              VerticalSpace(height: AppHeight.h32),
              const CustomInputField(
                hintText: AppStrings.email,
                icon: Icons.email_outlined,
                isPassword: false,
              ),
              VerticalSpace(height: AppHeight.h32),
              PrimaryButton(
                onPress: () {
                  context.go(AppRoutes.verifyCode);
                },
              
                title: AppStrings.sendCode,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
