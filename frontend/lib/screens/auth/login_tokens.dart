import 'package:flutter/material.dart';

/// Spacing, radii, and typography sizes for the login screen.
///
/// **Figma:** The linked file is Figma Make (`/make/...`); the REST API used by
/// MCP does not return this file type. Replace literals here with Dev Mode
/// values when you have a Design file export.
abstract final class LoginTokens {
  LoginTokens._();

  static const double maxContentWidth = 420;
  static const double screenPaddingH = 24;
  static const double screenPaddingV = 28;

  static const double logoTitleSize = 22;
  static const double logoSubtitleSize = 14;
  static const double welcomeTitleSize = 26;
  static const double welcomeSubtitleSize = 15;
  static const double fieldLabelSize = 14;
  static const double linkSize = 14;
  static const double buttonTextSize = 16;
  static const double footerSize = 14;
  static const double orDividerSize = 13;

  static const double fieldRadius = 12;
  static const double buttonRadius = 12;
  static const double cardRadius = 16;

  static const double gapAfterBrand = 28;
  static const double gapAfterWelcome = 24;
  static const double gapBetweenFields = 16;
  static const double gapBeforeForgot = 8;
  static const double gapBeforeSignIn = 20;
  static const double gapAfterSignIn = 22;
  static const double gapBeforeGoogle = 18;
  static const double gapBeforeFooter = 28;

  /// Elevation for the grouped form “card” on light backgrounds.
  static const double formCardElevation = 1;

  /// Subtle shadow under primary CTA (extra depth beyond FilledButton elevation).
  static List<BoxShadow> primaryButtonExtraShadow(Color primary) => [
        BoxShadow(
          color: primary.withValues(alpha: 0.22),
          blurRadius: 12,
          offset: const Offset(0, 6),
        ),
      ];
}
