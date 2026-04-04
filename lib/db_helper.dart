import 'dart:io';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class DBHelper {
  static Database? _db;
  static const String dbName = 'math_problems.db';

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

    // 仅第一次复制，避免重复覆盖
    if (!await File(path).exists()) {
      final byteData = await rootBundle.load('assets/$dbName');
      final file = File(path);
      await file.writeAsBytes(byteData.buffer.asUint8List());
    }

    return await openDatabase(path);
  }

  // 按语言、年份、题目号查询题目
  Future<Map<String, dynamic>?> getProblem({
    required String lang,
    required int year,
    required String prob,
  }) async {
    final db = await database;
    final res = await db.query(
      'math_problems',
      where: 'language = ? AND year = ? AND problem_number = ?',
      whereArgs: [lang, year, prob],
    );
    return res.isNotEmpty ? res.first : null;
  }

  // 关闭数据库连接
  Future<void> close() async {
    final db = await database;
    await db.close();
    _db = null;
  }
}