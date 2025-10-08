import 'package:flutter/material.dart';
import 'package:tabibi/core/widgets/primary_button.dart';
import 'package:tabibi/core/utils/constants/app_strings.dart';
import 'package:tabibi/core/routing/app_routes.dart';
import 'package:tabibi/features/authentication/presentation/widgets/arrow_back.dart';
import 'package:tabibi/features/authentication/presentation/widgets/custom_input_field.dart';
import 'package:tabibi/features/authentication/presentation/widgets/top_section.dart';

class CreateNewPassword extends StatelessWidget {
  const CreateNewPassword({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              const SizedBox(height: 32),
              const ArrowBack(nameRoute: AppRoutes.verifyCode),
              const SizedBox(height: 32),
              const TopSection(
                title: AppStrings.createNewPassword,
                supTitle:AppStrings.supTitleCreateNewPassword
              ),
              const SizedBox(height: 32),
              const CustomInputField(
                hintText: AppStrings.password,
                icon: Icons.lock_outline,
                isPassword: true,
              ),
              const SizedBox(height: 20),
              const CustomInputField(
                hintText: AppStrings.confirmPassword,
                icon: Icons.lock_outline,
                isPassword: true,
              ),
              const SizedBox(height: 32),
              PrimaryButton(
                onPress: () {},
                height: 48,
                width: double.infinity,
                title: AppStrings.resetPassword,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
