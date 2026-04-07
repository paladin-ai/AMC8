import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:amc8/core/app_language.dart';
import 'package:amc8/data/db_helper.dart';

class Y2025Problem8Page extends StatefulWidget {
  const Y2025Problem8Page({super.key});

  @override
  State<Y2025Problem8Page> createState() => _Y2025Problem8PageState();
}

class _Y2025Problem8PageState extends State<Y2025Problem8Page> {
  late String _currentLanguage;
  String _question = "";
  String _options = ""; // 直接存 LaTeX
  final _db = DBHelper.instance;

  /// 1) 去掉外層 `$...$`（[Math.tex] 不需要定界符）  
  /// 2) SQLite / 部分工具會把 `\` 存成 `\\`，連續兩個 `\` 應收斂成一個，否則
  ///    `\\sqrt` 會被舊邏輯誤當成換行，變成 `\qquad sqrt…`，畫面只剩 `sqrt3`、`quad`。
  /// 3) 真實換行改空白，避免 [CrNode]。
  static String _prepareTexForMath(String raw) {
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

  @override
  void initState() {
    super.initState();
    _currentLanguage = AppLanguage.code;
    _loadData();
  }

  Future<void> _loadData() async {
    final data = await _db.getProblem(
      lang: _currentLanguage,
      year: 2025,
      prob: "problem8",
    );
    if (data != null) {
      setState(() {
        _question = data["question"];
        _options = data["options"]; // 读取数据库里的 LaTeX 公式
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("2025 Problem 8"),
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)),
        actions: [
          DropdownButton<String>(
            value: _currentLanguage,
            icon: const Icon(Icons.language, color: Colors.white),
            items: const [
              DropdownMenuItem(value: "en", child: Text("English")),
              DropdownMenuItem(value: "zh", child: Text("中文")),
            ],
            onChanged: (val) {
              if (val != null) {
                AppLanguage.setCode(val);
                setState(() => _currentLanguage = val);
                _loadData();
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _question.isEmpty ? "Loading..." : _question,
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),

            Image.network("https://artofproblemsolving.com/wiki/images/5/54/Amc8_2025_prob8.PNG"),
            const SizedBox(height: 20),

            if (_options.isNotEmpty)
              Math.tex(
                _prepareTexForMath(_options),
                mathStyle: MathStyle.text,
                textStyle: const TextStyle(fontSize: 18),
                onErrorFallback: (_) => SelectableText(
                  _prepareTexForMath(_options),
                  style: const TextStyle(fontSize: 18, height: 1.4),
                ),
              ),
          ],
        ),
      ),
    );
  }
}