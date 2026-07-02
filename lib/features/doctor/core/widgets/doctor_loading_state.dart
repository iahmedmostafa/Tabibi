import 'package:flutter/material.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';

class DoctorLoadingState extends StatelessWidget {
  final double? strokeWidth;

  const DoctorLoadingState({super.key, this.strokeWidth});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        color: AppColors.midnightBlue,
        strokeWidth: strokeWidth ?? 2.5,
      ),
    );
  }
}
