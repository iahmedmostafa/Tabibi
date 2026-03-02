import 'package:flutter/material.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';

class FavoritesEmptyState extends StatelessWidget {
  const FavoritesEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.favorite_border, size: 72, color: AppColors.grey300),
          const SizedBox(height: 16),
          Text(
            'No favorites yet.',
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(color: AppColors.grey500),
          ),
        ],
      ),
    );
  }
}
