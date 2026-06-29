import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibi/core/services/colors.dart';
import 'package:tabibi/features/home/data/models/department_model.dart';
import 'package:tabibi/features/home/presentation/screen/patient/widgets/department_category_card.dart';

class DepartmentGridView extends StatelessWidget {
  const DepartmentGridView({
    super.key,
    required this.departments,
    required this.isDark,
    this.crossAxisCount = 3,
    this.maxItems,
    this.childAspectRatio = 0.86,
  });

  final List<Department> departments;
  final bool isDark;
  final int crossAxisCount;
  final int? maxItems;
  final double childAspectRatio;

  @override
  Widget build(BuildContext context) {
    final visibleDepartments = maxItems == null
        ? departments
        : departments.take(maxItems!).toList();

    return GridView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: 14.h,
        crossAxisSpacing: 14.w,
        childAspectRatio: childAspectRatio,
      ),
      itemCount: visibleDepartments.length,
      itemBuilder: (context, index) {
        return DepartmentCategoryCard(
          department: visibleDepartments[index],
          color: categoryColors[index % categoryColors.length],
          isDark: isDark,
        );
      },
    );
  }
}
