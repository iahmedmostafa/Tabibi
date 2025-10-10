import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:tabibi/core/style/spacing/vertical_space.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';
import 'package:tabibi/core/utils/constants/app_dimensions.dart';
import 'package:tabibi/core/utils/constants/app_images.dart';
import 'package:tabibi/core/utils/constants/app_padding.dart';
import 'package:tabibi/core/utils/constants/app_strings.dart';
import 'package:tabibi/core/widgets/primary_button.dart';
import 'package:tabibi/features/onboarding/presentation/cubit/onboarding_cubit.dart';
import 'package:tabibi/features/onboarding/presentation/screens/widgets/onboarding_page.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({super.key});
  @override
  Widget build(BuildContext context) {
    log("build");
    final onboardingData = [
      {
        "image": AppImages.onboarding1,
        "title": AppStrings.meetDoctorsTitle,
        "description": AppStrings.meetDoctorsDesc,
      },
      {
        "image": AppImages.onboarding2,
        "title": AppStrings.connectWithSpecialistsTitle,
        "description": AppStrings.connectWithSpecialistsDesc,
      },
      {
        "image": AppImages.onboarding3,
        "title": AppStrings.thousandsSpecialistsTitle,
        "description": AppStrings.thousandsSpecialistsDesc,
      },
    ];

    return BlocProvider(
      create: (_) => OnboardingCubit(),
      child: BlocBuilder<OnboardingCubit, OnboardingState>(
        builder: (context, state) {
          final cubit = context.read<OnboardingCubit>();
          return Scaffold(
            body: Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    controller: cubit.pageController,
                    itemCount: onboardingData.length,
                    onPageChanged: cubit.onPageChanged,
                    itemBuilder: (context, index) {
                      final data = onboardingData[index];
                      return OnboardingPage(
                        image: data["image"]!,
                        title: data["title"]!,
                        description: data["description"]!,
                      );
                    },
                  ),
                ),
                 VerticalSpace(height: AppHeight.h24),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppPadding.p24,
                  ),
                  child: PrimaryButton(
                    height: AppHeight.h48,
                    width: AppWidth.w311,
                    title: "Next",
                    onPress: () =>
                        cubit.nextPage(context, onboardingData.length),
                  ),
                ),
                 VerticalSpace(height: AppHeight.h28),
                SmoothPageIndicator(
                  controller: cubit.pageController,
                  count: onboardingData.length,
                  effect: const ExpandingDotsEffect(
                    activeDotColor: AppColors.primary,
                    dotColor: AppColors.grey,
                    dotHeight: 8,
                    dotWidth: 9,
                    spacing: 6,
                    expansionFactor: 4,
                    radius: 40,
                  ),
                ),
                 VerticalSpace(height: AppHeight.h18),
                GestureDetector(
                  onTap: () => cubit.skip(context),
                  child: Text(
                    AppStrings.skip,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: AppColors.grey500),
                  ),
                ),
                 VerticalSpace(height: AppHeight.h20),
              ],
            ),
          );
        },
      ),
    );
  }
}
