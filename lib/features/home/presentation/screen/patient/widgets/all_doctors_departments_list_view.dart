import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/style/spacing/horizental_space.dart';
import '../../../../../../core/utils/constants/app_colors.dart';
import '../../../../../../core/utils/enums/enums.dart';
import '../../../../data/models/department_model.dart';
import '../cubit/departments_cubit.dart';
import '../cubit/doctors_cubit.dart';

class AllDoctorsDepartmentsListView extends StatelessWidget {
  final String? selectedDepartmentId;
  final void Function(String?) onDepartmentSelected;
  final String searchQuery;

  const AllDoctorsDepartmentsListView({
    super.key,
    required this.selectedDepartmentId,
    required this.onDepartmentSelected,
    required this.searchQuery,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48.h,
      child: BlocBuilder<DepartmentsCubit, DepartmentsState>(
        builder: (context, state) {
          if (state.departmentsStatus == DepartmentsStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          final departments = state.departments ?? [];
          // Create a list of "All" + actual departments
          final List<Department?> categories = [null, ...departments];

          return ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            separatorBuilder: (context, index) =>
                const HorizentalSpace(width: 10),
            itemBuilder: (context, index) {
              final category = categories[index];
              final categoryName = category?.name ?? "All";
              final categoryId = category?.id; // null for All

              final isSelected = selectedDepartmentId == categoryId;

              return GestureDetector(
                onTap: () {
                  onDepartmentSelected(categoryId);
                  context.read<DoctorsCubit>().getDoctors(
                    departmentId: categoryId,
                    query: searchQuery,
                  );
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: EdgeInsets.symmetric(
                    horizontal: 24.w,
                    vertical: 8.h,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.midnightBlue : Colors.white,
                    borderRadius: BorderRadius.circular(24.r),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: AppColors.midnightBlue.withValues(
                                alpha: 0.3,
                              ),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ]
                        : [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.05),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                    border: Border.all(
                      color: isSelected
                          ? AppColors.midnightBlue
                          : Colors.grey.shade300,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      categoryName,
                      style: TextStyle(
                        color: isSelected
                            ? Colors.white
                            : AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                        fontSize: 13.sp,
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
