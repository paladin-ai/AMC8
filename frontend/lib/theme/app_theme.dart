import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Brand colors (align with product spec; Figma Make was not readable via API).
abstract final class Amc8BrandColors {
  Amc8BrandColors._();

  static const Color primary = Color(0xFF7C3AED);
  static const Color secondary = Color(0xFF10B981);
}

/// Light / dark [ThemeData] for Material 3 (used app-wide including login).
abstract final class Amc8AppTheme {
  Amc8AppTheme._();

  static ThemeData light() {
    final baseScheme = ColorScheme.fromSeed(
      seedColor: Amc8BrandColors.primary,
      brightness: Brightness.light,
    );
    final scheme = baseScheme.copyWith(
      primary: Amc8BrandColors.primary,
      onPrimary: Colors.white,
      secondary: Amc8BrandColors.secondary,
      onSecondary: Colors.white,
    );

    final base = ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      brightness: Brightness.light,
    );

    return _applyCommon(
      base,
      scheme,
      scaffoldBackground: const Color(0xFFF5F5F7),
    );
  }

  static ThemeData dark() {
    final baseScheme = ColorScheme.fromSeed(
      seedColor: Amc8BrandColors.primary,
      brightness: Brightness.dark,
    );
    final scheme = baseScheme.copyWith(
      primary: const Color(0xFF8B5CF6),
      onPrimary: Colors.white,
      secondary: const Color(0xFF34D399),
      onSecondary: const Color(0xFF022C22),
      surface: const Color(0xFF121212),
    );

    final base = ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      brightness: Brightness.dark,
    );

    return _applyCommon(base, scheme);
  }

  static ThemeData _applyCommon(
    ThemeData base,
    ColorScheme scheme, {
    Color? scaffoldBackground,
  }) {
    final textTheme = GoogleFonts.interTextTheme(base.textTheme);

    return base.copyWith(
      textTheme: textTheme,
      scaffoldBackgroundColor: scaffoldBackground ?? scheme.surface,
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surfaceContainerHighest.withValues(alpha: 0.35),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: scheme.outline.withValues(alpha: 0.5)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: scheme.outline.withValues(alpha: 0.5)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: scheme.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: scheme.error, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: scheme.error, width: 2),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          elevation: 2,
          shadowColor: scheme.primary.withValues(alpha: 0.35),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          side: BorderSide(color: scheme.outline.withValues(alpha: 0.6)),
        ),
      ),
    );
  }
}
