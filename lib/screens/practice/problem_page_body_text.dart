import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';

import 'package:amc8/screens/practice/custom_test_models.dart';
import 'package:amc8/screens/practice/tex_utils.dart';

/// 與 `year2025_problem*_page.dart` 題幹 / 選項的 [TextStyle] 一致。
const TextStyle kProblemPagePlainText = TextStyle(fontSize: 18);

/// 僅 [Y2025Problem23Page] 第一問使用 `height: 1.4`。
TextStyle _stemStyleFor(ProblemRef ref) {
  if (ref.year == 2025 && ref.problemNumber.trim() == 'problem23') {
    return const TextStyle(fontSize: 18, height: 1.4);
  }
  return kProblemPagePlainText;
}

/// 與試題頁相同：一般為 [Text] 換行；僅 2025 Problem 8 的選項用 [Math.tex]。
Widget problemStemText(ProblemRef ref, String s) {
  if (s.trim().isEmpty) return const SizedBox.shrink();
  return Text(s, style: _stemStyleFor(ref));
}

/// `question2` 各頁均為 `fontSize: 18`（無 23 題特殊行高）。
Widget problemSecondStemText(String s) {
  if (s.trim().isEmpty) return const SizedBox.shrink();
  return Text(s, style: kProblemPagePlainText);
}

bool _optionsUseMathTex(ProblemRef ref) {
  return ref.year == 2025 && ref.problemNumber.trim() == 'problem8';
}

/// 與對應試題頁選項區一致（多數 [Text]；8 題 [Math.tex] + 與原頁相同的 fallback）。
Widget problemOptionsBlock(ProblemRef ref, String options) {
  if (options.trim().isEmpty) return const SizedBox.shrink();
  if (_optionsUseMathTex(ref)) {
    final t = prepareTexForMath(options);
    return Math.tex(
      t,
      mathStyle: MathStyle.text,
      textStyle: kProblemPagePlainText,
      onErrorFallback: (_) => SelectableText(
        t,
        style: const TextStyle(fontSize: 18, height: 1.4),
      ),
    );
  }
  return Text(options, style: kProblemPagePlainText);
}
