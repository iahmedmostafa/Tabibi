import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tabibi/core/routing/app_routes.dart';
import 'package:tabibi/features/home/presentation/screen/patient/widgets/customCarouselSlider.dart';
import 'package:tabibi/features/home/presentation/screen/patient/widgets/custom_text_field.dart';
import 'package:tabibi/features/home/presentation/screen/patient/widgets/department_grid.dart';

import '../../../../../../core/style/spacing/vertical_space.dart';
import '../../../../../../core/utils/constants/app_colors.dart';
import '../../../../../../core/utils/constants/app_dimensions.dart';

class PatientHomeScreen extends StatelessWidget {
  const PatientHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController();
    return SafeArea(
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
                        onPressed: () {
                          context.pushNamed(AppRoutes.notifications);
                        },
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
                const DepartmentsGrid(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
