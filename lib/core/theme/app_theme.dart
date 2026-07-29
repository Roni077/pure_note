import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: AppColors.primaryLight,
        onPrimary: AppColors.surfaceLight,
        secondary: AppColors.primaryLight,
        onSecondary: AppColors.surfaceLight,
        error: Colors.red,
        onError: Colors.white,
        surface: AppColors.surfaceLight,
        onSurface: AppColors.textPrimaryLight,
        outline: AppColors.borderLight,
      ),
      scaffoldBackgroundColor: AppColors.backgroundLight,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.backgroundLight,
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: IconThemeData(color: AppColors.textPrimaryLight),
        titleTextStyle: TextStyle(
          color: AppColors.textPrimaryLight,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.5,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.surfaceLight,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12), // Clean, not excessive
          side: const BorderSide(color: AppColors.borderLight, width: 1),
        ),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(color: AppColors.textPrimaryLight, fontWeight: FontWeight.bold, letterSpacing: -1.0),
        displayMedium: TextStyle(color: AppColors.textPrimaryLight, fontWeight: FontWeight.bold, letterSpacing: -0.5),
        displaySmall: TextStyle(color: AppColors.textPrimaryLight, fontWeight: FontWeight.bold),
        titleLarge: TextStyle(color: AppColors.textPrimaryLight, fontWeight: FontWeight.w600),
        bodyLarge: TextStyle(color: AppColors.textPrimaryLight, height: 1.6),
        bodyMedium: TextStyle(color: AppColors.textPrimaryLight, height: 1.6),
        bodySmall: TextStyle(color: AppColors.textSecondaryLight, height: 1.4),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme(
        brightness: Brightness.dark,
        primary: AppColors.primaryDark,
        onPrimary: AppColors.backgroundDark,
        secondary: AppColors.primaryDark,
        onSecondary: AppColors.backgroundDark,
        error: Colors.redAccent,
        onError: Colors.black,
        surface: AppColors.surfaceDark,
        onSurface: AppColors.textPrimaryDark,
        outline: AppColors.borderDark,
      ),
      scaffoldBackgroundColor: AppColors.backgroundDark,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.backgroundDark,
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: IconThemeData(color: AppColors.textPrimaryDark),
        titleTextStyle: TextStyle(
          color: AppColors.textPrimaryDark,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.5,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.surfaceDark,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: AppColors.borderDark, width: 1),
        ),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(color: AppColors.textPrimaryDark, fontWeight: FontWeight.bold, letterSpacing: -1.0),
        displayMedium: TextStyle(color: AppColors.textPrimaryDark, fontWeight: FontWeight.bold, letterSpacing: -0.5),
        displaySmall: TextStyle(color: AppColors.textPrimaryDark, fontWeight: FontWeight.bold),
        titleLarge: TextStyle(color: AppColors.textPrimaryDark, fontWeight: FontWeight.w600),
        bodyLarge: TextStyle(color: AppColors.textPrimaryDark, height: 1.6),
        bodyMedium: TextStyle(color: AppColors.textPrimaryDark, height: 1.6),
        bodySmall: TextStyle(color: AppColors.textSecondaryDark, height: 1.4),
      ),
    );
  }
}
