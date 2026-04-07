import 'package:flutter/material.dart';

import 'package:amc8/screens/practice/custom_test_models.dart';
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

/// 與 App 題目頁一一對應的 `problem1`…`problem25` 列表。
List<String> problemRouteKeysForYear2025() =>
    List.generate(25, (i) => 'problem${i + 1}');

/// 自測抽題用：該年在 App 內已註冊路由的全部題號。
List<String> problemRouteKeysForYear(int year) {
  if (year == 2025) return problemRouteKeysForYear2025();
  return const [];
}

/// 打開與題庫相同的完整題目頁（含語言切換等）。
Widget? buildProblemPageWidget(ProblemRef ref) {
  if (ref.year == 2025) {
    return _widgetY2025(ref.problemNumber);
  }
  return null;
}

void pushProblemDetailPage(BuildContext context, ProblemRef ref) {
  final w = buildProblemPageWidget(ref);
  if (w == null) return;
  Navigator.of(context).push<void>(
    MaterialPageRoute<void>(builder: (_) => w),
  );
}

Widget? _widgetY2025(String key) {
  return switch (key) {
    'problem1' => const Y2025Problem1Page(),
    'problem2' => const Y2025Problem2Page(),
    'problem3' => const Y2025Problem3Page(),
    'problem4' => const Y2025Problem4Page(),
    'problem5' => const Y2025Problem5Page(),
    'problem6' => const Y2025Problem6Page(),
    'problem7' => const Y2025Problem7Page(),
    'problem8' => const Y2025Problem8Page(),
    'problem9' => const Y2025Problem9Page(),
    'problem10' => const Y2025Problem10Page(),
    'problem11' => const Y2025Problem11Page(),
    'problem12' => const Y2025Problem12Page(),
    'problem13' => const Y2025Problem13Page(),
    'problem14' => const Y2025Problem14Page(),
    'problem15' => const Y2025Problem15Page(),
    'problem16' => const Y2025Problem16Page(),
    'problem17' => const Y2025Problem17Page(),
    'problem18' => const Y2025Problem18Page(),
    'problem19' => const Y2025Problem19Page(),
    'problem20' => const Y2025Problem20Page(),
    'problem21' => const Y2025Problem21Page(),
    'problem22' => const Y2025Problem22Page(),
    'problem23' => const Y2025Problem23Page(),
    'problem24' => const Y2025Problem24Page(),
    'problem25' => const Y2025Problem25Page(),
    _ => null,
  };
}
