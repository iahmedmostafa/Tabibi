import 'package:flutter/material.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';
import 'package:tabibi/core/utils/constants/app_dimensions.dart';
import 'package:tabibi/core/utils/constants/app_padding.dart';
import 'package:tabibi/core/utils/constants/sizes.dart';

class CustomInputField extends StatelessWidget {
  final String hintText;
  final IconData? icon;
  final IconData? suffixIcon;
  final bool isPassword;

  const CustomInputField({
    super.key,
    required this.hintText,
    this.icon,
    this.suffixIcon,
    this.isPassword = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppHeight.h45,
      child: TextFormField(
        obscureText: isPassword,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        onTapOutside: (event) => FocusManager.instance.primaryFocus
            ?.unfocus(), //to disapear keyboard when tap outside
        decoration: InputDecoration(
          hintText: hintText,

          hintStyle: Theme.of(
            context,
          ).textTheme.bodyMedium,
          prefixIcon: Padding(
            padding: EdgeInsets.only(left: AppPadding.p16, right: AppWidth.w8),
            child: Icon(icon, color: AppColors.grey400, size: AppSizes.iconSm2),
          ),
          prefixIconConstraints: const BoxConstraints(
            minWidth: 0,
            minHeight: 0,
          ),
          suffixIcon: Padding(
            padding: const EdgeInsets.only(right: AppPadding.p16),
            child: Icon(
              suffixIcon,
              color: AppColors.grey400,
              size: AppSizes.iconSm2,
            ),
          ),
          filled: true,
          fillColor: AppColors.grey50,
          contentPadding: const EdgeInsets.symmetric(
            vertical: AppPadding.p10,
            horizontal: AppPadding.p16,
          ),
          border: Theme.of(context).inputDecorationTheme.border,
          enabledBorder: Theme.of(context).inputDecorationTheme.enabledBorder,
          focusedBorder: Theme.of(context).inputDecorationTheme.focusedBorder,
        ),
      ),
    );
  }
}
