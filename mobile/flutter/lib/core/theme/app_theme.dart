import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class AppTheme {
  const AppTheme._();

  static ThemeData light() {
    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.light,
      primary: AppColors.primary,
      surface: AppColors.surface,
      error: AppColors.error,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: AppColors.background,
      fontFamily: 'Lexend',
      textTheme: const TextTheme(
        displayLarge: TextStyle(fontFamily: 'Plus Jakarta Sans', fontSize: 30, height: 1.26, fontWeight: FontWeight.w800, color: AppColors.text),
        headlineMedium: TextStyle(fontFamily: 'Plus Jakarta Sans', fontSize: 22, height: 1.27, fontWeight: FontWeight.w700, color: AppColors.text),
        titleLarge: TextStyle(fontFamily: 'Plus Jakarta Sans', fontSize: 18, height: 1.33, fontWeight: FontWeight.w700, color: AppColors.text),
        bodyLarge: TextStyle(fontSize: 16, height: 1.5, color: AppColors.text),
        bodyMedium: TextStyle(fontSize: 14, height: 1.42, color: AppColors.text),
        labelMedium: TextStyle(fontSize: 12, height: 1.33, fontWeight: FontWeight.w600, color: AppColors.text),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.text,
        centerTitle: true,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.outlineVariant)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.outlineVariant)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.primary, width: 1.5)),
      ),
    );
  }
}
