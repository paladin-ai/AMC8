import 'package:flutter/material.dart';

import '../figma_tokens.dart';

/// "Welcome back, {displayName}! 👋" + practice subtitle.
class HomeWelcomeSection extends StatelessWidget {
  const HomeWelcomeSection({
    super.key,
    required this.displayName,
  });

  /// 登录用户的 full name（或邮箱前缀等，由 [SessionPrefs] 决定）。
  final String displayName;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Welcome back, $displayName! 👋',
          style: TextStyle(
            fontSize: FigmaTokens.welcomeTitleSize,
            fontWeight: FontWeight.w600,
            height: 1.25,
            color: FigmaTokens.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Ready to practice AMC8 problems?',
          style: TextStyle(
            fontSize: FigmaTokens.welcomeSubtitleSize,
            fontWeight: FontWeight.w400,
            height: 1.4,
            color: FigmaTokens.textSecondary,
          ),
        ),
      ],
    );
  }
}
