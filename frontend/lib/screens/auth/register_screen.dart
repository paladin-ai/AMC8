import 'package:flutter/material.dart';

import 'package:amc8/screens/auth/auth_actions.dart';
import 'package:amc8/screens/auth/login_tokens.dart';
import 'package:amc8/screens/auth/widgets/auth_form_surface.dart';
import 'package:amc8/screens/auth/widgets/google_g_logo.dart';
import 'package:amc8/screens/auth/widgets/login_brand_header.dart';
import 'package:amc8/screens/auth/widgets/login_or_divider.dart';
import 'package:amc8/screens/auth/widgets/register_welcome_block.dart';

/// Registration UI (Material 3, light/dark). Layout mirrors [LoginScreen].
///
/// Figma Make `/register` is not readable via the Files API; structure follows your spec.
/// Primary **#7C3AED** / secondary **#10B981** match `Amc8AppTheme` in `app_theme.dart`.
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({
    super.key,
    this.onRegistered,
    this.onSignInTap,
  });

  /// After successful sign-up — e.g. switch back to [LoginScreen] so the user can sign in.
  final VoidCallback? onRegistered;

  /// Navigate back to login.
  final VoidCallback? onSignInTap;

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  final _nameFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();
  final _confirmFocus = FocusNode();

  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _submitting = false;
  bool _googleLoading = false;

  static final _emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    _nameFocus.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _confirmFocus.dispose();
    super.dispose();
  }

  String? _validateName(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return 'Please enter your full name';
    if (v.length < 2) return 'Name looks too short';
    return null;
  }

  String? _validateEmail(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return 'Please enter your email';
    if (!_emailRegex.hasMatch(v)) return 'Enter a valid email address';
    return null;
  }

  /// At least 8 characters, with both letters and numbers (reasonable default strength).
  String? _validatePasswordStrength(String? value) {
    final v = value ?? '';
    if (v.isEmpty) return 'Please enter a password';
    if (v.length < 8) {
      return 'Use at least 8 characters';
    }
    final hasLetter = RegExp(r'[A-Za-z]').hasMatch(v);
    final hasDigit = RegExp(r'\d').hasMatch(v);
    if (!hasLetter || !hasDigit) {
      return 'Include at least one letter and one number';
    }
    return null;
  }

  String? _validateConfirm(String? value) {
    final v = value ?? '';
    if (v.isEmpty) return 'Please confirm your password';
    if (v != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  String? _validateTerms(bool? value) {
    if (value == true) return null;
    return 'Please accept the terms to continue';
  }

  Future<void> _onSignUpPressed() async {
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _submitting = true);
    try {
      await AuthActions.signUpWithEmailPassword(
        fullName: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
      if (!mounted) return;
      widget.onRegistered?.call();
    } on AuthException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.message),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Couldn’t create account. Please try again.'),
            behavior: SnackBarBehavior.floating,
            action: SnackBarAction(
              label: 'Details',
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('$e')),
                );
              },
            ),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  Future<void> _onGooglePressed() async {
    FocusScope.of(context).unfocus();
    setState(() => _googleLoading = true);
    try {
      await AuthActions.signUpWithGoogle();
      if (!mounted) return;
      widget.onRegistered?.call();
    } on AuthException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.message),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Google sign-up didn’t finish. Try again.'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _googleLoading = false);
    }
  }

  void _onSignInLink() {
    if (widget.onSignInTap != null) {
      widget.onSignInTap!();
    } else {
      Navigator.of(context).maybePop();
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
            constraints:
                const BoxConstraints(maxWidth: LoginTokens.maxContentWidth),
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                hPad,
                LoginTokens.screenPaddingV,
                hPad,
                LoginTokens.screenPaddingV + 12,
              ),
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const LoginBrandHeader(),
                    SizedBox(height: LoginTokens.gapAfterBrand),
                    const RegisterWelcomeBlock(),
                    SizedBox(height: LoginTokens.gapAfterWelcome),
                    AuthFormSurface(
                      isDark: isDark,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          TextFormField(
                            controller: _nameController,
                            focusNode: _nameFocus,
                            textInputAction: TextInputAction.next,
                            textCapitalization: TextCapitalization.words,
                            autofillHints: const [AutofillHints.name],
                            onFieldSubmitted: (_) => _emailFocus.requestFocus(),
                            decoration: const InputDecoration(
                              hintText: 'Enter your full name',
                              prefixIcon: Icon(Icons.person_outline_rounded),
                            ),
                            validator: _validateName,
                          ),
                          SizedBox(height: LoginTokens.gapBetweenFields),
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
                          ),
                          SizedBox(height: LoginTokens.gapBetweenFields),
                          TextFormField(
                            controller: _passwordController,
                            focusNode: _passwordFocus,
                            obscureText: _obscurePassword,
                            textInputAction: TextInputAction.next,
                            autofillHints: const [AutofillHints.newPassword],
                            onFieldSubmitted: (_) =>
                                _confirmFocus.requestFocus(),
                            decoration: InputDecoration(
                              hintText: 'Create a password',
                              prefixIcon:
                                  const Icon(Icons.lock_outline_rounded),
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
                            validator: _validatePasswordStrength,
                          ),
                          SizedBox(height: LoginTokens.gapBetweenFields),
                          TextFormField(
                            controller: _confirmController,
                            focusNode: _confirmFocus,
                            obscureText: _obscureConfirm,
                            textInputAction: TextInputAction.done,
                            autofillHints: const [AutofillHints.newPassword],
                            onFieldSubmitted: (_) => _onSignUpPressed(),
                            decoration: InputDecoration(
                              hintText: 'Confirm your password',
                              prefixIcon:
                                  const Icon(Icons.lock_outline_rounded),
                              suffixIcon: IconButton(
                                tooltip: _obscureConfirm
                                    ? 'Show password'
                                    : 'Hide password',
                                onPressed: () => setState(
                                  () => _obscureConfirm = !_obscureConfirm,
                                ),
                                icon: Icon(
                                  _obscureConfirm
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                  color: scheme.onSurfaceVariant,
                                ),
                              ),
                            ),
                            validator: _validateConfirm,
                          ),
                          SizedBox(height: LoginTokens.gapBetweenFields + 4),
                          FormField<bool>(
                            initialValue: false,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: _validateTerms,
                            builder: (state) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Checkbox(
                                        value: state.value ?? false,
                                        onChanged: (b) {
                                          state.didChange(b ?? false);
                                          state.validate();
                                        },
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(top: 10),
                                          child: Text.rich(
                                            TextSpan(
                                              style: TextStyle(
                                                fontSize: 13,
                                                height: 1.4,
                                                color:
                                                    scheme.onSurfaceVariant,
                                              ),
                                              children: [
                                                const TextSpan(
                                                  text: 'I agree to the ',
                                                ),
                                                WidgetSpan(
                                                  alignment:
                                                      PlaceholderAlignment
                                                          .baseline,
                                                  baseline:
                                                      TextBaseline.alphabetic,
                                                  child: InkWell(
                                                    onTap: () {
                                                      ScaffoldMessenger.of(
                                                        context,
                                                      ).showSnackBar(
                                                        const SnackBar(
                                                          content: Text(
                                                            'Terms — open your policy URL here',
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                    child: Text(
                                                      'Terms of Service',
                                                      style: TextStyle(
                                                        color: scheme.primary,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        fontSize: 13,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                const TextSpan(text: ' and '),
                                                WidgetSpan(
                                                  alignment:
                                                      PlaceholderAlignment
                                                          .baseline,
                                                  baseline:
                                                      TextBaseline.alphabetic,
                                                  child: InkWell(
                                                    onTap: () {
                                                      ScaffoldMessenger.of(
                                                        context,
                                                      ).showSnackBar(
                                                        const SnackBar(
                                                          content: Text(
                                                            'Privacy — open your policy URL here',
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                    child: Text(
                                                      'Privacy Policy',
                                                      style: TextStyle(
                                                        color: scheme.primary,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        fontSize: 13,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (state.hasError)
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        left: 12,
                                        top: 4,
                                      ),
                                      child: Text(
                                        state.errorText!,
                                        style: TextStyle(
                                          color: scheme.error,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                ],
                              );
                            },
                          ),
                          SizedBox(height: LoginTokens.gapBeforeSignIn),
                          DecoratedBox(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                LoginTokens.buttonRadius,
                              ),
                              boxShadow: LoginTokens.primaryButtonExtraShadow(
                                scheme.primary,
                              ),
                            ),
                            child: SizedBox(
                              width: double.infinity,
                              height: 52,
                              child: FilledButton(
                                onPressed:
                                    _submitting ? null : _onSignUpPressed,
                                style: FilledButton.styleFrom(
                                  backgroundColor: scheme.primary,
                                  foregroundColor: scheme.onPrimary,
                                  disabledBackgroundColor: scheme.primary
                                      .withValues(alpha: 0.45),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                      LoginTokens.buttonRadius,
                                    ),
                                  ),
                                  elevation: 2,
                                  shadowColor: scheme.primary
                                      .withValues(alpha: 0.4),
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
                                        'Sign Up',
                                        style: TextStyle(
                                          fontSize:
                                              LoginTokens.buttonTextSize,
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
                    _RegisterSignInFooter(onSignIn: _onSignInLink),
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

class _RegisterSignInFooter extends StatelessWidget {
  const _RegisterSignInFooter({required this.onSignIn});

  final VoidCallback onSignIn;

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
        Text('Already have an account? ', style: baseStyle),
        InkWell(
          onTap: onSignIn,
          borderRadius: BorderRadius.circular(4),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 2),
            child: Text(
              'Sign In',
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
