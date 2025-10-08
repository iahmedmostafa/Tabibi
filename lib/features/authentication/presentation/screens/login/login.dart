import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tabibi/core/widgets/primary_button.dart';
import 'package:tabibi/core/utils/constants/app_strings.dart';
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
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
          const  SizedBox(height: 85),

          const  TopSection(title: AppStrings.welcome, supTitle: AppStrings.hope),

          const  SizedBox(height: 32),

          const  CustomInputField(
              hintText: AppStrings.email,
              icon: Icons.email_outlined,
              isPassword: false,
            ),

          const  SizedBox(height: 20),

        const    CustomInputField(
              hintText: AppStrings.password,
              icon: Icons.lock_outline,
              isPassword: true,
            ),

          const  SizedBox(height: 23),

            PrimaryButton(
              onPress: () {},
              height: 48,
              width: 342,
              title: AppStrings.signIn,
            ),

          const  SizedBox(height: 23),

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
