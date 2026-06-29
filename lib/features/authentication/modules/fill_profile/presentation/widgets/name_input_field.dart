import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tabibi/core/utils/constants/app_strings.dart';
import 'package:tabibi/core/widgets/custom_input_field.dart';

class NameInputField extends StatelessWidget {
  final TextEditingController controller;
  final String? hintText;
  final int? maxLines;

  const NameInputField({
    super.key,
    required this.controller,
    this.hintText,
    this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    return CustomInputField(
      hintText: hintText ?? AppStrings.name,
      isPrefixIconNotExist: true,
      icon: Iconsax.personalcard,
      controller: controller,
      maxLines: maxLines ?? 1,
    );
  }
}
