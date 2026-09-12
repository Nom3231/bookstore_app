import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    final baseTextTheme = Typography.material2021().black;
    final textTheme = GoogleFonts.dmSansTextTheme(baseTextTheme).copyWith(
      displayLarge: GoogleFonts.playfairDisplay(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
        height: 1.08,
      ),
      headlineMedium: GoogleFonts.playfairDisplay(
        fontSize: 25,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
        height: 1.14,
      ),
      titleLarge: GoogleFonts.playfairDisplay(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
      titleMedium: GoogleFonts.dmSans(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
      bodyLarge: GoogleFonts.dmSans(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        color: AppColors.textPrimary,
        height: 1.5,
      ),
      bodyMedium: GoogleFonts.dmSans(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
        height: 1.4,
      ),
      bodySmall: GoogleFonts.dmSans(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: AppColors.textMuted,
      ),
      labelLarge: GoogleFonts.dmSans(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
        letterSpacing: 0.2,
      ),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primaryRed,
        onPrimary: Colors.white,
        primaryContainer: AppColors.primaryRedMuted,
        onPrimaryContainer: AppColors.textPrimary,
        secondary: AppColors.primaryRedLight,
        onSecondary: AppColors.textPrimary,
        surface: AppColors.surface,
        onSurface: AppColors.textPrimary,
        error: AppColors.error,
        onError: Colors.white,
      ),
      textTheme: textTheme,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: AppColors.textPrimary),
      ),
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.borderSubtle, width: 1),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.borderSubtle,
        thickness: 1,
        space: 1,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.inputBackground,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        hintStyle: const TextStyle(
          color: AppColors.inputPlaceholder,
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
        labelStyle: const TextStyle(
          color: AppColors.textSecondary,
          fontSize: 14,
        ),
        prefixIconColor: AppColors.textMuted,
        suffixIconColor: AppColors.textMuted,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.inputBorder, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.inputBorder, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.primaryRed, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.error, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.error, width: 1.5),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryRed,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(52),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.textPrimary,
          minimumSize: const Size.fromHeight(50),
          side: const BorderSide(color: AppColors.borderDefault, width: 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primaryRedLight,
          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primaryRed;
          }
          return Colors.transparent;
        }),
        side: const BorderSide(color: AppColors.borderStrong, width: 1.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
    );
  }

  // Compatibility alias for screens created before the visual refresh.
  static ThemeData get darkTheme => lightTheme;
}
