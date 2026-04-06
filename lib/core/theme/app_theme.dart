import 'package:flutter/material.dart';

class AppColors {
  static const background = Color(0xFF0D0D0D);
  static const base = Color(0xFF151515);
  static const lightShadow = Color(0xFF1F1F1F);
  static const darkShadow = Color(0xFF000000);
  static const primary = Color(0xFF3F0759);
  static const accent = Color(0xFF7C5CFF);
  static const text = Color(0xFFE5E5E5);
  static const subtext = Color(0xFF888888);
}

class AppTheme {
  static ThemeData dark() {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        secondary: AppColors.accent,
        surface: AppColors.base,
      ),
      cardColor: AppColors.base,
      textTheme: const TextTheme(
        headlineSmall: TextStyle(
          color: AppColors.text,
          fontWeight: FontWeight.w700,
          fontSize: 24,
        ),
        titleMedium: TextStyle(
          color: AppColors.text,
          fontWeight: FontWeight.w600,
        ),
        bodyMedium: TextStyle(
          color: AppColors.text,
          fontSize: 15,
        ),
        bodySmall: TextStyle(
          color: AppColors.subtext,
          fontSize: 13,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: const TextStyle(color: AppColors.subtext),
        filled: true,
        fillColor: AppColors.base,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
      useMaterial3: true,
    );
  }
}
