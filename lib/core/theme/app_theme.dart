import 'package:fitness_app/core/theme/text_styles.dart';
import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    primaryColor: AppColors.orange,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return AppColors.white;
          }
          return AppColors.orange;
        }),
        foregroundColor: WidgetStateProperty.all(AppColors.white),
        padding: WidgetStateProperty.all(
          EdgeInsets.symmetric(vertical: 10, horizontal: 24),
        ),
        minimumSize: WidgetStateProperty.all(Size(double.infinity, 48)),
        shape: WidgetStateProperty.resolveWith((states) {
          final color = states.contains(WidgetState.disabled)
              ? AppColors.white
              : AppColors.orange;
          return RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
            side: BorderSide(color: color),
          );
        }),
        textStyle: WidgetStateProperty.all(TextStyles.buttonTextStyle),
      ),
    ),
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: AppColors.orange,
      linearTrackColor: AppColors.orange,
      circularTrackColor: AppColors.orange,
    ),
    inputDecorationTheme: InputDecorationTheme(
      prefixIconConstraints: const BoxConstraints( maxHeight: 24, minWidth: 60,),
      suffixIconConstraints: const BoxConstraints( maxHeight: 24 ,minWidth: 60,),
      floatingLabelBehavior: FloatingLabelBehavior.always,
      filled: false,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide.none,
      ),
      labelStyle: TextStyles.labelTextFieldStyle,
      errorStyle: TextStyles.errorTextFieldStyle,
      hintStyle: TextStyles.hintTextFieldStyle,
      suffixStyle: TextStyles.hintTextFieldStyle,
      prefixStyle: TextStyles.hintTextFieldStyle,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(color: AppColors.white, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(color: AppColors.white, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(color: AppColors.red, width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(color: AppColors.red, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
    ),
  );
}
