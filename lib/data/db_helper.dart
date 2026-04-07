import 'dart:io';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class DBHelper {
  static Database? _db;
  static const String dbName = 'math_problems.db';

  /// 隨 `assets/math_problems.db` 更新而遞增；舊安裝若複製過舊庫，會依此重新從 assets 覆寫。
  /// 每次更新 `assets/math_problems.db`（新增題目等）請 +1，否則已安裝的 App 會繼續用舊庫。
  static const int _bundledDbRevision = 31;

  // 单例实例
  static final DBHelper instance = DBHelper._internal();
  DBHelper._internal();

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initLocalDB();
    return _db!;
  }

  // 从assets复制数据库到本地可读写路径
  Future<Database> _initLocalDB() async {
    // 用path_provider获取应用文档目录，适配Windows
    final docsDir = await getApplicationDocumentsDirectory();
    final path = join(docsDir.path, dbName);
    final revPath = join(docsDir.path, '$dbName.rev');

    if (await _shouldRecopyBundledDb(path, revPath)) {
      await _deleteSqliteSidecars(path);
      final byteData = await rootBundle.load('assets/$dbName');
      final file = File(path);
      await file.writeAsBytes(byteData.buffer.asUint8List());
      await File(revPath).writeAsString('$_bundledDbRevision');
    }

    return await openDatabase(path);
  }

  Future<bool> _shouldRecopyBundledDb(String dbPath, String revPath) async {
    if (!await File(dbPath).exists()) return true;
    final revFile = File(revPath);
    if (!await revFile.exists()) return true;
    final stored = int.tryParse((await revFile.readAsString()).trim()) ?? 0;
    return stored < _bundledDbRevision;
  }

  Future<void> _deleteSqliteSidecars(String dbPath) async {
    for (final extra in ['$dbPath-wal', '$dbPath-shm']) {
      final f = File(extra);
      if (await f.exists()) await f.delete();
    }
    final main = File(dbPath);
    if (await main.exists()) await main.delete();
  }

  // 按语言、年份、题目号查询题目
  Future<Map<String, dynamic>?> getProblem({
    required String lang,
    required int year,
    required String prob,
  }) async {
    final db = await database;
    // 庫內欄位若帶首尾換行/空白（匯入、Excel 等），直接 = 會查不到；用 trim 兩邊對齊
    final res = await db.query(
      'math_problems',
      where: 'trim(language) = ? AND year = ? AND trim(problem_number) = ?',
      whereArgs: [lang.trim(), year, prob.trim()],
    );
    return res.isNotEmpty ? res.first : null;
  }

  /// 某年、某語言下，有非空選項文本的題號（可做選擇題自測）。
  Future<List<String>> getProblemNumbersWithNonEmptyOptions({
    required String lang,
    required int year,
  }) async {
    final db = await database;
    final res = await db.rawQuery(
      '''
      SELECT DISTINCT trim(problem_number) AS pn FROM math_problems
      WHERE trim(language) = ? AND year = ?
        AND options IS NOT NULL AND trim(options) != ''
      ORDER BY pn
      ''',
      [lang.trim(), year],
    );
    return res.map((e) => e['pn']! as String).toList();
  }

  /// 在 [candidateYears] 中，返回題庫裡確實有可測選擇題的年份（與 App 題目頁年份取交集由調用方完成）。
  Future<List<int>> getYearsWithOptions({
    required String lang,
    required Iterable<int> candidateYears,
  }) async {
    final out = <int>[];
    for (final y in candidateYears) {
      final nums = await getProblemNumbersWithNonEmptyOptions(lang: lang, year: y);
      if (nums.isNotEmpty) out.add(y);
    }
    out.sort();
    return out;
  }

  // 关闭数据库连接
  Future<void> close() async {
    final db = await database;
    await db.close();
    _db = null;
  }
}