import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:tabibi/core/routing/app_routes.dart';
import 'package:tabibi/core/services/colors.dart';
import 'package:tabibi/core/style/spacing/vertical_space.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';
import 'package:tabibi/core/utils/constants/app_images.dart';
import 'package:tabibi/features/home/data/models/department_model.dart';

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

class DepartmentCategoryCard extends StatelessWidget {
  const DepartmentCategoryCard({
    super.key,
    required this.department,
    required this.color,
    required this.isDark,
    this.width,
    this.height,
  });

  final Department department;
  final Color color;
  final bool isDark;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final card = SizedBox(
      width: width,
      height: height,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: double.infinity,
            height: 78.h,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(20.r),
                boxShadow: [
                  BoxShadow(
                    color: color.withValues(alpha: 0.18),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: 0,
                    left: 0,
                    child: Image.asset(
                      AppImages.layer1,
                      height: 36.h,
                      width: 46.w,
                      fit: BoxFit.fill,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(14.r),
                    child: Center(
                      child: department.imageUrl != null
                          ? CachedNetworkImage(
                              imageUrl: department.imageUrl!,
                              fit: BoxFit.contain,
                              errorWidget: (context, _, _) => const Icon(
                                Icons.category,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(
                              Icons.category,
                              color: Colors.white,
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          VerticalSpace(height: 10.h),
          SizedBox(
            height: 34.h,
            child: Center(
              child: Text(
                department.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w700,
                      color: isDark ? AppColors.white : AppColors.midnightBlue,
                    ),
              ),
            ),
          ),
        ],
      ),
    );

    return InkWell(
      onTap: () => context.pushNamed(AppRoutes.allDoctors, extra: department.id),
      borderRadius: BorderRadius.circular(20.r),
      child: card,
    );
  }
}
