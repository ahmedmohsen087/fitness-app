import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

abstract class TextStyles {
  static final TextStyle authGreeting = GoogleFonts.balooThambi2(
    fontSize: 18,
    fontWeight: FontWeight.w400,
    height: 1.4,
    color: AppColors.white,
  );

  static final TextStyle authHeadline = GoogleFonts.balooThambi2(
    fontSize: 20,
    fontWeight: FontWeight.w800,
    height: 1.4,
    color: AppColors.white,
  );

  static final TextStyle authTitle = GoogleFonts.balooThambi2(
    fontSize: 24,
    fontWeight: FontWeight.w800,
    height: 1.4,
    color: AppColors.white,
  );

  static final TextStyle authSubtitle = GoogleFonts.balooThambi2(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.4,
    color: AppColors.white,
  );

  static final TextStyle authField = GoogleFonts.balooThambi2(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.4,
    color: AppColors.lightGray,
  );

  static final TextStyle authOption = GoogleFonts.balooThambi2(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    height: 1.4,
    color: AppColors.white,
  );

  static final TextStyle authButton = GoogleFonts.balooThambi2(
    fontSize: 14,
    fontWeight: FontWeight.w800,
    color: AppColors.white,
  );

  static final TextStyle authFooter = GoogleFonts.balooThambi2(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.4,
    color: AppColors.white,
  );

  static final TextStyle authFooterLink = GoogleFonts.balooThambi2(
    fontSize: 14,
    fontWeight: FontWeight.w800,
    height: 1.4,
    color: AppColors.orange,
    decoration: TextDecoration.underline,
    decorationColor: AppColors.orange,
  );

  static final TextStyle authStep = GoogleFonts.balooThambi2(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.4,
    color: AppColors.white,
  );

  static final TextStyle authPickerUnit = GoogleFonts.balooThambi2(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.4,
    color: AppColors.orange,
  );

  static final TextStyle authPickerValue = GoogleFonts.balooThambi2(
    fontSize: 44,
    fontWeight: FontWeight.w800,
    height: 1.4,
    color: AppColors.orange,
  );

  static final TextStyle appBarTextStyle = GoogleFonts.balooThambi2(
    fontSize: 20,
    fontWeight: FontWeight.w500,
    color: AppColors.black,
  );

  static const TextStyle textFieldTextStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.black,
    letterSpacing: 0.5,
  );

  static final TextStyle buttonTextStyle = GoogleFonts.balooThambi2(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: AppColors.white,
  );
  static final TextStyle bodyRegular24 = GoogleFonts.balooThambi2(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.white,
  );
  static final TextStyle bodyRegular16 = GoogleFonts.balooThambi2(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.lightGray,
  );
  static final TextStyle bodyRegular20 = GoogleFonts.balooThambi2(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppColors.white,
  );

  static final TextStyle bodyRegular11 = GoogleFonts.balooThambi2(
    fontSize: 11,
    fontWeight: FontWeight.w400,
    color: AppColors.black,
  );

  static final TextStyle bodyRegular12 = GoogleFonts.balooThambi2(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.black,
  );
  static final TextStyle textRegular12 = GoogleFonts.balooThambi2(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: AppColors.orange,
  );
  static final TextStyle bodyRegular13 = GoogleFonts.balooThambi2(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: AppColors.black,
  );
  static final TextStyle bodyRegularUnderLine13 = GoogleFonts.balooThambi2(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: AppColors.black,
    decoration: TextDecoration.underline,
    decorationColor: AppColors.black,
  );
  static final TextStyle bodyRegular14 = GoogleFonts.balooThambi2(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.black,
  );

  static final TextStyle bodyMedium18 = GoogleFonts.balooThambi2(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: AppColors.black,
  );

  static final TextStyle labelTextFieldStyle = GoogleFonts.balooThambi2(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.white,
  );

  static final TextStyle hintTextFieldStyle = GoogleFonts.balooThambi2(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.white,
    letterSpacing: 0.5,
  );
  static final TextStyle errorTextFieldStyle = GoogleFonts.balooThambi2(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.red,
  );
}
