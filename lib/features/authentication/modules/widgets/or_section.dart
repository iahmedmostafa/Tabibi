import 'package:flutter/material.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';
import 'package:tabibi/core/utils/constants/app_padding.dart';
import 'package:tabibi/core/utils/constants/app_strings.dart';
// ...existing code...

class OrSection extends StatelessWidget {
  const OrSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider(color: AppColors.grey200, thickness: 1)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppPadding.p24),
          child: Builder(
            builder: (context) {
              return Text(
                AppStrings.or,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: AppColors.grey500),
              );
            },
          ),
        ),
        const Expanded(child: Divider(color: AppColors.grey200, thickness: 1)),
      ],
    );
  }
}
