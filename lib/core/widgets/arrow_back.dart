import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';

class ArrowBack extends StatelessWidget {
  final String nameRoute;
  const ArrowBack({super.key, required this.nameRoute});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      children: [
        IconButton(
          onPressed: () {
            context.go(nameRoute);
          },
          icon: Icon(
            Iconsax.arrow_left_2,
            size: 24,
            color: isDark ? AppColors.white : AppColors.black,
          ),
        ),
      ],
    );
  }
}
