import 'package:flutter/material.dart';

/// The warm, editorial palette used across the mobile bookstore.
///
/// Legacy field names are retained while the screens are refined.
class AppColors {
  AppColors._();

  // Canvas & surfaces
  static const Color background = Color(0xFFF4F3F1);
  static const Color surface = Color(0xFFFFFEFC);
  static const Color surfaceElevated = Color(0xFFEEE9E1);
  static const Color surfaceHighlight = Color(0xFFE5C69B);

  // Borders & Dividers
  static const Color borderSubtle = Color(0xFFE4DED5);
  static const Color borderDefault = Color(0xFFD4CBC0);
  static const Color borderStrong = Color(0xFFB8AA9A);

  // Warm bookstore brown accent, replacing the dashboard red.
  static const Color primaryRed = Color(0xFFB74F18);
  static const Color primaryRedLight = Color(0xFFB59C73);
  static const Color primaryRedDark = Color(0xFF573E3B);
  static const Color primaryRedMuted = Color(0x1FB74F18);
  static const Color primaryRedGlow = Color(0x26B74F18);

  // Typography & Text
  static const Color textPrimary = Color(0xFF090707);
  static const Color textSecondary = Color(0xFF573E3B);
  static const Color textMuted = Color(0xFF827A73);
  static const Color textDisabled = Color(0xFFB8B1AA);

  // Form Inputs
  static const Color inputBackground = Color(0xFFFFFEFC);
  static const Color inputBorder = Color(0xFFDCD4CA);
  static const Color inputBorderFocused = Color(0xFFB74F18);
  static const Color inputPlaceholder = Color(0xFF9B938B);

  // Status & Accents
  static const Color error = Color(0xFFB42318);
  static const Color success = Color(0xFF3F7D4D);
  static const Color warning = Color(0xFFB7791F);
  static const Color info = Color(0xFF526A7A);
}
