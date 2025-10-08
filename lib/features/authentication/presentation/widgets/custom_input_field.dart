import 'package:flutter/material.dart';
import 'package:tabibi/core/constants/app_colors.dart';

class CustomInputField extends StatelessWidget {
  final String hintText;
  final IconData? icon;
  final IconData? suffixIcon;
  final bool isPassword;

  const CustomInputField({
    required this.hintText,
    this.icon,
    this.suffixIcon,
    this.isPassword = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 45,
      child: TextFormField(
        obscureText: isPassword,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(
            color: AppColors.grey400,
            fontSize: 14,
          ),
          prefixIcon: Padding(
            padding: const EdgeInsets.only(left: 16, right: 8),
            child: Icon(icon, color: AppColors.grey400, size: 20),
          ),
          prefixIconConstraints: const BoxConstraints(
            minWidth: 0,
            minHeight: 0,
          ),
          suffixIcon: Padding(
              padding: const EdgeInsets.only(right: 16),
            child: Icon(suffixIcon,color: AppColors.grey400,size: 20,),
          ),
          filled: true,
          fillColor: AppColors.grey50,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 12,
            horizontal: 16,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppColors.grey300, width: 1),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppColors.grey300, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppColors.blue600, width: 1.2),
          ),
        ),
      ),
    );
  }
}
