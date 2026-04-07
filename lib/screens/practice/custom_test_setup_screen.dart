import 'dart:math';

import 'package:flutter/material.dart';

import 'package:amc8/core/app_language.dart';
import 'package:amc8/screens/dashboard/figma_tokens.dart';
import 'package:amc8/data/db_helper.dart';
import 'package:amc8/screens/practice/app_testable_years.dart';
import 'package:amc8/screens/practice/custom_test_models.dart';
import 'package:amc8/screens/practice/custom_test_session_screen.dart';
import 'package:amc8/screens/practice/problem_page_routes.dart';

/// Test setup: question count + multi-select years (matches home [FigmaTokens]).
class CustomTestSetupScreen extends StatefulWidget {
  const CustomTestSetupScreen({super.key});

  @override
  State<CustomTestSetupScreen> createState() => _CustomTestSetupScreenState();
}

class _CustomTestSetupScreenState extends State<CustomTestSetupScreen> {
  final _db = DBHelper.instance;
  final _countController = TextEditingController(text: '5');

  List<int> _availableYears = [];
  final Set<int> _selectedYears = {};
  bool _loadingYears = true;

  @override
  void initState() {
    super.initState();
    _loadYears();
  }

  @override
  void dispose() {
    _countController.dispose();
    super.dispose();
  }

  Future<void> _loadYears() async {
    final lang = AppLanguage.code;
    final years = await _db.getYearsWithOptions(
      lang: lang,
      candidateYears: kAppYearsWithProblemPages,
    );
    if (!mounted) return;
    setState(() {
      _availableYears = years;
      _selectedYears
        ..clear()
        ..addAll(years);
      _loadingYears = false;
    });
  }

  void _toast(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(FigmaTokens.radiusStatCard),
        ),
        content: Text(message),
      ),
    );
  }

  Future<void> _startTest() async {
    final n = int.tryParse(_countController.text.trim());
    if (n == null || n < 1) {
      _toast('Enter a valid number of questions (at least 1).');
      return;
    }
    if (_selectedYears.isEmpty) {
      _toast('Select at least one year.');
      return;
    }

    final lang = AppLanguage.code;
    final pool = <ProblemRef>[];
    for (final y in _selectedYears) {
      for (final pn in problemRouteKeysForYear(y)) {
        final row = await _db.getProblem(lang: lang, year: y, prob: pn);
        if (row != null) {
          pool.add(ProblemRef(year: y, problemNumber: pn));
        }
      }
    }

    if (pool.isEmpty) {
      if (!mounted) return;
      _toast(
        'No problems found for the selected years. Check language or the problem bank.',
      );
      return;
    }

    pool.shuffle(Random());
    final take = min(n, pool.length);
    final quiz = pool.sublist(0, take);

    if (!mounted) return;
    await Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (_) => CustomTestSessionScreen(problems: quiz),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;

    return Scaffold(
      backgroundColor:
          isLight ? FigmaTokens.pageBackground : Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text('Test setup'),
      ),
      body: _loadingYears
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.fromLTRB(
                FigmaTokens.screenPaddingH,
                20,
                FigmaTokens.screenPaddingH,
                28,
              ),
              children: [
                Text(
                  'How many questions?',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: FigmaTokens.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _countController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'e.g. 5',
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.surface,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(FigmaTokens.radiusStatCard),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(FigmaTokens.radiusStatCard),
                      borderSide: const BorderSide(color: FigmaTokens.featureCardBorder),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Years (multi-select)',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: FigmaTokens.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Only years that have in-app problem pages and data in the bank for the current language.',
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.35,
                    color: FigmaTokens.textSecondary,
                  ),
                ),
                const SizedBox(height: 12),
                if (_availableYears.isEmpty)
                  Text(
                    'No years available. Check the problem bank and kAppYearsWithProblemPages.',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                      fontSize: 14,
                    ),
                  )
                else
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _availableYears.map((y) {
                      final sel = _selectedYears.contains(y);
                      return FilterChip(
                        label: Text('$y'),
                        selected: sel,
                        selectedColor: FigmaTokens.navSelectedBg,
                        checkmarkColor: FigmaTokens.statPurpleHint,
                        labelStyle: TextStyle(
                          color: sel
                              ? FigmaTokens.navSelectedFg
                              : FigmaTokens.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                        side: const BorderSide(color: FigmaTokens.featureCardBorder),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(FigmaTokens.radiusNavPill),
                        ),
                        onSelected: (v) {
                          setState(() {
                            if (v) {
                              _selectedYears.add(y);
                            } else {
                              _selectedYears.remove(y);
                            }
                          });
                        },
                      );
                    }).toList(),
                  ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: FilledButton(
                    onPressed: _availableYears.isEmpty ? null : _startTest,
                    style: FilledButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(FigmaTokens.radiusStatCard),
                      ),
                    ),
                    child: const Text(
                      'Start test',
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
