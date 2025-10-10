import 'package:flutter/material.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';
// ...existing code...

class AuthPromptText extends StatelessWidget {
  final String gestureDetectorName;
  final String text;
  final VoidCallback onPress;
  const AuthPromptText({
    super.key,
    required this.gestureDetectorName,
    required this.text,
    required this.onPress,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(text, style: Theme.of(context).textTheme.bodySmall),
        GestureDetector(
          onTap: onPress,
          child: Text(
            gestureDetectorName,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: AppColors.blue600),
          ),
        ),
      ],
    );
  }
}
