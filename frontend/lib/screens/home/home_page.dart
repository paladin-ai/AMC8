import 'package:flutter/material.dart';

import 'package:amc8/screens/dashboard/figma_tokens.dart';
import 'package:amc8/screens/dashboard/widgets/home_feature_cards.dart';
import 'package:amc8/screens/dashboard/widgets/home_stat_cards.dart';
import 'package:amc8/screens/dashboard/widgets/home_top_nav_bar.dart';
import 'package:amc8/screens/dashboard/widgets/home_welcome_section.dart';
import 'package:amc8/screens/papers/papers_screen.dart';
import 'package:amc8/screens/profile/profile_screen.dart';
import 'package:amc8/services/session_prefs.dart';
import 'package:amc8/screens/practice/custom_test_setup_screen.dart';

/// AMC8 AI Tutor — dashboard home (layout per Figma; tokens in [FigmaTokens]).
class HomePage extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables — [onLogout] 非常量，无法用 const 构造
  HomePage({super.key, required this.onLogout});

  /// 清除会话后由根组件切回登录页。
  final VoidCallback onLogout;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _navIndex = 0;
  String _welcomeName = 'Student';

  @override
  void initState() {
    super.initState();
    _loadWelcomeName();
  }

  Future<void> _loadWelcomeName() async {
    final name = await SessionPrefs.getWelcomeDisplayName();
    if (mounted) setState(() => _welcomeName = name);
  }

  void _openPastPapers(BuildContext context) {
    Navigator.of(context).push<void>(
      MaterialPageRoute<void>(builder: (_) => const PapersScreen()),
    );
  }

  void _openCustomTestSetup(BuildContext context) {
    Navigator.of(context).push<void>(
      MaterialPageRoute<void>(builder: (_) => const CustomTestSetupScreen()),
    );
  }

  Future<void> _openProfile(BuildContext context) async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (_) => ProfileScreen(
          onLoggedOut: widget.onLogout,
        ),
      ),
    );
    if (mounted) await _loadWelcomeName();
  }

  void _stub(BuildContext context, String name) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$name — coming soon')),
    );
  }

  void _onNavTap(BuildContext context, int index) {
    setState(() => _navIndex = index);
    switch (index) {
      case 0:
        break;
      case 1:
        _openPastPapers(context);
        break;
      case 2:
        _stub(context, 'Wrong Answers');
        break;
      case 3:
        _stub(context, 'Review');
        break;
      case 4:
        _openProfile(context);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final hPadding = MediaQuery.sizeOf(context).width >= 600
        ? FigmaTokens.screenPaddingH + 12
        : FigmaTokens.screenPaddingH;

    return Scaffold(
      backgroundColor: FigmaTokens.pageBackground,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints:
                const BoxConstraints(maxWidth: FigmaTokens.contentMaxWidth),
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                hPadding,
                FigmaTokens.screenPaddingV,
                hPadding,
                FigmaTokens.screenPaddingV + 8,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  HomeTopNavBar(
                    selectedIndex: _navIndex,
                    onSelect: (i) => _onNavTap(context, i),
                  ),
                  SizedBox(height: FigmaTokens.sectionGap),
                  HomeWelcomeSection(displayName: _welcomeName),
                  SizedBox(height: FigmaTokens.sectionGap),
                  HomeStatCardsSection(
                    onTakeTestTap: () => _openCustomTestSetup(context),
                  ),
                  SizedBox(height: FigmaTokens.sectionGap),
                  HomeFeatureCardsSection(
                    onPastPapers: () => _openPastPapers(context),
                    onWrongAnswers: () => _stub(context, 'Wrong Answers'),
                    onReview: () => _stub(context, 'Review Questions'),
                    onProfile: () => _openProfile(context),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
