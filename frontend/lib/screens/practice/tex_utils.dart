/// 與題目頁一致的 LaTeX 預處理（供 [Math.tex] 使用）。
String prepareTexForMath(String raw) {
  var s = raw.trim();
  if (s.length >= 2 && s.startsWith(r'$') && s.endsWith(r'$')) {
    s = s.substring(1, s.length - 1).trim();
  }
  s = s.replaceAll(RegExp(r'\s+'), ' ');
  while (s.contains(r'\\')) {
    s = s.replaceAll(r'\\', '\\');
  }
  return s.trim();
}
