import 'package:flutter/material.dart';

import '../login_tokens.dart';

/// “Welcome back!” + “Sign in to your account”.
class LoginWelcomeBlock extends StatelessWidget {
  const LoginWelcomeBlock({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Welcome back!',
          style: textTheme.headlineSmall?.copyWith(
            fontSize: LoginTokens.welcomeTitleSize,
            fontWeight: FontWeight.w700,
            color: scheme.onSurface,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Sign in to your account',
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
