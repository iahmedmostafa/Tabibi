import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';
import 'package:tabibi/core/utils/constants/app_dimensions.dart';
import 'package:tabibi/core/utils/constants/app_input_decoration.dart';
import 'package:tabibi/core/utils/helper/helper_functions.dart';

class DropMenu extends StatelessWidget {
  final List<String> items;
  final String hint;
  final void Function(String?) onChanged;
  final String? value;
  final IconData? prefixIcon;

  const DropMenu({
    super.key,
    required this.items,
    required this.hint,
    required this.onChanged,
    this.value,
    this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = AppHelperFunctions.isDarkMode(context);
    final fieldStyle = Theme.of(context).textTheme.headlineSmall?.copyWith(
      color: isDark ? AppColors.white : AppColors.black,
    );
    final menuTextStyle = Theme.of(context).textTheme.headlineSmall?.copyWith(
      color: isDark ? AppColors.white : AppColors.black,
      height: 1.2,
    );
    final menuBackground = isDark ? AppColors.grey800 : Colors.white;

    return DropdownButtonFormField<String>(
      initialValue: value,
      isExpanded: true,
      borderRadius: BorderRadius.circular(16),
      icon: Icon(
        Icons.keyboard_arrow_down_rounded,
        color: isDark ? AppColors.grey400 : AppColors.grey500,
      ),
      iconSize: 24.r,
      elevation: 6,
      menuMaxHeight: 240.h,
      dropdownColor: menuBackground,
      style: fieldStyle,
      hint: Text(
        hint,
        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
          color: isDark ? AppColors.white : AppColors.dark,
        ),
      ),
      selectedItemBuilder: (context) {
        return items.map((item) {
          return Align(
            alignment: Alignment.centerLeft,
            child: Text(
              item,
              style: fieldStyle,
              overflow: TextOverflow.ellipsis,
            
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
      items: items.map((String item) {
        return DropdownMenuItem<String>(
          value: item,
          child: SizedBox(
            width: double.infinity,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppWidth.w8,
                vertical: AppHeight.h4,
              ),
              child: Text(
                item,
                style: menuTextStyle,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }
}
