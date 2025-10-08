import 'package:flutter/material.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';
import 'package:tabibi/core/utils/constants/app_styles.dart';

class AuthPromptText extends StatelessWidget {
  final String gestureDetectorName;
  final String text;
  final VoidCallback onPress;
  const AuthPromptText({
    super.key,
    required this.gestureDetectorName,
    required this.text,
    required this.onPress
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(text, style: AppTextStyles.grey14w400),
        GestureDetector(
          onTap: onPress,
          child: Text(
            gestureDetectorName,
            style: AppTextStyles.grey14w400.copyWith(color: AppColors.blue600),
          ),
        ),
      ],
    );
  }
}
