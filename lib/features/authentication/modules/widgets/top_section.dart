import 'package:flutter/material.dart';
import 'package:tabibi/core/style/spacing/vertical_space.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';
import 'package:tabibi/core/utils/constants/app_dimensions.dart';
import 'package:tabibi/core/utils/constants/app_images.dart';
import 'package:tabibi/core/utils/constants/app_strings.dart';

class TopSection extends StatelessWidget {
  final String title;
  final String supTitle;
  const TopSection({super.key, required this.title, required this.supTitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(child: Image.asset(AppImages.login)),
        VerticalSpace(height: AppHeight.h16),
        Text(
          AppStrings.appName,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        VerticalSpace(height: AppHeight.h32),
        Text(title, style: Theme.of(context).textTheme.headlineLarge),
        VerticalSpace(height: AppHeight.h8),
        Text(
          supTitle,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: AppColors.grey500,height: 1.5),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
