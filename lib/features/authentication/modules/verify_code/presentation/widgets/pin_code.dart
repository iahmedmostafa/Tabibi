import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:tabibi/core/utils/constants/app_border_radius.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';

class PinCode extends StatelessWidget {
  const PinCode({super.key});

  @override
  Widget build(BuildContext context) {
    return PinCodeTextField(
      appContext: context,
      length: 4,
      keyboardType: TextInputType.number,
      enableActiveFill: true,
      textStyle:
          Theme.of(context).textTheme.bodyMedium ??
          const TextStyle(fontSize: 16),
      pinTheme: PinTheme(
        fieldHeight: 56,
        fieldWidth: 56,
        shape: PinCodeFieldShape.box,
        borderRadius: AppBorderRadius.r12,
        borderWidth: 1,
        activeColor: AppColors.grey200,
        activeFillColor: AppColors.grey100,
        inactiveColor: AppColors.grey200,
        inactiveFillColor: AppColors.grey100,
        selectedColor: AppColors.blue600,
        selectedFillColor: Colors.white,
      ),
    );
  }
}
