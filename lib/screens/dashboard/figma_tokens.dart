import 'package:flutter/material.dart';

/// Design tokens for the AMC8 AI Tutor home screen.
///
/// **Figma:** The provided link uses Figma Make (`/make/...`), which the Figma
/// Files API (and this project’s MCP) does not support. Replace every value
/// below with the exact numbers from Figma Dev Mode when you export or open
/// the same layout as a Design file — do not guess in production.
abstract final class FigmaTokens {
  FigmaTokens._();

  // --- Layout ---
  static const double screenPaddingH = 20;
  static const double screenPaddingV = 24;
  static const double sectionGap = 24;
  static const double navGap = 8;
  static const double cardGap = 16;

  /// Max content width on large tablets / desktop.
  static const double contentMaxWidth = 1200;

  // --- Radii ---
  static const double radiusStatCard = 16;
  static const double radiusFeatureCard = 20;
  static const double radiusNavPill = 20;
  static const double radiusIconCircle = 22;

  // --- Borders ---
  static const double statBorderWidth = 2;
  static const double featureBorderWidth = 1;

  // --- Typography (logical px) ---
  static const double welcomeTitleSize = 24;
  static const double welcomeSubtitleSize = 16;
  static const double navLabelSize = 14;
  static const double statLabelSize = 14;
  static const double statValueSize = 28;
  static const double statHintSize = 12;
  static const double featureTitleSize = 16;
  static const double featureSubtitleSize = 13;

  // --- Colors (replace with Figma hex) ---
  static const Color pageBackground = Color(0xFFF5F5F7);
  static const Color cardSurface = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF111827);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textMuted = Color(0xFF9CA3AF);

  /// Top nav — selected pill (align with app primary #7C3AED).
  static const Color navSelectedBg = Color(0xFFF3E8FF);
  static const Color navSelectedFg = Color(0xFF7C3AED);
  static const Color navUnselectedFg = Color(0xFF6B7280);

  /// Stat card — purple border (Tests Taken).
  static const Color statPurpleBorder = Color(0xFF9333EA);
  static const Color statPurpleHint = Color(0xFF7C3AED);

  /// Stat card — green border (Average Score).
  static const Color statGreenBorder = Color(0xFF22C55E);
  static const Color statGreenHint = Color(0xFF16A34A);

  /// Feature — Past Papers (blue book).
  static const Color featurePastPapersIconBg = Color(0xFFEFF6FF);
  static const Color featurePastPapersIconFg = Color(0xFF2563EB);

  /// Feature — Wrong Answers (red X).
  static const Color featureWrongIconBg = Color(0xFFFEF2F2);
  static const Color featureWrongIconFg = Color(0xFFDC2626);

  /// Feature — Review (yellow flag).
  static const Color featureReviewIconBg = Color(0xFFFFFBEB);
  static const Color featureReviewIconFg = Color(0xFFD97706);

  /// Feature — Profile (gray user).
  static const Color featureProfileIconBg = Color(0xFFF3F4F6);
  static const Color featureProfileIconFg = Color(0xFF6B7280);

  static const Color featureCardBorder = Color(0xFFE5E7EB);
}
