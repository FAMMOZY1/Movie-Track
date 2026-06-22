import 'package:flutter/material.dart';
import 'package:movie_track/core/theme/app_color.dart';
import 'package:movie_track/core/theme/app_space.dart';
import 'package:movie_track/core/theme/app_text.dart';

/// Builds the app [ThemeData] from design tokens.
class AppTheme {
  AppTheme._();

  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Inter',
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColor.background,
      colorScheme: const ColorScheme.dark(
        primary: AppColor.primary,
        onPrimary: AppColor.white,
        surface: AppColor.surface,
        onSurface: AppColor.onSurface,
        surfaceContainer: AppColor.surfaceContainer,
        outline: AppColor.border,
        error: AppColor.error,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColor.background,
        surfaceTintColor: Colors.transparent,
        foregroundColor: AppColor.onSurface,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: AppText.appTitle.copyWith(color: AppColor.primaryBright),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColor.border,
        thickness: 1,
        space: 1,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColor.primary,
          foregroundColor: AppColor.white,
          elevation: 0,
          textStyle: AppText.button,
          padding: const EdgeInsets.symmetric(vertical: AppSpace.lg),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadiusToken.normal),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColor.surfaceContainerLow,
        hintStyle: AppText.bodyMd.copyWith(color: AppColor.textMuted),
        contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSpace.lg, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadiusToken.normal),
          borderSide: const BorderSide(color: AppColor.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadiusToken.normal),
          borderSide: const BorderSide(color: AppColor.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadiusToken.normal),
          borderSide: const BorderSide(color: AppColor.primary),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadiusToken.normal),
          borderSide: const BorderSide(color: AppColor.error),
        ),
      ),
      textTheme: const TextTheme(
        titleLarge: AppText.appTitle,
        titleMedium: AppText.sectionTitle,
        titleSmall: AppText.movieTitle,
        bodyMedium: AppText.bodyMd,
        bodySmall: AppText.metadata,
        labelSmall: AppText.labelCaps,
      ),
    );
  }
}
