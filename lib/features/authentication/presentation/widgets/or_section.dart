import 'package:flutter/material.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';
import 'package:tabibi/core/utils/constants/app_strings.dart';
import 'package:tabibi/core/utils/constants/app_styles.dart';

class OrSection extends StatelessWidget {
  const OrSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider(color: AppColors.grey200, thickness: 1)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Text(
            AppStrings.or,
            style: AppTextStyles.grey16w500.copyWith(color: AppColors.grey500),
          ),
        ),
        const Expanded(child: Divider(color: AppColors.grey200, thickness: 1)),
      ],
    );
  }
}
