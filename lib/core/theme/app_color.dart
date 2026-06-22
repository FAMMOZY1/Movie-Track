import 'package:flutter/material.dart';

/// Cinematic Core color tokens. Use these only — never raw [Color] literals.
class AppColor {
  AppColor._();

  // Core surfaces ("Deep Night" foundation)
  static const Color background = Color(0xFF101415);
  static const Color surface = Color(0xFF101415);
  static const Color surfaceContainerLowest = Color(0xFF0B0F10);
  static const Color surfaceContainerLow = Color(0xFF191C1E);
  static const Color surfaceContainer = Color(0xFF1D2022);
  static const Color surfaceContainerHigh = Color(0xFF272A2C);
  static const Color surfaceContainerHighest = Color(0xFF323537);

  // Text tiers
  static const Color onSurface = Color(0xFFE0E3E5);
  static const Color onSurfaceVariant = Color(0xFFC2C6D6);
  static const Color textMuted = Color(0xFF8C909F);

  // Borders ("blueprint" 1px stroke)
  static const Color outline = Color(0xFF8C909F);
  static const Color outlineVariant = Color(0xFF424754);
  static const Color border = Color(0xFF263244);

  // Functional accents
  static const Color primary = Color(0xFF4D8EFF); // action blue
  static const Color primaryBright = Color(0xFFADC6FF);
  static const Color onPrimary = Color(0xFF002E6A);
  static const Color rating = Color(0xFFEEC200); // value yellow
  static const Color ratingBright = Color(0xFFFFE083);
  static const Color ratingBadge = Color(0xFFFACC15);
  static const Color onRating = Color(0xFF3C2F00);

  // Error
  static const Color error = Color(0xFFFFB4AB);
  static const Color errorContainer = Color(0xFF93000A);
  static const Color onError = Color(0xFF690005);
  static const Color white = Color(0xFFFFFFFF);
}
