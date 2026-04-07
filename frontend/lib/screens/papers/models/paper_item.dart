/// One AMC8 exam year row in the Past Papers catalog.
class PaperItem {
  const PaperItem({
    required this.id,
    required this.year,
    required this.displayTitle,
    required this.questionCount,
  });

  /// Stable key, e.g. `"2025"`.
  final String id;

  final int year;

  /// Card title line, e.g. `"AMC8 2025"`.
  final String displayTitle;

  /// Shown in the top-right pill (AMC8 has 25 problems).
  final int questionCount;
}
