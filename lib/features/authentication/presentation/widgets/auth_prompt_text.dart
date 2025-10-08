import 'package:flutter/material.dart';
import 'package:tabibi/core/constants/app_colors.dart';
import 'package:tabibi/core/constants/app_styles.dart';

class AuthPromptText extends StatelessWidget {
  String gestureDetectorName;
  String text;
  VoidCallback onPress;
  AuthPromptText({
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
