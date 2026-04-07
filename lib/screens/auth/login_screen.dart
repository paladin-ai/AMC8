import 'package:flutter/material.dart';

import 'package:amc8/screens/auth/auth_actions.dart';
import 'package:amc8/screens/auth/login_tokens.dart';
import 'package:amc8/screens/dashboard/figma_tokens.dart';
import 'package:amc8/screens/auth/widgets/auth_form_surface.dart';
import 'package:amc8/screens/auth/widgets/login_brand_header.dart';
import 'package:amc8/screens/auth/widgets/login_or_divider.dart';
import 'package:amc8/screens/auth/widgets/login_welcome_block.dart';
import 'package:amc8/screens/auth/widgets/google_g_logo.dart';

/// Email + password login UI (Material 3, light/dark).
///
/// Figma Make link is not readable via the Files API; layout follows your spec
/// and [LoginTokens]. Theme primary is [#7C3AED], secondary [#10B981] via [Amc8AppTheme].
class LoginScreen extends StatefulWidget {
  const LoginScreen({
    super.key,
    this.onSignedIn,
    this.onSignUpTap,
  });

  /// Called after successful validation + [AuthActions.signInWithEmailPassword].
  final VoidCallback? onSignedIn;

  /// “Sign Up” tap — wire to registration route when ready.
  final VoidCallback? onSignUpTap;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();

  bool _obscurePassword = true;
  bool _submitting = false;
  bool _googleLoading = false;

