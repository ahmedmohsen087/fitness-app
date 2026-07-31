import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'text_styles.dart';

class AppTheme {
  static final ButtonStyle authPrimaryButtonStyle = ButtonStyle(
    minimumSize: const WidgetStatePropertyAll(Size.zero),
    padding: const WidgetStatePropertyAll(
      EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    ),
    elevation: const WidgetStatePropertyAll(0),
    foregroundColor: const WidgetStatePropertyAll(AppColors.white),
    backgroundColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.disabled)) return AppColors.lightGray;
      return AppColors.orange;
    }),
    shape: WidgetStatePropertyAll(
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
    textStyle: WidgetStatePropertyAll(TextStyles.authButton),
  );

  static InputDecoration authInputDecoration({
    required String hintText,
    required Widget prefixIcon,
    Widget? suffixIcon,
  }) {
    const border = OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(20)),
      borderSide: BorderSide(color: AppColors.grey),
    );

    return InputDecoration(
      isDense: true,
      hintText: hintText,
      hintStyle: TextStyles.authField,
      prefixIcon: prefixIcon,
      prefixIconConstraints: const BoxConstraints.tightFor(
        width: 44,
        height: 20,
      ),
      suffixIcon: suffixIcon,
      suffixIconConstraints: const BoxConstraints.tightFor(
        width: 36,
        height: 20,
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 8),
      enabledBorder: border,
      focusedBorder: border.copyWith(
        borderSide: const BorderSide(color: AppColors.white),
      ),
      errorBorder: border.copyWith(
        borderSide: const BorderSide(color: AppColors.red),
      ),
      focusedErrorBorder: border.copyWith(
        borderSide: const BorderSide(color: AppColors.red),
      ),
    );
  }

  static InputDecoration roundedInputDecoration({
    required String hintText,
    required IconData prefixIcon,
    Widget? suffixIcon,
  }) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(25),
      borderSide: BorderSide(
        color: AppColors.white.withValues(alpha: .3),
        width: 1,
      ),
    );

    return InputDecoration(
      filled: true,
      fillColor: AppColors.black.withValues(alpha: .25),
      hintText: hintText,
      hintStyle: TextStyle(
        color: AppColors.white.withValues(alpha: .5),
        fontSize: 14,
      ),
      prefixIcon: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14.0),
        child: Icon(
          prefixIcon,
          color: AppColors.white.withValues(alpha: .6),
          size: 18,
        ),
      ),
      suffixIcon: suffixIcon,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      enabledBorder: border,
      focusedBorder: border.copyWith(
        borderSide: const BorderSide(color: AppColors.orange, width: 1.5),
      ),
      errorBorder: border.copyWith(
        borderSide: const BorderSide(color: AppColors.red, width: 1.5),
      ),
      focusedErrorBorder: border.copyWith(
        borderSide: const BorderSide(color: AppColors.red, width: 2),
      ),
    );
  }

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
      prefixIconConstraints: const BoxConstraints(maxHeight: 24, minWidth: 60),
      suffixIconConstraints: const BoxConstraints(maxHeight: 24, minWidth: 60),
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
