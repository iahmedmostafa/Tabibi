import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tabibi/core/routing/app_routes.dart';
import 'package:tabibi/core/style/spacing/vertical_space.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';
import 'package:tabibi/core/utils/constants/app_styles.dart';
import 'package:tabibi/core/widgets/primary_button.dart';

class PendingPage extends StatelessWidget {
  const PendingPage({super.key});

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
                  color: AppColors.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Iconsax.timer_1,
                  size: 80,
                  color: AppColors.primary,
                ),
              ),
              const VerticalSpace(height: 32),
              Text(
                'Account Under Review',
                style: AppTextStyle.h2.copyWith(
                  color: AppColors.primary,
                  fontSize: 24,
                ),
                textAlign: TextAlign.center,
              ),
              const VerticalSpace(height: 16),
              Text(
                'Your profile is currently being reviewed by our admin team. This process usually takes 24-48 hours.\n\nYou will be notified once your account is approved.',
                style: AppTextStyle.bodySRegular.copyWith(
                  color: AppColors.textGrey,
                  height: 1.5,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const VerticalSpace(height: 48),
              PrimaryButton(
                title: 'Back to Login',
                onPress: () {
                  context.goNamed(AppRoutes.login);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
