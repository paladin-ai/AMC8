import 'package:flutter/material.dart';

import 'package:amc8/screens/auth/login_tokens.dart';

/// Rounded card behind auth fields + primary CTA (matches login/register Figma-style layout).
class AuthFormSurface extends StatelessWidget {
  const AuthFormSurface({
    super.key,
    required this.child,
    required this.isDark,
  });

  final Widget child;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Material(
      color: scheme.surface,
      elevation: isDark ? 0 : LoginTokens.formCardElevation,
      shadowColor: Colors.black.withValues(alpha: 0.06),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(LoginTokens.cardRadius),
        side: isDark
            ? BorderSide(color: scheme.outline.withValues(alpha: 0.35))
            : BorderSide.none,
      ),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 22, 18, 22),
        child: child,
      ),
    );
  }
}
