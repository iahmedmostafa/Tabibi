
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibi/core/style/spacing/vertical_space.dart';
import 'package:tabibi/core/utils/constants/app_images.dart';

class CustomContainer extends StatelessWidget {
  const CustomContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image(image: AssetImage(AppImages.carouselImage),width: double.infinity,
          height: 260.h,fit: BoxFit.fill ,),
        Positioned(
          left: 0,
          top: 0,height:100.h ,width:200.w,
          child: Image.asset(AppImages.layer1),),
        Positioned(
          left: 10,
          bottom: 0,height:50.h ,width:220.w,
          child: Image.asset(AppImages.layer2,),),
        Positioned(
            child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const VerticalSpace(height: 57),
              Text("Balance",style: TextStyle(color: Color(0xffFDFDFD).withOpacity(.7)),),
              const VerticalSpace(height: 8),
              Text("23400 EG",style: TextStyle(color: Colors.white,fontSize: 24.sp),),

            ],
          ),
        )),


      ],
    );
  }
}
