import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tabibi/core/routing/app_routes.dart';
import 'package:tabibi/core/style/spacing/vertical_space.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';
import 'package:tabibi/core/utils/constants/app_styles.dart';
import 'package:tabibi/core/widgets/primary_button.dart';

class ApprovedPage extends StatelessWidget {
  const ApprovedPage({super.key});

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
                  color: Colors.green.shade100,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Iconsax.verify,
                  size: 80,
                  color: Colors.green.shade700,
                ),
              ),
              const VerticalSpace(height: 32),
              Text(
                '🎉 Congratulations!',
                style: AppTextStyle.h2.copyWith(
                  color: Colors.green.shade700,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const VerticalSpace(height: 16),
              Text(
                'Your profile has been approved!\n\nYou can now start connecting with patients and providing your medical expertise through our platform.',
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
                  context.goNamed(AppRoutes.home);
                },
                title: 'Go to Home',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
