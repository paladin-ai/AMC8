// 一次性腳本：查看 math_problems 表結構與 2025 年資料
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

Future<void> main() async {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  final root = Directory.current.path;
  final dbPath = p.normalize(p.join(root, 'assets', 'math_problems.db'));
  if (!File(dbPath).existsSync()) {
    stderr.writeln('找不到: $dbPath');
    exit(1);
  }

  final db = await openDatabase(dbPath, readOnly: true);
  try {
    final tables = await db.rawQuery(
      "SELECT sql FROM sqlite_master WHERE type='table' AND name='math_problems'",
    );
    print('--- math_problems DDL ---');
    print(tables.isEmpty ? '(無此表)' : tables.first['sql']);

    final rows = await db.rawQuery(
      "SELECT language, year, problem_number, "
      "length(COALESCE(question,'')) AS q_len, "
      "length(COALESCE(question2,'')) AS q2_len, "
      "length(COALESCE(options,'')) AS o_len "
      "FROM math_problems WHERE year = 2025 ORDER BY problem_number",
    );
    print('\n--- year=2025 列摘要 (problem_number / language / 欄位長度) ---');
    for (final r in rows) {
      print(r);
    }

    final p1 = await db.query(
      'math_problems',
      where: 'language = ? AND year = ? AND problem_number = ?',
      whereArgs: ['en', 2025, 'problem1'],
    );
    final p2 = await db.query(
      'math_problems',
      where: 'language = ? AND year = ? AND problem_number = ?',
      whereArgs: ['en', 2025, 'problem2'],
    );
    final p3 = await db.query(
      'math_problems',
      where: 'language = ? AND year = ? AND problem_number = ?',
      whereArgs: ['en', 2025, 'problem3'],
    );
    print('\n--- 與 App 相同條件查詢 ---');
    print('problem1 筆數: ${p1.length}');
    print('problem2 筆數: ${p2.length}');
    print('problem3 筆數: ${p3.length}');
    if (p2.isNotEmpty) {
      print('problem2 欄位 keys: ${p2.first.keys.toList()}');
    }

    final allNums = await db.rawQuery(
      'SELECT DISTINCT problem_number FROM math_problems WHERE year = 2025',
    );
    print('\n--- 庫內 2025 所有 problem_number 值 ---');
    for (final r in allNums) {
      print('  "${r['problem_number']}"');
    }
  } finally {
    await db.close();
  }
}
