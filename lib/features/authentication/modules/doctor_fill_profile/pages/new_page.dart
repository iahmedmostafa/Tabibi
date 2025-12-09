import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tabibi/core/routing/app_routes.dart';
import 'package:tabibi/core/style/spacing/vertical_space.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';
import 'package:tabibi/core/utils/constants/app_styles.dart';
import 'package:tabibi/core/widgets/primary_button.dart';

class NewPage extends StatelessWidget {
  const NewPage({super.key});

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
                  color: Colors.orange.shade100,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Iconsax.edit,
                  size: 80,
                  color: Colors.orange.shade700,
                ),
              ),
              const VerticalSpace(height: 32),
              Text(
                'Complete Your Profile',
                style: AppTextStyle.h2.copyWith(
                  color: Colors.orange.shade700,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const VerticalSpace(height: 16),
              Text(
                'Your profile information is incomplete. Please fill in all the required details to proceed with registration.\n\nThis will help us verify your credentials and credentials properly.',
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
                  context.goNamed(AppRoutes.doctorFillProfile);
                },
                title: 'Continue Registration',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
