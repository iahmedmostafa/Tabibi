import 'package:flutter/material.dart';
import 'package:tabibi/core/utils/constants/app_border_radius.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';
import 'package:tabibi/core/utils/constants/app_dimensions.dart';
import 'package:tabibi/core/utils/constants/sizes.dart';
import 'package:tabibi/core/utils/helper/helper_functions.dart';

class DropMenu extends StatelessWidget {
  final List<String> items;
  final String hint;
  final void Function(String?) onChanged;
  final String? value;

  const DropMenu({
    super.key,
    required this.items,
    required this.hint,
    required this.onChanged,
    this.value,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = AppHelperFunctions.isDarkMode(context);
    return Padding(
      padding: EdgeInsets.only(top: AppHeight.h20, bottom: AppHeight.h18),
      child: Material(
        elevation: 4,
        borderRadius: AppBorderRadius.r8,
        child: DropdownButtonFormField<String>(
          initialValue: value,
          hint: Text(
            hint,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          decoration: InputDecoration(
            hintStyle: Theme.of(context).textTheme.bodyMedium,
            filled: true,
            fillColor: isDark ? AppColors.darkBackground : AppColors.grey100,
            border: Theme.of(context).inputDecorationTheme.border,
            enabledBorder: Theme.of(context).inputDecorationTheme.enabledBorder,
            focusedBorder: Theme.of(context).inputDecorationTheme.focusedBorder,
            contentPadding: EdgeInsets.symmetric(
              vertical: AppHeight.h8,
              horizontal: AppWidth.w16,
            ),
          ),
          dropdownColor: isDark ? AppColors.darkBackground : AppColors.grey100,
          icon: const Icon(
            Icons.keyboard_arrow_down,
            color: AppColors.grey100,
            size: AppSizes.iconSm2,
          ),
          items: items.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                value,
                style: Theme.of(context).textTheme.bodyMedium
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
