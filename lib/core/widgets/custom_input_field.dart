import 'package:flutter/material.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';
import 'package:tabibi/core/utils/constants/app_dimensions.dart';
import 'package:tabibi/core/utils/constants/app_padding.dart';
import 'package:tabibi/core/utils/constants/sizes.dart';
import 'package:tabibi/core/utils/helper/helper_functions.dart';

class CustomInputField extends StatelessWidget {
  final String hintText;
  final IconData? icon;
  final IconData? suffixIcon;
  final bool isPassword;
  final bool isPrefixIconNotExist;
  final TextEditingController? controller;
  final String? Function(String?)? validator;

  const CustomInputField({
    super.key,
    required this.hintText,
    this.icon,
    this.suffixIcon,
    this.isPassword = false,
    this.isPrefixIconNotExist = true,
    this.controller,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppHeight.h45,
      child: TextFormField(
        obscureText: isPassword,
        controller: controller,
        validator: validator,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        onTapOutside: (event) => FocusManager.instance.primaryFocus
            ?.unfocus(), //to disapear keyboard when tap outside
        decoration: InputDecoration(
          hintText: hintText,

          hintStyle: Theme.of(context).textTheme.bodyMedium,
          prefixIcon: isPrefixIconNotExist
              ? Padding(
                  padding: EdgeInsets.only(
                    left: AppPadding.p16,
                    right: AppWidth.w8,
                  ),
                  child: Icon(
                    icon,
                    color: AppColors.grey400,
                    size: AppSizes.iconSm2,
                  ),
                )
              : null,
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
          fillColor: AppHelperFunctions.isDarkMode(context)
              ? AppColors.darkBackground
              : AppColors.grey100,
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
