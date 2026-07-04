import 'package:flutter/material.dart';
import 'package:tabibi/core/style/spacing/vertical_space.dart';
import 'package:tabibi/core/utils/constants/app_dimensions.dart';
import 'package:tabibi/core/utils/constants/app_strings.dart';
import 'package:tabibi/core/widgets/drop_menu.dart/drop_menu.dart';
import 'package:tabibi/features/authentication/modules/fill_profile/presentation/widgets/city_dropdown.dart';
import 'package:tabibi/features/authentication/modules/fill_profile/presentation/widgets/date_picker_field.dart';
import 'package:tabibi/features/authentication/modules/fill_profile/presentation/widgets/image_upload_section.dart';
import 'package:tabibi/features/authentication/modules/fill_profile/presentation/widgets/name_input_field.dart';
import 'package:easy_localization/easy_localization.dart';

class PersonalInfoPage extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController bioController;
  final int gender;
  final String? selectedBirthdate;
  final String? selectedCityId;
  final ValueChanged<int> onGenderChanged;
  final ValueChanged<String> onBirthdateSelected;
  final ValueChanged<String?> onCitySelected;

  const PersonalInfoPage({
    super.key,
    required this.nameController,
    required this.bioController,
    required this.gender,
    required this.selectedBirthdate,
    required this.selectedCityId,
    required this.onGenderChanged,
    required this.onBirthdateSelected,
    required this.onCitySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        VerticalSpace(height: AppHeight.h28),
        const ImageUploadSection(),
        VerticalSpace(height: AppHeight.h28),
        NameInputField(controller: nameController),
        VerticalSpace(height: AppHeight.h28),
        NameInputField(
          controller: bioController,
          hintText: 'bio'.tr(),
          maxLines: 3,
        ),
        VerticalSpace(height: AppHeight.h28),
        DropMenu(
          hint: AppStrings.genderFillProfile,
          items: ['male'.tr(), 'female'.tr()],
          onChanged: (value) {
            onGenderChanged(value == 'male'.tr() ? 1 : 2);
          },
          value: gender == 1 ? 'male'.tr() : 'female'.tr(),
        ),
        VerticalSpace(height: AppHeight.h28),
        DatePickerField(
          selectedDate: selectedBirthdate,
          hintText: AppStrings.dateFillProfile,
          pickerTitle: 'selectBirthdate'.tr(),
          onDateSelected: onBirthdateSelected,
          initialDateTime: DateTime(2000, 1, 1),
        ),
        VerticalSpace(height: AppHeight.h28),
        CityDropdown(
          selectedCityId: selectedCityId,
          onCitySelected: onCitySelected,
        ),
        VerticalSpace(height: AppHeight.h16),
      ],
    );
  }
}
