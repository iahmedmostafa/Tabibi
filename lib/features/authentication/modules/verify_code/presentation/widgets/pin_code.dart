import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:tabibi/core/utils/constants/app_border_radius.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';
import 'package:tabibi/core/utils/helper/helper_functions.dart';
import 'package:tabibi/core/utils/validators/validation.dart';

class PinCode extends StatelessWidget {
  final TextEditingController controller;
  const PinCode({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final bool isDark =
        Theme.of(context).brightness == Brightness.dark ||
        AppHelperFunctions.isDarkMode(context);

    // color mapping for pin fields depending on theme
    final Color activeBorder =
        AppColors.primary; // bright accent for active border
    final Color activeFill =  AppColors.primary ;
    final Color selectedBorder = AppColors.primary;
    final Color selectedFill = isDark ? AppColors.primary : AppColors.white;
    final Color inactiveBorder = isDark ? AppColors.grey700 : AppColors.grey200;
    final Color inactiveFill = isDark ? AppColors.grey800 : AppColors.grey100;

    return PinCodeTextField(
      appContext: context,
      length: 4,
      keyboardType: TextInputType.number,
      enableActiveFill: true,
      controller: controller, // ربط الـ controller
      validator: (value) => Validator.validatePinCode(value),
      textStyle:
          Theme.of(context).textTheme.bodyMedium ??
          const TextStyle(fontSize: 16),
      pinTheme: PinTheme(
        fieldHeight: 56,
        fieldWidth: 56,
        shape: PinCodeFieldShape.box,
        borderRadius: AppBorderRadius.r12,
        borderWidth: 1,
        activeColor: activeBorder,
        activeFillColor: activeFill,
        inactiveColor: inactiveBorder,
        inactiveFillColor: inactiveFill,
        selectedColor: selectedBorder,
        selectedFillColor: selectedFill,
      ),
    );
  }
}
