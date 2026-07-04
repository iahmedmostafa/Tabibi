import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';
import 'package:tabibi/core/utils/enums/enums.dart';
import 'package:tabibi/features/home/presentation/screen/patient/cubit/departments_cubit.dart';
import 'package:tabibi/features/home/presentation/screen/patient/widgets/department_grid_view.dart';
import 'package:easy_localization/easy_localization.dart';

class AllDepartmentsScreen extends StatelessWidget {
  const AllDepartmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          'allCategories'.tr(),
          style: TextStyle(
            color: AppColors.midnightBlue,
            fontSize: 20.sp,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 24.h),
        child: BlocBuilder<DepartmentsCubit, DepartmentsState>(
          builder: (context, state) {
            if (state.departmentsStatus == DepartmentsStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.departmentsStatus == DepartmentsStatus.failure) {
              return Center(
                child: Text(
                  state.errorMessage ?? 'failedToLoadCategories'.tr(),
                ),
              );
            }

            final departments = state.departments ?? [];
            if (departments.isEmpty) {
              return Center(child: Text('noCategoriesFound'.tr()));
            }

            return SingleChildScrollView(
              child: DepartmentGridView(
                departments: departments,
                isDark: isDark,
                crossAxisCount: 3,
                childAspectRatio: 0.78,
              ),
            );
          },
        ),
      ),
    );
  }
}
