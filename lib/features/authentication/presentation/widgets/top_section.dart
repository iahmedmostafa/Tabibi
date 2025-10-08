import 'package:flutter/material.dart';
import 'package:tabibi/core/utils/constants/app_images.dart';
import 'package:tabibi/core/utils/constants/app_strings.dart';
import 'package:tabibi/core/utils/constants/app_styles.dart';

class TopSection extends StatelessWidget {
  final String title;
  final String supTitle;
   const TopSection({
    super.key,
    required this.title,
    required this.supTitle
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(child: Image.asset(AppImages.login)),
        const SizedBox(height: 16),
        const Text(AppStrings.appName, style: AppTextStyles.grey20w400),
        const SizedBox(height: 32),
        Text(title, style: AppTextStyles.dark20w600),
        const SizedBox(height: 8),
        Text(
          supTitle,
          style: AppTextStyles.grey20w400.copyWith(fontSize: 14),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
