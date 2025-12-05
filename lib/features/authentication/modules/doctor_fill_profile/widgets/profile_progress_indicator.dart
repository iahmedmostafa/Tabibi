import 'package:flutter/material.dart';
import 'package:tabibi/core/style/spacing/vertical_space.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';
import 'package:tabibi/core/utils/constants/app_dimensions.dart';

class ProfileProgressIndicator extends StatelessWidget {
  final int currentPage;
  final int totalPages;

  const ProfileProgressIndicator({
    super.key,
    required this.currentPage,
    required this.totalPages,
  });

  @override
  Widget build(BuildContext context) {
    final progress = (currentPage + 1) / totalPages;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        VerticalSpace(height: AppHeight.h12),
        Text(
          '${currentPage + 1} from $totalPages',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        VerticalSpace(height: AppHeight.h12),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: Colors.grey.shade200,
          color: AppColors.green,
          minHeight: 8,
          borderRadius: BorderRadius.circular(4),
        ),
      ],
    );
  }
}
