import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData getLightTheme([ColorScheme? dynamicScheme]) {
    final scheme = dynamicScheme ?? const ColorScheme(
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
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: scheme,
      scaffoldBackgroundColor: scheme.surface,
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: IconThemeData(color: scheme.onSurface),
        titleTextStyle: TextStyle(
          color: scheme.onSurface,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.5,
        ),
      ),
      cardTheme: CardThemeData(
        color: scheme.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: scheme.outline, width: 1),
        ),
      ),
      textTheme: TextTheme(
        displayLarge: TextStyle(color: scheme.onSurface, fontWeight: FontWeight.bold, letterSpacing: -1.0),
        displayMedium: TextStyle(color: scheme.onSurface, fontWeight: FontWeight.bold, letterSpacing: -0.5),
        displaySmall: TextStyle(color: scheme.onSurface, fontWeight: FontWeight.bold),
        titleLarge: TextStyle(color: scheme.onSurface, fontWeight: FontWeight.w600),
        bodyLarge: TextStyle(color: scheme.onSurface, height: 1.6),
        bodyMedium: TextStyle(color: scheme.onSurface, height: 1.6),
        bodySmall: TextStyle(color: scheme.onSurface.withOpacity(0.7), height: 1.4),
      ),
    );
  }

  static ThemeData getDarkTheme([ColorScheme? dynamicScheme]) {
    final scheme = dynamicScheme ?? const ColorScheme(
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
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: scheme,
      scaffoldBackgroundColor: scheme.surface,
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: IconThemeData(color: scheme.onSurface),
        titleTextStyle: TextStyle(
          color: scheme.onSurface,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.5,
        ),
      ),
      cardTheme: CardThemeData(
        color: scheme.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: scheme.outline, width: 1),
        ),
      ),
      textTheme: TextTheme(
        displayLarge: TextStyle(color: scheme.onSurface, fontWeight: FontWeight.bold, letterSpacing: -1.0),
        displayMedium: TextStyle(color: scheme.onSurface, fontWeight: FontWeight.bold, letterSpacing: -0.5),
        displaySmall: TextStyle(color: scheme.onSurface, fontWeight: FontWeight.bold),
        titleLarge: TextStyle(color: scheme.onSurface, fontWeight: FontWeight.w600),
        bodyLarge: TextStyle(color: scheme.onSurface, height: 1.6),
        bodyMedium: TextStyle(color: scheme.onSurface, height: 1.6),
        bodySmall: TextStyle(color: scheme.onSurface.withOpacity(0.7), height: 1.4),
      ),
    );
  }
}
