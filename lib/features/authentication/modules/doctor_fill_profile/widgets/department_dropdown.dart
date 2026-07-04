import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tabibi/core/utils/enums/enums.dart';
import 'package:tabibi/core/widgets/drop_menu.dart/drop_menu.dart';
import 'package:tabibi/features/authentication/modules/doctor_fill_profile/cubit/departments_cubit.dart';
import 'package:easy_localization/easy_localization.dart';

class DepartmentDropdown extends StatelessWidget {
  final String? selectedDepartmentId;
  final ValueChanged<String?> onDepartmentSelected;

  const DepartmentDropdown({
    super.key,
    required this.selectedDepartmentId,
    required this.onDepartmentSelected,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DepartmentsCubit, DepartmentsState>(
      builder: (context, state) {
        if (state.departmentsStatus == DepartmentsStatus.loading) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (state.departmentsStatus == DepartmentsStatus.failure) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Text(
              state.errorMessage ?? 'failedToLoadDepartments'.tr(),
              style: const TextStyle(color: Colors.red),
            ),
          );
        }

        if (state.departmentsStatus == DepartmentsStatus.success &&
            state.departments.isNotEmpty) {
          return DropMenu(
            hint: 'departmentDropdown'.tr(),
            prefixIcon: Iconsax.briefcase,
            items: state.departments
                .map((department) => department.name)
                .toList(),
            onChanged: (value) {
              if (value != null) {
                final selectedCity = state.departments.firstWhere(
                  (department) => department.name == value,
                );
                onDepartmentSelected(selectedCity.id);
              }
            },
            value: selectedDepartmentId != null
                ? state.departments
                      .firstWhere((city) => city.id == selectedDepartmentId)
                      .name
                : null,
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
