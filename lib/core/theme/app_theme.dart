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
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: AppColors.lightBlack,
      showUnselectedLabels: true,
      showSelectedLabels: true,
      type: BottomNavigationBarType.fixed,
      selectedIconTheme: IconThemeData(color: AppColors.orange),
      unselectedIconTheme: IconThemeData(color: AppColors.white),
      selectedLabelStyle: TextStyles.bodyRegular12.copyWith(
        color: AppColors.orange,
      ),
      unselectedLabelStyle: TextStyles.bodyRegular12.copyWith(
        color: AppColors.white,
      ),
    ),
  );
}
