import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:tabibi/core/routing/app_routes.dart';
import 'package:tabibi/core/style/spacing/vertical_space.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';
import 'package:tabibi/core/utils/constants/app_images.dart';
import 'package:tabibi/core/utils/constants/app_styles.dart';

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
            height: 220.h,
            viewportFraction: 0.92,
            enlargeCenterPage: true,
            autoPlay: false,
            pageSnapping: true,
            
            onPageChanged: (index, reason) {
              setState(() {
                currentIndex = index;
              });
            },
          ),
          items: [1, 2, 3].map((i) {
            return Builder(
              builder: (BuildContext context) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 2.w),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(28.r),
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: Image.asset(
                            AppImages.carouselImage,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned.fill(
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [
                                  const Color(0xFF0F3D5E).withOpacity(0.84),
                                  const Color(0xFF2C9B9F).withOpacity(0.52),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 0,
                          top: 0,
                          bottom: 0,
                          width: 130.w,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [
                                  Colors.black.withOpacity(0.12),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                          ),
                        ),

                        Positioned(
                          left: 18.w,
                          right: 18.w,
                          bottom: 18.h,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                width: 210.w,
                                child: Text(
                                  'Looking for specialist doctors?',
                                  style: AppTextStyle.bodySBold.copyWith(
                                    color: AppColors.white,
                                    fontSize: 22.sp,
                                    height: 1.15,
                                  ),
                                ),
                              ),
                              SizedBox(height: 10.h),
                              SizedBox(
                                width: 210.w,
                                child: Text(
                                  'Schedule an appointment with top-rated doctors in a calmer, more guided experience.',
                                  style: AppTextStyle.bodyLg.copyWith(
                                    color: AppColors.white.withOpacity(0.84),
                                    fontSize: 13.sp,
                                    height: 1.4,
                                  ),
                                ),
                              ),
                              SizedBox(height: 14.h),
                              GestureDetector(
                                onTap: () => context.pushNamed(AppRoutes.allDoctors),
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 14.w,
                                    vertical: 10.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.white.withOpacity(0.16),
                                    borderRadius: BorderRadius.circular(999.r),
                                    border: Border.all(
                                      color: AppColors.white.withOpacity(0.14),
                                    ),
                                  ),
                                  child: Text(
                                    'Explore doctors',
                                    style: Theme.of(context).textTheme.labelLarge
                                        ?.copyWith(
                                          color: AppColors.white,
                                          fontWeight: FontWeight.w700,
                                        ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }).toList(),
        ),
        SizedBox(height: 14.h),
        DotsIndicator(
          dotsCount: 3,
          position: currentIndex.toDouble(),
          decorator: DotsDecorator(
            size: Size.square(7.r),
            spacing: EdgeInsets.symmetric(horizontal: 4.w),
            activeSize: Size(22.w, 7.h),
            activeShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(999.r),
            ),
            color: AppColors.grey300,
            activeColor: AppColors.primary,
          ),
        ),
        const VerticalSpace(height: 10),
      ],
    );
  }
}
