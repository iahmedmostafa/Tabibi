import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tabibi/common/widgets/primary_button.dart';
import 'package:tabibi/core/constants/app_strings.dart';
import 'package:tabibi/core/routing/app_routes.dart';
import 'package:tabibi/features/authentication/presentation/screens/login/widgets/bottom_login_section.dart';
import 'package:tabibi/features/authentication/presentation/widgets/custom_input_field.dart';
import 'package:tabibi/features/authentication/presentation/widgets/top_section.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 85),

            TopSection(title: AppStrings.welcome, supTitle: AppStrings.hope),

            SizedBox(height: 32),

            CustomInputField(
              hintText: AppStrings.email,
              icon: Icons.email_outlined,
              isPassword: false,
            ),

            SizedBox(height: 20),

            CustomInputField(
              hintText: AppStrings.password,
              icon: Icons.lock_outline,
              isPassword: true,
            ),

            SizedBox(height: 23),

            PrimaryButton(
              onPress: () {},
              height: 48,
              width: 342,
              title: AppStrings.signIn,
            ),

            SizedBox(height: 23),

            BottomLoginSection(
              onGooglePressed: () {},
              onFacebookPressed: () {},
              onForgotPassword: () {
                context.go(AppRoutes.forgotPassword);
              },
              onSignUp: () {
                context.go(AppRoutes.signUp);
              },
            ),
          ],
        ),
      ),
    );
  }
}
