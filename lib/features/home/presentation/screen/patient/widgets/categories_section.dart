import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibi/core/services/colors.dart';
import 'package:tabibi/core/utils/enums/enums.dart';
import 'package:tabibi/features/home/presentation/screen/patient/cubit/departments_cubit.dart';
import 'package:tabibi/features/home/presentation/screen/patient/widgets/department_grid_view.dart';
import 'package:tabibi/features/home/presentation/screen/patient/widgets/home_feedback_panel.dart';

class CategoriesSection extends StatelessWidget {
  const CategoriesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<DepartmentsCubit, DepartmentsState>(
      builder: (context, state) {
        if (state.departmentsStatus == DepartmentsStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.departmentsStatus == DepartmentsStatus.failure) {
          return ErrorPanel(
            message: state.errorMessage ?? 'Failed to load categories',
          );
        }

        final departments = state.departments ?? [];
        if (departments.isEmpty) {
          return const EmptyPanel(message: 'No categories available');
        }

        return SizedBox(
          height: 124.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: departments.length > 6 ? 6 : departments.length,
            separatorBuilder: (_, _) => SizedBox(width: 14.w),
            itemBuilder: (context, index) {
              return SizedBox(
                width: 92.w,
                height: 124.h,
                child: DepartmentCategoryCard(
                  department: departments[index],
                  color: categoryColors[index % categoryColors.length],
                  isDark: isDark,
                  height: 124.h,
                ),
              );
            },
          ),
        );
      },
    );
  }
}
