import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tabibi/common/widgets/primary_button.dart';
import 'package:tabibi/core/constants/app_strings.dart';
import 'package:tabibi/core/routing/app_routes.dart';
import 'package:tabibi/features/authentication/presentation/widgets/arrow_back.dart';
import 'package:tabibi/features/authentication/presentation/widgets/custom_input_field.dart';
import 'package:tabibi/features/authentication/presentation/widgets/top_section.dart';


class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              SizedBox(height: 32),
              ArrowBack(nameRoute: AppRoutes.login,),
              SizedBox(height: 32),
              TopSection(
                title: AppStrings.forgotPassword,
                supTitle: AppStrings.supTitleForgotPassword
              ),
              SizedBox(height: 32),
              CustomInputField(
                hintText: AppStrings.email,
                icon: Icons.email_outlined,
                isPassword: false,
              ),
              SizedBox(height: 32),
              PrimaryButton(
                onPress: () {
                  context.go(AppRoutes.verifyCode);
                },
                height: 48,
                width: double.infinity,
                title: AppStrings.sendCode,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
