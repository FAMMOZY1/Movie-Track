import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:movie_track/core/theme/export.dart';

void main() {
  test('App theme is dark cinematic', () {
    final theme = AppTheme.theme;
    expect(theme.brightness, Brightness.dark);
    expect(theme.scaffoldBackgroundColor, AppColor.background);
  });
}
