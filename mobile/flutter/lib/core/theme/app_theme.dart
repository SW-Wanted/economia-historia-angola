import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/app_colors.dart';

class AppTheme {
  const AppTheme._();

  /// Configura a tipografia para funcionar online e offline.
  ///
  /// O pacote google_fonts descarrega as fontes (Plus Jakarta Sans / Lexend)
  /// pela internet em tempo de execução, garantindo a tipografia exata do
  /// design em qualquer máquina, sem ser preciso empacotar ficheiros locais.
  /// Quando não há ligação, o download é simplesmente ignorado e a aplicação
  /// recorre à fonte do sistema — pelo que continua a funcionar offline.
  /// Deve ser chamado uma vez no arranque (main()).
  static void configureFonts() {
    // Permite obter as fontes pela internet (consistência entre sistemas).
    GoogleFonts.config.allowRuntimeFetching = true;
  }

  // Tipografia do Design System (Plus Jakarta Sans p/ titulos, Lexend p/ corpo).
  static TextStyle _heading(double size, FontWeight weight, {double? height, double? spacing}) =>
      GoogleFonts.plusJakartaSans(fontSize: size, fontWeight: weight, height: height, letterSpacing: spacing, color: AppColors.text);

  static TextStyle _body(double size, {FontWeight weight = FontWeight.w400, double? height, double? spacing}) =>
      GoogleFonts.lexend(fontSize: size, fontWeight: weight, height: height, letterSpacing: spacing, color: AppColors.text);

  static ThemeData light() {
    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.light,
      primary: AppColors.primary,
      surface: AppColors.surface,
      error: AppColors.error,
    );

    // Base de tipografia NATIVA (nunca nula), independente de rede.
    // O google_fonts é aplicado por cima nos estilos principais; se o
    // download falhar (offline), cada estilo mantém um valor válido do
    // sistema e a app não rebenta com "Unexpected null value".
    final base = Typography.material2021(platform: TargetPlatform.android)
        .black
        .apply(bodyColor: AppColors.text, displayColor: AppColors.text);

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: AppColors.background,
      textTheme: base.copyWith(
        displayLarge: _heading(30, FontWeight.w800, height: 1.26, spacing: -0.6),
        headlineMedium: _heading(22, FontWeight.w700, height: 1.27),
        titleLarge: _heading(18, FontWeight.w700, height: 1.33),
        bodyLarge: _body(16, height: 1.5),
        bodyMedium: _body(14, height: 1.42),
        labelMedium: _body(12, weight: FontWeight.w600, height: 1.33, spacing: 0.1),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.text,
        centerTitle: true,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: _heading(18, FontWeight.w700),
      ),
      chipTheme: ChipThemeData(
        labelStyle: _body(13, weight: FontWeight.w600),
        side: const BorderSide(color: AppColors.outlineVariant),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(99)),
      ),
      snackBarTheme: const SnackBarThemeData(behavior: SnackBarBehavior.floating),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        hintStyle: _body(14, weight: FontWeight.w400).copyWith(color: AppColors.secondary),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.outlineVariant)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.outlineVariant)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.primary, width: 1.5)),
      ),
    );
  }
}
