import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_typography.dart';

final appTheme = ThemeData(
  useMaterial3: true,
  primaryColor: AppColors.primary,
  scaffoldBackgroundColor: AppColors.background,
  textTheme: TextTheme(
    displayLarge: AppTypography.displayLarge,
    displayMedium: AppTypography.displayMedium,
    displaySmall: AppTypography.displaySmall,
    headlineLarge: AppTypography.displayLargeBold,
    headlineMedium: AppTypography.displayMediumBold,
    headlineSmall: AppTypography.displaySmallBold,
    bodyLarge: AppTypography.textLarge,
    bodyMedium: AppTypography.textMedium,
    bodySmall: AppTypography.textSmall,
    labelLarge: AppTypography.linkLarge,
    labelMedium: AppTypography.linkMedium,
    labelSmall: AppTypography.linkSmall,
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: AppColors.primary,
    titleTextStyle: AppTypography.displayMediumBold.copyWith(
      color: Colors.white,
    ),
  ),
  buttonTheme: ButtonThemeData(
    buttonColor: AppColors.primary,
    textTheme: ButtonTextTheme.primary,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primary,
      textStyle: AppTypography.textMedium.copyWith(color: Colors.white),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: AppColors.inputBackground,
    border: OutlineInputBorder(
      borderSide: BorderSide(color: AppColors.line),
    ),
  ),
);
