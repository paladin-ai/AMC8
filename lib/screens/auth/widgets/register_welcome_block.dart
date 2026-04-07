import 'package:flutter/material.dart';

import 'package:amc8/screens/auth/login_tokens.dart';

/// Register screen headline + subcopy.
class RegisterWelcomeBlock extends StatelessWidget {
  const RegisterWelcomeBlock({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Create Account',
          style: textTheme.headlineSmall?.copyWith(
            fontSize: LoginTokens.welcomeTitleSize,
            fontWeight: FontWeight.w700,
            color: scheme.onSurface,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Sign up to get started',
          style: textTheme.bodyLarge?.copyWith(
            fontSize: LoginTokens.welcomeSubtitleSize,
            fontWeight: FontWeight.w400,
            color: scheme.onSurfaceVariant,
            height: 1.35,
          ),
        ),
      ],
    );
  }
}
