import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:tabibi/core/routing/app_routes.dart';
import 'package:tabibi/core/services/colors.dart';
import 'package:tabibi/core/style/spacing/vertical_space.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';
import 'package:tabibi/core/utils/constants/app_dimensions.dart';
import 'package:tabibi/core/utils/constants/app_images.dart';
import 'package:tabibi/features/authentication/data/models/department_model.dart';

class DepartmentGridView extends StatelessWidget {
  const DepartmentGridView({
    super.key,
    required this.departments,
    required this.isDark,
  });

  final List<DepartmentModel> departments;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.9,
      ),
      itemCount: departments.length > 8 ? 8 : departments.length,
      itemBuilder: (context, index) {
        final department = departments[index];
        final color = categoryColors[index % categoryColors.length];
        return InkWell(
          onTap: () {
            context.pushNamed(
              AppRoutes.allDoctors,
              extra: department.id, // Pass ID instead of name
            );
          },
          child: Column(
            children: [
              Expanded(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Stack(
                    children: [
                      const Positioned(
                        top: 1,
                        left: 1,
                        child: Image(
                          image: AssetImage(AppImages.layer1),
                          height: 30,
                          width: 40,
                          fit: BoxFit.fill,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Center(
                          child: department.imageUrl != null
                              ? CachedNetworkImage(
                                  imageUrl: department.imageUrl!,
                                  fit: BoxFit.contain,
                                  errorWidget: (context, error, stackTrace) =>
                                      const Icon(
                                        Icons.category,
                                        color: Colors.white,
                                      ),
                                )
                              : const Icon(Icons.category, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              VerticalSpace(height: AppHeight.h8),
              Text(
                department.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                  fontSize: 12.sp,
                  color:
                      Theme.of(context).textTheme.bodyMedium?.color ??
                      (isDark ? AppColors.white : AppColors.black),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }
}
