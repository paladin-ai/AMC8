/// 題庫中的一題引用（年 + `problem_number` 字串）。
class ProblemRef {
  const ProblemRef({required this.year, required this.problemNumber});

  final int year;
  final String problemNumber;

  String get displayLabel => '$year ${problemNumber.replaceFirst('problem', 'Q')}';

  /// `problem12` → 12；無法解析時為 null。
  int? get problemIndex1Based {
    final m = RegExp(r'^problem(\d+)$').firstMatch(problemNumber.trim());
    if (m == null) return null;
    return int.tryParse(m.group(1)!);
  }
}
