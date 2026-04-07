import 'package:flutter/material.dart';
import 'package:amc8/core/app_language.dart';
import 'package:amc8/screens/problems/year2025_problem1_page.dart';
import 'package:amc8/screens/problems/year2025_problem2_page.dart';
import 'package:amc8/screens/problems/year2025_problem3_page.dart';
import 'package:amc8/screens/problems/year2025_problem4_page.dart';
import 'package:amc8/screens/problems/year2025_problem5_page.dart';
import 'package:amc8/screens/problems/year2025_problem6_page.dart';
import 'package:amc8/screens/problems/year2025_problem7_page.dart';
import 'package:amc8/screens/problems/year2025_problem8_page.dart';
import 'package:amc8/screens/problems/year2025_problem9_page.dart';
import 'package:amc8/screens/problems/year2025_problem10_page.dart';
import 'package:amc8/screens/problems/year2025_problem11_page.dart';
import 'package:amc8/screens/problems/year2025_problem12_page.dart';
import 'package:amc8/screens/problems/year2025_problem13_page.dart';
import 'package:amc8/screens/problems/year2025_problem14_page.dart';
import 'package:amc8/screens/problems/year2025_problem15_page.dart';
import 'package:amc8/screens/problems/year2025_problem16_page.dart';
import 'package:amc8/screens/problems/year2025_problem17_page.dart';
import 'package:amc8/screens/problems/year2025_problem18_page.dart';
import 'package:amc8/screens/problems/year2025_problem19_page.dart';
import 'package:amc8/screens/problems/year2025_problem20_page.dart';
import 'package:amc8/screens/problems/year2025_problem21_page.dart';
import 'package:amc8/screens/problems/year2025_problem22_page.dart';
import 'package:amc8/screens/problems/year2025_problem23_page.dart';
import 'package:amc8/screens/problems/year2025_problem24_page.dart';
import 'package:amc8/screens/problems/year2025_problem25_page.dart';

/// 2025 AMC8 problem grid (opened from dashboard “Past Papers”).
class PastPapersGridPage extends StatefulWidget {
  const PastPapersGridPage({super.key});

  static final List<Widget Function()> _problemPages = [
    () => const Y2025Problem1Page(),
    () => const Y2025Problem2Page(),
    () => const Y2025Problem3Page(),
    () => const Y2025Problem4Page(),
    () => const Y2025Problem5Page(),
    () => const Y2025Problem6Page(),
    () => const Y2025Problem7Page(),
    () => const Y2025Problem8Page(),
    () => const Y2025Problem9Page(),
    () => const Y2025Problem10Page(),
    () => const Y2025Problem11Page(),
    () => const Y2025Problem12Page(),
    () => const Y2025Problem13Page(),
    () => const Y2025Problem14Page(),
    () => const Y2025Problem15Page(),
    () => const Y2025Problem16Page(),
    () => const Y2025Problem17Page(),
    () => const Y2025Problem18Page(),
    () => const Y2025Problem19Page(),
    () => const Y2025Problem20Page(),
    () => const Y2025Problem21Page(),
    () => const Y2025Problem22Page(),
    () => const Y2025Problem23Page(),
    () => const Y2025Problem24Page(),
    () => const Y2025Problem25Page(),
  ];

  @override
  State<PastPapersGridPage> createState() => _PastPapersGridPageState();
}

class _PastPapersGridPageState extends State<PastPapersGridPage> {
  String _lang = AppLanguage.code;

  String _cellLabel(int num) => _lang == 'zh' ? '第 $num 题' : 'Problem $num';

  String get _appBarTitle => _lang == 'zh' ? '真题试卷' : 'Past Papers';

  String get _paperTitle => 'AMC8 2025';

  String get _paperSubtitle =>
      _lang == 'zh' ? '官方竞赛试卷' : 'Official competition paper';

  void _openProblem(BuildContext context, int index) {
    if (index < 0 || index >= PastPapersGridPage._problemPages.length) return;
    AppLanguage.setCode(_lang);
    Navigator.push<void>(
      context,
      MaterialPageRoute<void>(
        builder: (_) => PastPapersGridPage._problemPages[index](),
      ),
    ).then((_) {
      if (mounted) setState(() => _lang = AppLanguage.code);
    });
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final borderColor = scheme.outlineVariant.withValues(alpha: 0.8);
    final appBarFg =
        Theme.of(context).appBarTheme.foregroundColor ?? scheme.onSurface;

    return Scaffold(
      appBar: AppBar(
        title: Text(_appBarTitle),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: DropdownButton<String>(
              value: _lang,
              underline: const SizedBox.shrink(),
              icon: Icon(Icons.language, color: appBarFg),
              style: TextStyle(color: appBarFg, fontSize: 15),
              dropdownColor: scheme.surfaceContainerHigh,
              items: [
                DropdownMenuItem(
                  value: 'en',
                  child:
                      Text('English', style: TextStyle(color: scheme.onSurface)),
                ),
                DropdownMenuItem(
                  value: 'zh',
                  child: Text('中文', style: TextStyle(color: scheme.onSurface)),
                ),
              ],
              onChanged: (v) {
                if (v != null) {
                  AppLanguage.setCode(v);
                  setState(() => _lang = v);
                }
              },
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              _paperTitle,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: scheme.onSurface,
                  ),
            ),
            const SizedBox(height: 6),
            Text(
              _paperSubtitle,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: scheme.onSurfaceVariant,
                    fontWeight: FontWeight.w400,
                  ),
            ),
            const SizedBox(height: 20),
            Table(
              border: TableBorder.all(color: borderColor, width: 1),
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: List.generate(5, (row) {
                return TableRow(
                  children: List.generate(5, (col) {
                    final index = row * 5 + col;
                    final num = index + 1;
                    return TableCell(
                      child: Material(
                        color: scheme.surfaceContainerHighest
                            .withValues(alpha: 0.35),
                        child: InkWell(
                          onTap: () => _openProblem(context, index),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 18,
                              horizontal: 4,
                            ),
                            child: Center(
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  _cellLabel(num),
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: scheme.onSurface,
                                      ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
