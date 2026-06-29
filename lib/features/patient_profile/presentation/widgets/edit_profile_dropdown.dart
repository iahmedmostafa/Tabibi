import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
    final fieldStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(
      color: isDark ? AppColors.white : AppColors.black,
    );
    final menuTextStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(
      color: isDark ? AppColors.white : AppColors.black,
      height: 1.2,
    );
    final menuItemBackground = isDark ? AppColors.grey800 : Colors.white;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppInputDecoration.labelStyle(context)),
        SizedBox(height: AppHeight.h8),
        DropdownButtonFormField<T>(
          value: value,
          validator: validator,
          onChanged: onChanged,
          isExpanded: true,
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: isDark ? AppColors.grey400 : AppColors.grey500,
          ),
          iconSize: 24.r,
          elevation: 6,
          menuMaxHeight: 240.h,
          dropdownColor: menuItemBackground,
          style: fieldStyle,
          selectedItemBuilder: (context) {
            return items.map((item) {
              return Align(
                alignment: Alignment.centerLeft,
                child: DefaultTextStyle.merge(
                  style: fieldStyle,
                  child: _buildMenuItemChild(item.child, fieldStyle),
                ),
              );
            }).toList();
          },
          decoration: AppInputDecoration.build(
            context,
            isDark: isDark,
            hintText: hint,
            prefixIcon: prefixIcon,
          ).copyWith(
            contentPadding: EdgeInsets.symmetric(
              horizontal: AppWidth.w16,
              vertical: AppHeight.h16,
            ),
          ),
          items: items.map((item) {
            return DropdownMenuItem<T>(
              value: item.value,
              child: SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppWidth.w8,
                    vertical: AppHeight.h4,
                  ),
                  child: DefaultTextStyle.merge(
                    style: menuTextStyle,
                    child: _buildMenuItemChild(item.child, menuTextStyle),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildMenuItemChild(Widget child, TextStyle? style) {
    if (child is Text) {
      return Text(
        child.data ?? '',
        style: style?.copyWith(
          fontWeight: child.style?.fontWeight,
          fontStyle: child.style?.fontStyle,
          letterSpacing: child.style?.letterSpacing,
        ),
        maxLines: child.maxLines,
        overflow: child.overflow,
        textAlign: child.textAlign,
      );
    }

    return child;
  }
}
