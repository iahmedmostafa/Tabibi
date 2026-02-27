import 'package:flutter/material.dart';
import 'package:tabibi/core/utils/constants/app_border_radius.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';
import 'package:tabibi/core/utils/constants/app_dimensions.dart';
import 'package:tabibi/core/utils/helper/helper_functions.dart';

class EditProfileDropdown<T> extends StatelessWidget {
  final String label;
  final String hint;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;
  final IconData? prefixIcon;
  final String? Function(T?)? validator;

  const EditProfileDropdown({
    super.key,
    required this.label,
    required this.hint,
    required this.value,
    required this.items,
    required this.onChanged,
    this.prefixIcon,
    this.validator,
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
        DropdownButtonFormField<T>(
          value: value,
          validator: validator,
          onChanged: onChanged,
          items: items,
          style: Theme.of(context).textTheme.bodyMedium,
          dropdownColor: isDark ? AppColors.grey800 : Colors.white,
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
