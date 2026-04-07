import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:amc8/screens/auth/login_screen.dart';
import 'package:amc8/screens/auth/register_screen.dart';
import 'package:amc8/screens/home/home_page.dart';
import 'package:amc8/theme/app_theme.dart';

/// Desktop / test runners need sqflite FFI before any DB access.
void main() {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  runApp(const Amc8Root());
}

enum _AuthPage { login, register }

/// Auth stack: sign-up returns to login; only sign-in reaches [HomePage].
class Amc8Root extends StatefulWidget {
  const Amc8Root({super.key});

  @override
  State<Amc8Root> createState() => _Amc8RootState();
}

class _Amc8RootState extends State<Amc8Root> {
  bool _signedIn = false;
  _AuthPage _authPage = _AuthPage.login;

  void _goHome() => setState(() => _signedIn = true);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AMC8 AI Tutor',
      debugShowCheckedModeBanner: false,
      theme: Amc8AppTheme.light(),
      darkTheme: Amc8AppTheme.dark(),
      themeMode: ThemeMode.system,
      home: _signedIn
          ? HomePage(
              onLogout: () => setState(() {
                _signedIn = false;
                _authPage = _AuthPage.login;
              }),
            )
          : _authPage == _AuthPage.login
              ? LoginScreen(
                  onSignedIn: _goHome,
                  onSignUpTap: () =>
                      setState(() => _authPage = _AuthPage.register),
                )
              : RegisterScreen(
                  onRegistered: () =>
                      setState(() => _authPage = _AuthPage.login),
                  onSignInTap: () =>
                      setState(() => _authPage = _AuthPage.login),
                ),
    );
  }
}
