import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:tabibi/core/services/colors.dart';
import 'package:tabibi/core/utils/enums/enums.dart';
import 'package:tabibi/features/home/presentation/screen/patient/cubit/departments_cubit.dart';
import 'package:tabibi/features/home/presentation/screen/patient/widgets/department_category_card.dart';
import 'package:tabibi/features/home/presentation/screen/patient/widgets/home_feedback_panel.dart';
import 'package:easy_localization/easy_localization.dart';

class CategoriesSection extends StatelessWidget {
  const CategoriesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<DepartmentsCubit, DepartmentsState>(
      builder: (context, state) {
        if (state.departmentsStatus == DepartmentsStatus.loading) {
          return _CategoriesSkeleton();
        }

        if (state.departmentsStatus == DepartmentsStatus.failure) {
          return ErrorPanel(
            message: state.errorMessage ?? 'failedToLoadCategories'.tr(),
          );
        }

        final departments = state.departments ?? [];
        if (departments.isEmpty) {
          return EmptyPanel(message: 'noCategoriesAvailable'.tr());
        }

        final visibleDepartments = departments.take(8).toList();

        return SizedBox(
          height: 154.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.only(right: 8.w),
            itemCount: visibleDepartments.length,
            separatorBuilder: (_, _) => SizedBox(width: 12.w),
            itemBuilder: (context, index) {
              return SizedBox(
                width: 122.w,
                child: DepartmentCategoryCard(
                  department: visibleDepartments[index],
                  color: categoryColors[index % categoryColors.length],
                  isDark: isDark,
                  height: 154.h,
                  width: 122.w,
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class _CategoriesSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: SizedBox(
        height: 154.h,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 4,
          separatorBuilder: (_, _) => SizedBox(width: 12.w),
          itemBuilder: (context, index) {
            return SizedBox(
              width: 122.w,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24.r),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 64.r,
                      height: 64.r,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                    ),
                    SizedBox(height: 14.h),
                    Container(width: 80.w, height: 14.h, color: Colors.white),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
