import 'package:flutter/material.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';

class SoftCircle extends StatelessWidget {
  const SoftCircle({super.key, required this.size, this.opacity = 0.14});

  final double size;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.white.withOpacity(opacity),
      ),
    );
  }
}
