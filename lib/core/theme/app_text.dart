import 'package:flutter/material.dart';
import 'package:movie_track/core/theme/app_color.dart';

/// Named text-style tokens (Inter scale). Use these — no raw [TextStyle].
class AppText {
  AppText._();

  static const String _family = 'Inter';

  // app-title 20/700
  static const TextStyle appTitle = TextStyle(
    fontFamily: _family,
    fontSize: 20,
    fontWeight: FontWeight.w700,
    height: 28 / 20,
    letterSpacing: -0.4,
    color: AppColor.onSurface,
  );

  // section-title 18/700
  static const TextStyle sectionTitle = TextStyle(
    fontFamily: _family,
    fontSize: 18,
    fontWeight: FontWeight.w700,
    height: 24 / 18,
    letterSpacing: -0.18,
    color: AppColor.onSurface,
  );

  // movie-title 16/600
  static const TextStyle movieTitle = TextStyle(
    fontFamily: _family,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 22 / 16,
    color: AppColor.onSurface,
  );

  // body-md 14/400
  static const TextStyle bodyMd = TextStyle(
    fontFamily: _family,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 20 / 14,
    color: AppColor.onSurfaceVariant,
  );

  // metadata 12/400 muted
  static const TextStyle metadata = TextStyle(
    fontFamily: _family,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 16 / 12,
    color: AppColor.textMuted,
  );

  // label-caps 10/700
  static const TextStyle labelCaps = TextStyle(
    fontFamily: _family,
    fontSize: 10,
    fontWeight: FontWeight.w700,
    height: 12 / 10,
    letterSpacing: 0.5,
    color: AppColor.textMuted,
  );

  // button 14/600
  static const TextStyle button = TextStyle(
    fontFamily: _family,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.14,
  );
}
