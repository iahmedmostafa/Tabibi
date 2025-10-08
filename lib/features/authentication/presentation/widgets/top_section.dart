import 'package:flutter/material.dart';
import 'package:tabibi/core/constants/app_images.dart';
import 'package:tabibi/core/constants/app_strings.dart';
import 'package:tabibi/core/constants/app_styles.dart';

class TopSection extends StatelessWidget {
  String title;
  String supTitle;
   TopSection({
    super.key,
    required this.title,
    required this.supTitle
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(child: Image.asset(AppImages.login)),
        SizedBox(height: 16),
        Text(AppStrings.appName, style: AppTextStyles.grey20w400),
        SizedBox(height: 32),
        Text(title, style: AppTextStyles.dark20w600),
        SizedBox(height: 8),
        Text(
          supTitle,
          style: AppTextStyles.grey20w400.copyWith(fontSize: 14),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
