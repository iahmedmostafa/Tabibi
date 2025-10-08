import 'package:flutter/material.dart';
import 'package:tabibi/core/constants/app_colors.dart';
import 'package:tabibi/core/constants/app_styles.dart';

class SocialButton extends StatelessWidget {
  final String text;
  final String iconPath;
  final VoidCallback onPressed;

  const SocialButton({
    required this.text,
    required this.iconPath,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        backgroundColor: Colors.white,
        side: const BorderSide(color: AppColors.grey200, width: 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(vertical: 10),
        minimumSize: const Size(double.infinity, 50),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(iconPath, width: 20, height: 20),
          const SizedBox(width: 8),
          Text(
            text,
            style: AppTextStyles.dark20w600
                .copyWith(fontSize: 14,fontWeight: FontWeight.w500)
          ),
        ],
      ),
    );
  }
}