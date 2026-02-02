import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:tabibi/core/routing/app_routes.dart';
import 'package:tabibi/core/utils/constants/app_images.dart';
import 'package:tabibi/features/home/presentation/screen/patient/widgets/customCarouselSlider.dart';
import 'package:tabibi/features/home/presentation/screen/patient/widgets/custom_text_field.dart';

import '../../../../../../core/DI/service_locator.dart';
import '../../../../../../core/style/spacing/vertical_space.dart';
import '../../../../../../core/utils/constants/app_colors.dart';
import '../../../../../../core/utils/constants/app_dimensions.dart';
import '../../../../../../core/utils/enums/enums.dart';
import '../cubit/departments_cubit.dart';

class PatientHomeScreen extends StatelessWidget {
  const PatientHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController();
    return BlocProvider(
      create: (context) => sl<DepartmentsCubit>()..getDepartments(),
      child: SafeArea(
        child: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  VerticalSpace(height: AppHeight.h20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Location",
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: IconButton(
                          onPressed: () {},
                          icon: const Icon(CupertinoIcons.bell_fill, size: 21),
                        ),
                      ),
                    ],
                  ),
                  VerticalSpace(height: AppHeight.h8),
                CustomTextField(controller: controller, isEnabled: true),
                  VerticalSpace(height: AppHeight.h8),
                  const CustomCarouselSlider(),
                  VerticalSpace(height: AppHeight.h8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Categories",
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      InkWell(
                        onTap: () {
                          GoRouter.of(context).go(AppRoutes.allDoctors);
                        },
                        child: const Text(
                          "See All",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.blue600,
                            decoration: TextDecoration.underline,
                            decorationColor: AppColors.blue600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  VerticalSpace(height: AppHeight.h12),
                  const _DepartmentsGrid(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DepartmentsGrid extends StatelessWidget {
  const _DepartmentsGrid();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return BlocBuilder<DepartmentsCubit, DepartmentsState>(
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
          final departments = state.departments ?? [];
          if (departments.isEmpty) {
            return const Center(child: Text("No categories found"));
          }
          final List<Color> categoryColors = [
            const Color(
              0xFFD32F2F,
            ).withOpacity(0.5), // Darker Red (from E57373)
            const Color(
              0xFF388E3C,
            ).withOpacity(0.5), // Darker Green (from 81C784)
            const Color(
              0xFFF57C00,
            ).withOpacity(0.5), // Darker Orange (from FFB74D)
            const Color(
              0xFF7B1FA2,
            ).withOpacity(0.5), // Darker Purple (from BA68C8)
            const Color(
              0xFF00796B,
            ).withOpacity(0.5), // Darker Teal (from 4DB6AC)
            const Color(
              0xFF303F9F,
            ).withOpacity(0.5), // Darker Indigo (from 7986CB)
            const Color(
              0xFF0097A7,
            ).withOpacity(0.5), // Darker Cyan (from 4DD0E1)
            const Color(
              0xFF455A64,
            ).withOpacity(0.5), // Darker Blue Grey (from 90A4AE)
          ];

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
                                    ? Image.network(
                                        department.imageUrl!,
                                        fit: BoxFit.contain,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                const Icon(
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
                    VerticalSpace(height: AppHeight.h8),
                    Text(
                      department.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                        fontSize: 12.sp,
                        color:  isDark? AppColors.white : AppColors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            },
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
