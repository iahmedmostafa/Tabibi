import 'package:flutter/material.dart';
import 'package:tabibi/core/utils/constants/app_strings.dart';
import 'package:tabibi/core/widgets/custom_input_field.dart';

class NameInputField extends StatelessWidget {
  final TextEditingController controller;

  const NameInputField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return CustomInputField(
      hintText: AppStrings.nameFillProfile,
      isPassword: false,
      isPrefixIconNotExist: false,
      controller: controller,
    );
  }
}
