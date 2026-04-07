import 'package:flutter/material.dart';

import '../login_tokens.dart';

/// Top brand block: app name + tagline “Practice & Excel”.
class LoginBrandHeader extends StatelessWidget {
  const LoginBrandHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.calculate_rounded,
              size: 32,
              color: scheme.primary,
            ),
            const SizedBox(width: 10),
            Flexible(
              child: Text(
                'AMC8 AI Tutor',
                textAlign: TextAlign.center,
                style: textTheme.titleLarge?.copyWith(
                  fontSize: LoginTokens.logoTitleSize,
                  fontWeight: FontWeight.w700,
                  color: scheme.onSurface,
                  letterSpacing: -0.3,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Practice & Excel',
          style: textTheme.bodyMedium?.copyWith(
            fontSize: LoginTokens.logoSubtitleSize,
            fontWeight: FontWeight.w600,
            color: scheme.secondary,
            letterSpacing: 0.2,
          ),
        ),
      ],
    );
  }
}
