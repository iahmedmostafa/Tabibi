import 'package:flutter/material.dart';
import 'package:tabibi/core/style/spacing/vertical_space.dart';
import 'package:tabibi/core/utils/constants/app_dimensions.dart';
import 'package:tabibi/features/authentication/modules/fill_profile/presentation/widgets/city_dropdown.dart';
import 'package:tabibi/features/authentication/modules/fill_profile/presentation/widgets/name_input_field.dart';

class ClinicInfoPage extends StatelessWidget {
  final TextEditingController clinicNameController;
  final TextEditingController clinicAddressController;
  final TextEditingController clinicPhoneController;
  final TextEditingController consultationFeeController;
  final TextEditingController yearsOfExperienceController;
  final String? selectedClinicCityId;
  final ValueChanged<String?> onClinicCitySelected;

  const ClinicInfoPage({
    super.key,
    required this.clinicNameController,
    required this.clinicAddressController,
    required this.clinicPhoneController,
    required this.consultationFeeController,
    required this.yearsOfExperienceController,
    required this.selectedClinicCityId,
    required this.onClinicCitySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        VerticalSpace(height: AppHeight.h85),
        NameInputField(
          controller: clinicNameController,
          hintText: 'Clinic Name',
        ),
        VerticalSpace(height: AppHeight.h20),
        NameInputField(
          controller: clinicAddressController,
          hintText: 'Clinic Address',
        ),
        VerticalSpace(height: AppHeight.h20),
        NameInputField(
          controller: clinicPhoneController,
          hintText: 'Clinic Phone',
        ),
        VerticalSpace(height: AppHeight.h20),
        CityDropdown(
          selectedCityId: selectedClinicCityId,
          onCitySelected: onClinicCitySelected,
        ),
        VerticalSpace(height: AppHeight.h20),
        NameInputField(
          controller: consultationFeeController,
          hintText: 'Consultation Fee',
        ),
        VerticalSpace(height: AppHeight.h20),
        NameInputField(
          controller: yearsOfExperienceController,
          hintText: 'Years of Experience',
        ),
      ],
    );
  }
}
