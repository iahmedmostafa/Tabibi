import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibi/core/style/spacing/vertical_space.dart';
import 'package:tabibi/core/utils/constants/app_styles.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../../../core/utils/constants/app_images.dart';

class CustomCarouselSlider extends StatefulWidget {
  const CustomCarouselSlider({super.key});

  @override
  State<CustomCarouselSlider> createState() => _CustomCarouselSliderState();
}

class _CustomCarouselSliderState extends State<CustomCarouselSlider> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            height: 180.h,
            padEnds: true,
            enlargeCenterPage: true,
            viewportFraction: 1,
            autoPlay: false,
            autoPlayInterval: const Duration(seconds: 2),
            onPageChanged: (index, reason) {
              setState(() {
                currentIndex = index;
              });
            },
          ),
          items: [1, 2, 3].map((i) {
            return Builder(
              builder: (BuildContext context) {
                return Stack(
                  children: [
                    Image(
                      image: const AssetImage(AppImages.carouselImage),
                      width: double.infinity,
                      height: 260.h,
                      fit: BoxFit.fill,
                    ),
                    Positioned(
                      left: 0,
                      top: 0,
                      height: 90.h,
                      width: 100.w,
                      child: Image.asset(AppImages.layer1,fit: BoxFit.fill,),
                    ),
                    Positioned(
                      left: 40.w,
                      bottom: 0,
                      height: 20.h,
                      width: 100.w,
                      child: Image.asset(AppImages.layer2,fit: BoxFit.fill),
                    ),
                    Positioned(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const VerticalSpace(height: 30),
                            SizedBox(
                              width: 230.w,
                              child: Column(
                                children: [
                                  Text(
                                    "Looking for Specialist Doctors?",
                                    style: AppTextStyle.bodySBold.copyWith(
                                      color: AppColors.white,
                                      fontSize: 20.sp,
                                  ),),
                                  const VerticalSpace(height: 8),
                                  Text(
                                    "Schedule an appointment with our top doctors.",
                                    style: AppTextStyle.bodyLg.copyWith(
                                      color: AppColors.white.withOpacity(.7),
                                      fontSize: 14.sp,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 10.h,
                      left: 120.h,
                      child: DotsIndicator(
                        dotsCount: 3,
                        position: currentIndex.toDouble(),
                        decorator: DotsDecorator(
                          size: const Size.square(10.0),
                          spacing: const EdgeInsets.symmetric(horizontal: 4),
                          activeSize: const Size(30.0, 9.0),
                          activeShape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.r),
                          ),
                          color: AppColors.grey400, // Inactive color
                          activeColor: AppColors.white,
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          }).toList(),
        ),
        const VerticalSpace(height: 16),
      ],
    );
  }
}
