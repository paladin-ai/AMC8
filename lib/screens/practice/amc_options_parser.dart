/// 從題庫 `options` 欄（AMC 風格 `\textbf{(A)}…`）解析出單選項。
class ParsedMcOption {
  const ParsedMcOption({required this.label, required this.texBody});

  final String label; // A, B, C, D, E
  final String texBody; // 不含標籤的 LaTeX 正文
}

/// 與題目頁一致：收斂 SQLite / 匯入時多餘的反斜線，便於匹配 `\textbf`。
String normalizeOptionsRawForParse(String raw) {
  var s = raw.replaceAll('\r\n', ' ').trim();
  while (s.contains(r'\\')) {
    s = s.replaceAll(r'\\', '\\');
  }
  return s.trim();
}

/// 解析失敗時返回空列表（底部 A–E 仍可操作；詳見自測頁）。
List<ParsedMcOption> parseAmcStyleOptions(String raw) {
  final normalized = normalizeOptionsRawForParse(raw);
  if (normalized.isEmpty) return [];

  var re = RegExp(r'\\textbf\{\(([A-E])\)\}');
  var matches = re.allMatches(normalized).toList();
  if (matches.isEmpty) {
    // 少數資料可能缺少單個 `\`
    re = RegExp(r'textbf\{\(([A-E])\)\}');
    matches = re.allMatches(normalized).toList();
  }
  if (matches.isEmpty) return [];

  final out = <ParsedMcOption>[];
  for (var i = 0; i < matches.length; i++) {
    final start = matches[i].end;
    final end = i + 1 < matches.length ? matches[i + 1].start : normalized.length;
    final letter = matches[i].group(1)!;
    final body = normalized.substring(start, end).trim();
    if (body.isNotEmpty) {
      out.add(ParsedMcOption(label: letter, texBody: body));
    }
  }
  return out;
}
