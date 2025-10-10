import 'package:flutter/widgets.dart';

class AppBorderRadius {
  AppBorderRadius._();

  static const BorderRadius r8 = BorderRadius.all(Radius.circular(8));
  static const BorderRadius r12 = BorderRadius.all(Radius.circular(12));
  static const BorderRadius r15 = BorderRadius.all(Radius.circular(15));
  static const BorderRadius r20 = BorderRadius.all(Radius.circular(20));
  static const BorderRadius r66 = BorderRadius.all(Radius.circular(66));
  // convenience for RoundedRectangleBorder constructors
  static BorderRadiusGeometry circular8() => BorderRadius.circular(8);
  static BorderRadiusGeometry circular12() => BorderRadius.circular(12);
}
