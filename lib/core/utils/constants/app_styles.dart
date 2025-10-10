import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// A utility class that holds all the text styles for the app.
class AppTextStyle {
  // To prevent instantiation of this class.
  AppTextStyle._();

  // --- BASE STYLES ---
  static final TextStyle _baseInter = GoogleFonts.inter();
  static final TextStyle _basePoppins = GoogleFonts.poppins();

  // --- HEADING STYLES ---

  /// Style for H1 headings. (Inter, 20, Bold)
  static final TextStyle h1 = _baseInter.copyWith(
    fontSize: 20,
    fontWeight: FontWeight.w600 ,
       height: 1.5,
  );

  /// Style for H2 headings. (Inter, 18, Bold)
  static final TextStyle h2 = _baseInter.copyWith(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    height: 1.5,
  );

  /// Style for H3 headings. (Inter, 16, Bold)
  static final TextStyle h3 = _baseInter.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    height: 1.5,
  );

  /// Style for H4 headings. (Inter, 14, Bold)
  static final TextStyle h4 = _baseInter.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    height: 1.5,
  );

  // --- BODY STYLES ---

  /// Body-XL (Inter, 18, Regular)
  static final TextStyle bodyXl = _baseInter.copyWith(
    fontSize: 18,
    fontWeight: FontWeight.w400, // Regular
    height: 1.5,
  );

  /// Body-LG (Inter, 16, SemiBold)
  static final TextStyle bodyLg = _baseInter.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w600, // SemiBold
    height: 1.5,
  );

  /// Body-S-Bold (Inter, 14, Bold)
  static final TextStyle bodySBold = _baseInter.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w700, // Bold
    height: 1.5,
  );

  /// Body-S-SemiBold (Inter, 14, SemiBold)
  static final TextStyle bodySSemiBold = _baseInter.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w600, // SemiBold
    height: 1,
  );

  /// Body-S-Medium (Inter, 14, Medium)
  static final TextStyle bodySMedium = _baseInter.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w500, // Medium
    height: 1,
  );

  /// Body-S-Regular (Inter, 14, Regular)
  static final TextStyle bodySRegular = _baseInter.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w400, // Regular
    height: 1,
  );

  /// Body-XS-Bold (Poppins, 12, Bold)
  static final TextStyle bodyXsBold = _basePoppins.copyWith(
    fontSize: 12,
    fontWeight: FontWeight.w700, // Bold
    height: 1.5,
  );

  /// Body-XS-SemiBold (Poppins, 12, SemiBold)
  static final TextStyle bodyXsSemiBold = _basePoppins.copyWith(
    fontSize: 12,
    fontWeight: FontWeight.w600, // SemiBold
    height: 1.5,
  );

  /// Body-XS-Medium (Poppins, 12, Medium)
  static final TextStyle bodyXsMedium = _basePoppins.copyWith(
    fontSize: 12,
    fontWeight: FontWeight.w500, // Medium
    height: 1.5,
  );

  /// Body-XS-Regular (Poppins, 12, Regular)
  static final TextStyle bodyXsRegular = _basePoppins.copyWith(
    fontSize: 12,
    fontWeight: FontWeight.w400, // Regular
    height: 1.5,
  );
  // --- BUTTON STYLE ---

  /// Style for Buttons. (Inter, 16, Medium)
  static final TextStyle button = _baseInter.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w500, // Medium
    height: 1,
  );
}