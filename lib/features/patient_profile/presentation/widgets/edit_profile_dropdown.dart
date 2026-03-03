import 'package:flutter/material.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';
import 'package:tabibi/core/utils/constants/app_dimensions.dart';
import 'package:tabibi/core/utils/constants/app_input_decoration.dart';
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
        Text(label, style: AppInputDecoration.labelStyle(context)),
        SizedBox(height: AppHeight.h8),
        DropdownButtonFormField<T>(
          value: value,
          validator: validator,
          onChanged: onChanged,
          items: items,
          style: Theme.of(context).textTheme.bodyMedium,
          dropdownColor: isDark ? AppColors.grey800 : Colors.white,
          decoration: AppInputDecoration.build(
            context,
            isDark: isDark,
            hintText: hint,
            prefixIcon: prefixIcon,
          ),
        ),
      ],
    );
  }
}
