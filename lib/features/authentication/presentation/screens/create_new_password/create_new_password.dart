import 'package:flutter/material.dart';
import 'package:tabibi/common/widgets/primary_button.dart';
import 'package:tabibi/core/constants/app_strings.dart';
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
              SizedBox(height: 32),
              ArrowBack(nameRoute: AppRoutes.verifyCode),
              SizedBox(height: 32),
              TopSection(
                title: AppStrings.createNewPassword,
                supTitle:AppStrings.supTitleCreateNewPassword
              ),
              SizedBox(height: 32),
              CustomInputField(
                hintText: AppStrings.password,
                icon: Icons.lock_outline,
                isPassword: true,
              ),
              SizedBox(height: 20),
              CustomInputField(
                hintText: AppStrings.confirmPassword,
                icon: Icons.lock_outline,
                isPassword: true,
              ),
              SizedBox(height: 32),
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
