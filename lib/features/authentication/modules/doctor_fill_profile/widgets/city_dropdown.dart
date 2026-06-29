import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tabibi/core/utils/enums/enums.dart';
import 'package:tabibi/core/widgets/drop_menu.dart/drop_menu.dart';
import 'package:tabibi/features/authentication/modules/fill_profile/presentation/cubit/cities_cubit.dart';
import 'package:tabibi/features/authentication/modules/fill_profile/presentation/cubit/cities_state.dart';

class CityDropdown extends StatelessWidget {
  final String? selectedCityId;
  final ValueChanged<String?> onCitySelected;

  const CityDropdown({
    super.key,
    required this.selectedCityId,
    required this.onCitySelected,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CitiesCubit, CitiesState>(
      builder: (context, state) {
        if (state.status == CitiesStatus.loading) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (state.status == CitiesStatus.failure) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Text(
              state.errorMessage ?? 'Failed to load cities',
              style: const TextStyle(color: Colors.red),
            ),
          );
        }

        if (state.status == CitiesStatus.success && state.cities.isNotEmpty) {
          return DropMenu(
            hint: 'City',
            prefixIcon: Iconsax.location,
            items: state.cities.map((city) => city.name).toList(),
            onChanged: (value) {
              if (value != null) {
                final selectedCity = state.cities.firstWhere(
                  (city) => city.name == value,
                );
                onCitySelected(selectedCity.id);
              }
            },
            value: selectedCityId != null
                ? state.cities
                    .firstWhere((city) => city.id == selectedCityId)
                    .name
                : null,
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
