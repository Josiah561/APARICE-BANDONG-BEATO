import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

/// Colour tokens. Yellow "marker" always means "saved".
/// Each author (1-10) has their own colour, used on cards and headers.
class AppColors {
  static const paper = Color(0xFFF2F4FA);
  static const surface = Color(0xFFFFFFFF);
  static const ink = Color(0xFF0E1530);
  static const muted = Color(0xFF626B85);
  static const line = Color(0xFFDDE2EE);
  static const primary = Color(0xFF2D4BE0);
  static const marker = Color(0xFFFFE361);
  static const sticky = Color(0xFFFFF4B8);
  static const success = Color(0xFF1E7A50);
  static const danger = Color(0xFFC0392B);

  static const authors = <Color>[
    Color(0xFF2D4BE0), // 1 cobalt
    Color(0xFF0E8A8A), // 2 teal
    Color(0xFFE4572E), // 3 coral
    Color(0xFF7A3FE0), // 4 violet
    Color(0xFF2E7D4F), // 5 forest
    Color(0xFFD32F7A), // 6 magenta
    Color(0xFFC77700), // 7 amber
    Color(0xFF0288D1), // 8 sky
    Color(0xFF8E2C5B), // 9 plum
    Color(0xFF455A64), // 10 slate
  ];

  static Color author(int n) => authors[(n - 1) % authors.length];
}

/// Type tokens: Bricolage Grotesque for headings and UI,
/// Source Serif 4 for text meant to be read.
class AppText {
  static TextStyle heading(double size,
          {Color color = AppColors.ink, double height = 1.2}) =>
      GoogleFonts.bricolageGrotesque(
        fontSize: size,
        fontWeight: FontWeight.w800,
        height: height,
        letterSpacing: -0.4,
        color: color,
      );

  static TextStyle ui(double size,
          {Color color = AppColors.ink,
          FontWeight weight = FontWeight.w500,
          double height = 1.3}) =>
      GoogleFonts.bricolageGrotesque(
        fontSize: size,
        fontWeight: weight,
        height: height,
        color: color,
      );

  static TextStyle reading(double size,
          {Color color = AppColors.ink, double height = 1.55}) =>
      GoogleFonts.sourceSerif4(
        fontSize: size,
        fontWeight: FontWeight.w400,
        height: height,
        color: color,
      );
}

class AppTheme {
  static ThemeData light() {
    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.light,
    ).copyWith(
      primary: AppColors.primary,
      onPrimary: Colors.white,
      surface: AppColors.surface,
      onSurface: AppColors.ink,
      error: AppColors.danger,
      outline: AppColors.line,
    );
    final base = ThemeData(useMaterial3: true, colorScheme: scheme);

    OutlineInputBorder border(Color color, double width) => OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: color, width: width),
        );

    return base.copyWith(
      scaffoldBackgroundColor: AppColors.paper,
      textTheme: GoogleFonts.bricolageGrotesqueTextTheme(base.textTheme)
          .apply(bodyColor: AppColors.ink, displayColor: AppColors.ink),
      dividerColor: AppColors.line,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.ink,
        foregroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: AppText.heading(20, color: Colors.white),
        iconTheme: const IconThemeData(color: Colors.white),
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 4,
        extendedTextStyle: AppText.ui(15, weight: FontWeight.w700),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
          textStyle: AppText.ui(15.5, weight: FontWeight.w700),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          textStyle: AppText.ui(14.5, weight: FontWeight.w700),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.paper,
        labelStyle: AppText.ui(15, color: AppColors.muted),
        floatingLabelStyle:
            AppText.ui(14, color: AppColors.primary, weight: FontWeight.w600),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: border(Colors.transparent, 0),
        enabledBorder: border(Colors.transparent, 0),
        focusedBorder: border(AppColors.primary, 1.6),
        errorBorder: border(AppColors.danger, 1.2),
        focusedErrorBorder: border(AppColors.danger, 1.6),
      ),
    );
  }
}
