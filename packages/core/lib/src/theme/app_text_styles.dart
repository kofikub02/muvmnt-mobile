import 'package:flutter/material.dart';
import 'app_fonts.dart';

class AppTextStyles {
  static const TextStyle bodyMedium = TextStyle(
    fontFamily: AppFonts.fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontFamily: AppFonts.fontFamily,
    fontSize: 15,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle bodySmall = TextStyle(
    fontFamily: AppFonts.fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle headlineMedium = TextStyle(
    fontFamily: AppFonts.fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle headlineLarge = TextStyle(
    fontFamily: AppFonts.fontFamily,
    fontSize: 32,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle headlineSmall = TextStyle(
    fontFamily: AppFonts.fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle button = TextStyle(
    fontFamily: AppFonts.fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );
}
