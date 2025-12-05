import 'package:flutter/material.dart';
import 'package:tabibi/core/style/spacing/vertical_space.dart';
import 'package:tabibi/core/utils/constants/app_dimensions.dart';
import 'package:tabibi/features/authentication/modules/doctor_fill_profile/widgets/credential_image_upload_section.dart';
import 'package:tabibi/features/authentication/modules/doctor_fill_profile/widgets/department_dropdown.dart';

class CredentialsPage extends StatelessWidget {
  final String? selectedDepartmentId;
  final ValueChanged<String?> onDepartmentSelected;

  const CredentialsPage({
    super.key,
    required this.selectedDepartmentId,
    required this.onDepartmentSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const CredentialImageUploadSection(),
        VerticalSpace(height: AppHeight.h20),
        DepartmentDropdown(
          selectedDepartmentId: selectedDepartmentId,
          onDepartmentSelected: onDepartmentSelected,
        ),
      ],
    );
  }
}
