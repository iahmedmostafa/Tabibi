import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tabibi/core/utils/constants/app_strings.dart';
import 'package:tabibi/core/utils/enums/enums.dart';
import 'package:tabibi/features/authentication/modules/fill_profile/presentation/cubit/cities_cubit.dart';
import 'package:tabibi/features/authentication/modules/fill_profile/presentation/cubit/cities_state.dart';
import 'package:tabibi/features/patient_profile/presentation/widgets/edit_profile_dropdown.dart';
import 'package:easy_localization/easy_localization.dart';

class EditProfileCityDropdown extends StatelessWidget {
  final String? selectedCityId;
  final ValueChanged<String?> onChanged;

  const EditProfileCityDropdown({
    super.key,
    required this.selectedCityId,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CitiesCubit, CitiesState>(
      builder: (context, state) {
        if (state.status == CitiesStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.status == CitiesStatus.failure) {
          return Text(
            state.errorMessage ?? 'failedToLoadCities'.tr(),
            style: const TextStyle(color: Colors.red),
          );
        }

        if (state.cities.isEmpty) return const SizedBox.shrink();

        return EditProfileDropdown<String>(
          label: AppStrings.city,
          hint: AppStrings.city,
          value: selectedCityId,
          prefixIcon: Iconsax.location,
          items: state.cities
              .map(
                (city) => DropdownMenuItem<String>(
                  value: city.id,
                  child: Text(city.name),
                ),
              )
              .toList(),
          onChanged: onChanged,
          validator: (value) {
            if (value == null || value.isEmpty) return AppStrings.cityRequired;
            return null;
          },
        );
      },
    );
  }
}
