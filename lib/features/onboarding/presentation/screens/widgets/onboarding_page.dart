import 'package:flutter/cupertino.dart';
import 'package:tabibi/core/style/spacing/vertical_space.dart';
import 'package:tabibi/core/utils/constants/app_dimensions.dart';
import 'package:tabibi/core/utils/constants/app_padding.dart';
import 'package:tabibi/core/utils/constants/sizes.dart';

class OnboardingPage extends StatelessWidget {
  final String? image;
  final String? title;
  final String? description;
  const OnboardingPage({super.key, this.image, this.description, this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: AppHeight.h532,
          width: AppWidth.w390,
          child: Image.asset(image!, fit: BoxFit.fill),
        ),
         VerticalSpace(height: AppHeight.h28_5),
        Center(
          child: Text(
            title!,
            style: const TextStyle(
              fontSize: AppSizes.fontSizeLg,
              fontWeight: FontWeight.w700,
              color: Color(0xff374151),
            ),
          ),
        ),
         VerticalSpace(height: AppHeight.h8),
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppPadding.p40),
            child: Text(
              description!,
              style: const TextStyle(
                color: Color(0xff6B7280),
                fontSize: AppSizes.fonAppSizesm,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }
}
