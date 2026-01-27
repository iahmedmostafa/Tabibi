import 'package:flutter/material.dart';
import 'package:tabibi/features/home/presentation/widgets/customCarouselSlider.dart';
import 'package:tabibi/features/home/presentation/widgets/custom_text_field.dart';

import '../../../../../core/style/spacing/vertical_space.dart';
import '../../../../../core/utils/constants/app_colors.dart';
import '../../../../../core/utils/constants/app_dimensions.dart';

class PatientHomeScreen extends StatelessWidget {
  const PatientHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController controller=TextEditingController();
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              VerticalSpace(height: AppHeight.h20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Location",style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppColors.black,
                  ),),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.notifications_on_rounded,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
              VerticalSpace(height: AppHeight.h20),
              CustomTextField(controller: controller,isEnabled: true,),
              VerticalSpace(height: AppHeight.h8),
              const CustomCarouselSlider(),






            ],
          ),
        ),
      ),
    );
  }
}
