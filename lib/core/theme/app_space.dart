/// Spacing & radius tokens (8px grid). Use these — no magic numbers.
class AppSpace {
  AppSpace._();

  // Spacing
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 32;

  static const double containerMargin = 16;
  static const double cardGutter = 12;
  static const double sectionPadding = 32;
}

/// Corner-radius tokens.
class AppRadiusToken {
  AppRadiusToken._();

  static const double sm = 4;
  static const double normal = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double full = 9999;
}
