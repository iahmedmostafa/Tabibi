import 'package:flutter/material.dart';
import 'package:tabibi/core/utils/constants/app_border_radius.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';
import 'package:tabibi/core/utils/constants/app_dimensions.dart';
import 'package:tabibi/core/utils/helper/helper_functions.dart';

class EditProfileTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData? prefixIcon;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final int maxLines;

  const EditProfileTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    this.prefixIcon,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = AppHelperFunctions.isDarkMode(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600),
        ),
        SizedBox(height: AppHeight.h8),
        TextFormField(
          controller: controller,
          validator: validator,
          keyboardType: keyboardType,
          maxLines: maxLines,
          style: Theme.of(context).textTheme.bodyMedium,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: isDark ? AppColors.grey500 : AppColors.grey400,
            ),
            prefixIcon: prefixIcon != null
                ? Icon(
                    prefixIcon,
                    color: isDark ? AppColors.grey400 : AppColors.grey500,
                    size: 20,
                  )
                : null,
            filled: true,
            fillColor: isDark ? AppColors.grey800 : AppColors.grey100,
            border: OutlineInputBorder(
              borderRadius: AppBorderRadius.r12,
              borderSide: BorderSide(
                color: isDark ? AppColors.grey700 : AppColors.grey300,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: AppBorderRadius.r12,
              borderSide: BorderSide(
                color: isDark ? AppColors.grey700 : AppColors.grey300,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: AppBorderRadius.r12,
              borderSide: const BorderSide(color: AppColors.primary, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: AppBorderRadius.r12,
              borderSide: const BorderSide(color: AppColors.error, width: 1.5),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: AppBorderRadius.r12,
              borderSide: const BorderSide(color: AppColors.error, width: 2),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: AppWidth.w16,
              vertical: AppHeight.h16,
            ),
          ),
        ),
      ],
    );
  }
}
