import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabibi/core/DI/service_locator.dart';
import 'package:tabibi/core/utils/enums/enums.dart';
import 'package:tabibi/features/home/presentation/screen/patient/cubit/departments_cubit.dart';
import 'package:tabibi/features/home/presentation/screen/patient/widgets/department_grid_view.dart';

class DepartmentsGrid extends StatelessWidget {
  const DepartmentsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return BlocProvider(
      create: (context) => sl<DepartmentsCubit>()..getDepartments(),
      child: BlocBuilder<DepartmentsCubit, DepartmentsState>(
        builder: (context, state) {
          if (state.departmentsStatus == DepartmentsStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.departmentsStatus == DepartmentsStatus.failure) {
            return Center(
              child: Text(
                state.errorMessage ?? "Something went wrong",
                style: const TextStyle(color: Colors.red),
              ),
            );
          } else if (state.departmentsStatus == DepartmentsStatus.success) {
            final departments = state.departments;
            if (departments?.isEmpty ?? true) {
              return const Center(child: Text("No categories found"));
            }
            return DepartmentGridView(
              departments: departments!,
              isDark: isDark,
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
