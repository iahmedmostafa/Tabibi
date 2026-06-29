import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tabibi/core/routing/app_routes.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';
import 'package:tabibi/features/home/data/models/department_model.dart';
import 'package:tabibi/features/home/presentation/screen/patient/widgets/soft_circle.dart';

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
    final gradientEnd = Color.lerp(color, AppColors.black, 0.12) ?? color;

    return SizedBox(
      width: width,
      height: height,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () =>
              context.pushNamed(AppRoutes.allDoctors, extra: department.id),
          borderRadius: BorderRadius.circular(24.r),
          child: Ink(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24.r),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [color.withOpacity(0.95), gradientEnd.withOpacity(0.9)],
              ),
              border: Border.all(
                color: AppColors.black.withValues(alpha: 0.05),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Stack(
              children: [
                Positioned(right: -12, top: -10, child: SoftCircle(size: 58.r)),
                Positioned(
                  left: -18,
                  bottom: -22,
                  child: SoftCircle(size: 78.r, opacity: 0.10),
                ),
                Positioned(
                  right: 12.w,
                  bottom: 28.h,
                  child: SoftCircle(size: 36.r, opacity: 0.08),
                ),
                Padding(
                  padding: EdgeInsets.all(14.r),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 64.r,
                        height: 64.r,
                        padding: EdgeInsets.all(12.r),
                        decoration: BoxDecoration(
                          color: AppColors.white.withOpacity(0.18),
                          borderRadius: BorderRadius.circular(20.r),
                          border: Border.all(
                            color: AppColors.white.withOpacity(0.16),
                          ),
                        ),
                        child: department.imageUrl != null
                            ? CachedNetworkImage(
                                imageUrl: department.imageUrl!,
                                fit: BoxFit.contain,
                                errorWidget: (context, _, _) => const Icon(
                                  Iconsax.health,
                                  color: AppColors.white,
                                ),
                              )
                            : const Icon(
                                Iconsax.health,
                                color: AppColors.white,
                              ),
                      ),
                      SizedBox(height: 14.h),
                      Text(
                        department.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w800,
                          color: AppColors.white,
                          height: 1.16,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
