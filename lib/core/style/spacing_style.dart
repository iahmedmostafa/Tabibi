import 'package:flutter/widgets.dart';
import 'package:tabibi/core/utils/constants/sizes.dart';

class SpacingStyle {
  static const EdgeInsets defaultPadding = EdgeInsets.only(
    left: AppSizes.defaultSpace,
    right: AppSizes.defaultSpace,
    bottom: AppSizes.defaultSpace,
  );

  static const EdgeInsets defaultPaddingWithTop = EdgeInsets.only(
    left: AppSizes.defaultSpace,
    right: AppSizes.defaultSpace,
    bottom: AppSizes.defaultSpace,
    top: AppSizes.appBarHeight,
  );
}
