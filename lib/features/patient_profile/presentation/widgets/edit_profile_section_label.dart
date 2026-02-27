import 'package:flutter/material.dart';
import 'package:tabibi/core/utils/constants/app_dimensions.dart';

class EditProfileSectionLabel extends StatelessWidget {
  final String title;

  const EditProfileSectionLabel({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppHeight.h16),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
