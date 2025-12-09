import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tabibi/core/routing/app_routes.dart';
import 'package:tabibi/core/style/spacing/vertical_space.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';
import 'package:tabibi/core/utils/constants/app_styles.dart';
import 'package:tabibi/core/widgets/primary_button.dart';

class RejectedPage extends StatelessWidget {
  const RejectedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.red.shade100,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Iconsax.close_circle,
                  size: 80,
                  color: Colors.red.shade700,
                ),
              ),
              const VerticalSpace(height: 32),
              Text(
                'Application Rejected',
                style: AppTextStyle.h2.copyWith(
                  color: Colors.red.shade700,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const VerticalSpace(height: 16),
              Text(
                'Unfortunately, your application was not approved at this time.\n\nPlease review your information and credentials, then try registering again with updated information.',
                style: AppTextStyle.bodySRegular.copyWith(
                  color: AppColors.textGrey,
                  height: 1.6,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const VerticalSpace(height: 40),
              PrimaryButton(
                onPress: () {
                  context.goNamed(AppRoutes.signUp);
                },
                title: 'Re-register',
              ),
              const VerticalSpace(height: 12),
              TextButton(
                onPressed: () {
                  context.goNamed(AppRoutes.login);
                },
                child: Text(
                  'Go to Login',
                  style: AppTextStyle.bodySRegular.copyWith(
                    color: AppColors.primary,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