  static final _emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return 'Please enter your email';
    if (!_emailRegex.hasMatch(v)) return 'Enter a valid email address';
    return null;
  }

  String? _validatePassword(String? value) {
    final v = value ?? '';
    if (v.isEmpty) return 'Please enter your password';
    return null;
  }

  void _showLoginErrorDialog(String message) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: FigmaTokens.cardSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(FigmaTokens.radiusStatCard),
        ),
        title: Text(
          'Sign-in failed',
          style: TextStyle(
            color: FigmaTokens.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        content: Text(
          message,
          style: const TextStyle(
            color: FigmaTokens.textSecondary,
            fontSize: 15,
            height: 1.45,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'OK',
              style: TextStyle(
                color: FigmaTokens.statPurpleHint,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _onSignInPressed() async {
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _submitting = true);
    try {
      await AuthActions.signInWithEmailPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
      if (!mounted) return;
      widget.onSignedIn?.call();
    } on AuthException catch (e) {
      if (mounted) _showLoginErrorDialog(e.message);
    } catch (e) {
      if (mounted) {
        _showLoginErrorDialog('Something went wrong: $e');
      }
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  Future<void> _onGooglePressed() async {
    FocusScope.of(context).unfocus();
    setState(() => _googleLoading = true);
    try {
      await AuthActions.signInWithGoogle();
      if (!mounted) return;
      widget.onSignedIn?.call();
    } on AuthException catch (e) {
      if (mounted) _showLoginErrorDialog(e.message);
    } catch (e) {
      if (mounted) {
        _showLoginErrorDialog('Google sign-in failed: $e');
      }
    } finally {
      if (mounted) setState(() => _googleLoading = false);
    }
  }

  Future<void> _onForgotPassword() async {
    final email = _emailController.text.trim();
    if (email.isEmpty || _validateEmail(email) != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Enter a valid email above, then try again.'),
        ),
      );
      return;
    }
    try {
      await AuthActions.requestPasswordReset(email: email);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password reset email sent (stub).')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Reset failed: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final hPad = MediaQuery.sizeOf(context).width >= 600
        ? LoginTokens.screenPaddingH + 16
        : LoginTokens.screenPaddingH;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: LoginTokens.maxContentWidth),
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                hPad,
                LoginTokens.screenPaddingV,
                hPad,
                LoginTokens.screenPaddingV + 12,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const LoginBrandHeader(),
                    SizedBox(height: LoginTokens.gapAfterBrand),
                    const LoginWelcomeBlock(),
                    SizedBox(height: LoginTokens.gapAfterWelcome),
                    AuthFormSurface(
                      isDark: isDark,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          TextFormField(
                            controller: _emailController,
                            focusNode: _emailFocus,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            autofillHints: const [AutofillHints.email],
                            onFieldSubmitted: (_) =>
                                _passwordFocus.requestFocus(),
                            decoration: const InputDecoration(
                              hintText: 'Enter your email',
                              prefixIcon: Icon(Icons.mail_outline_rounded),
                            ),
                            validator: _validateEmail,
                            onChanged: (_) => setState(() {}),
                          ),
                          SizedBox(height: LoginTokens.gapBetweenFields),
                          TextFormField(
                            controller: _passwordController,
                            focusNode: _passwordFocus,
                            obscureText: _obscurePassword,
                            textInputAction: TextInputAction.done,
                            autofillHints: const [AutofillHints.password],
                            onFieldSubmitted: (_) => _onSignInPressed(),
                            decoration: InputDecoration(
                              hintText: 'Enter your password',
                              prefixIcon: const Icon(Icons.lock_outline_rounded),
                              suffixIcon: IconButton(
                                tooltip: _obscurePassword
                                    ? 'Show password'
                                    : 'Hide password',
                                onPressed: () => setState(
                                  () => _obscurePassword = !_obscurePassword,
                                ),
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                  color: scheme.onSurfaceVariant,
                                ),
                              ),
                            ),
                            validator: _validatePassword,
                          ),
                          SizedBox(height: LoginTokens.gapBeforeForgot),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: _onForgotPassword,
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                minimumSize: Size.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: Text(
                                'Forgot Password?',
                                style: TextStyle(
                                  fontSize: LoginTokens.linkSize,
                                  fontWeight: FontWeight.w600,
                                  color: scheme.primary,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: LoginTokens.gapBeforeSignIn),
                          DecoratedBox(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                LoginTokens.buttonRadius,
                              ),
                              boxShadow:
                                  LoginTokens.primaryButtonExtraShadow(
                                scheme.primary,
                              ),
                            ),
                            child: SizedBox(
                              width: double.infinity,
                              height: 52,
                              child: FilledButton(
                                onPressed:
                                    _submitting ? null : _onSignInPressed,
                                style: FilledButton.styleFrom(
                                  backgroundColor: scheme.primary,
                                  foregroundColor: scheme.onPrimary,
                                  disabledBackgroundColor:
                                      scheme.primary.withValues(alpha: 0.45),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                      LoginTokens.buttonRadius,
                                    ),
                                  ),
                                  elevation: 2,
                                  shadowColor:
                                      scheme.primary.withValues(alpha: 0.4),
                                ),
                                child: _submitting
                                    ? SizedBox(
                                        width: 22,
                                        height: 22,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: scheme.onPrimary,
                                        ),
                                      )
                                    : Text(
                                        'Sign In',
                                        style: TextStyle(
                                          fontSize: LoginTokens.buttonTextSize,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: LoginTokens.gapAfterSignIn),
                    const LoginOrDivider(),
                    SizedBox(height: LoginTokens.gapBeforeGoogle),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: OutlinedButton(
                        onPressed: _googleLoading ? null : _onGooglePressed,
                        style: OutlinedButton.styleFrom(
                          backgroundColor: scheme.surface,
                          side: BorderSide(
                            color: scheme.outline.withValues(alpha: 0.65),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              LoginTokens.buttonRadius,
                            ),
                          ),
                        ),
                        child: _googleLoading
                            ? SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: scheme.primary,
                                ),
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const GoogleGLogo(size: 22),
                                  const SizedBox(width: 12),
                                  Text(
                                    'Continue with Google',
                                    style: TextStyle(
                                      fontSize: LoginTokens.buttonTextSize,
                                      fontWeight: FontWeight.w600,
                                      color: scheme.onSurface,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                    SizedBox(height: LoginTokens.gapBeforeFooter),
                    _SignUpFooter(
                      onSignUp: widget.onSignUpTap,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SignUpFooter extends StatelessWidget {
  const _SignUpFooter({this.onSignUp});

  final VoidCallback? onSignUp;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final baseStyle = TextStyle(
      fontSize: LoginTokens.footerSize,
      color: scheme.onSurfaceVariant,
      height: 1.4,
    );

    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text("Don't have an account? ", style: baseStyle),
        InkWell(
          onTap: () {
            if (onSignUp != null) {
              onSignUp!();
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Sign up — coming soon')),
              );
            }
          },
          borderRadius: BorderRadius.circular(4),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 2),
            child: Text(
              'Sign Up',
              style: baseStyle.copyWith(
                fontWeight: FontWeight.w700,
                color: scheme.primary,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
