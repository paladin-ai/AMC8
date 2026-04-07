import 'package:flutter/material.dart';

import 'package:amc8/screens/dashboard/figma_tokens.dart';

/// Layout / colors for Past Papers (matches provided AMC8 Past Papers mock).
abstract final class PapersTokens {
  PapersTokens._();

  static const double cardRadius = 16;
  static const double cardElevationLight = 1;
  static const double cardPadding = 20;
  static const double horizontalPadding = 20;
  static const double titleTopGap = 8;
  static const double afterNavGap = 20;
  static const double afterSubtitleGap = 20;
  static const double cardSpacing = 16;
  static const double bottomListPadding = 28;

  /// Past papers grid: always three columns on this screen.
  static const int gridCrossAxisCount = 3;

  static const double pageTitleSize = 26;
  static const double pageSubtitleSize = 15;

  /// Calendar icon tile (design ~40×40).
  static const double calendarIconBox = 40;
  static const double calendarIconRadius = 10;

  /// Primary purple & violet for gradient tile / timed CTA.
  static const Color gradientPurpleStart = Color(0xFF7C3AED);
  static const Color gradientPurpleEnd = Color(0xFF5B21B6);

  /// Page title tint (dark navy on light).
  static const Color pageTitleNavyLight = Color(0xFF0F172A);

  static const double badgeFontSize = 13;
  static const double cardTitleSize = 18;
  static const double cardSubtitleSize = 14;
  static const double metaLineSize = 13;
  static const double buttonTextSize = 15;
}

double papersMaxContentWidth() => FigmaTokens.contentMaxWidth.toDouble();
