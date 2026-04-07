import 'package:flutter/material.dart';
import 'package:amc8/core/app_language.dart';
import 'package:amc8/data/db_helper.dart';

class Y2025Problem2Page extends StatefulWidget {
  const Y2025Problem2Page({super.key});

  @override
  State<Y2025Problem2Page> createState() => _Y2025Problem2PageState();
}

class _Y2025Problem2PageState extends State<Y2025Problem2Page> {
  // 语言切换（跟第一题一样）
  late String _currentLanguage;

  // 从数据库读取
  String _question = "";
  String _question2 = "";
  String _options = "";
  final _db = DBHelper.instance;

  @override
  void initState() {
    super.initState();
    _currentLanguage = AppLanguage.code;
    _loadData();
  }

  // 从数据库加载题目2内容
  Future<void> _loadData() async {
    final data = await _db.getProblem(
      lang: _currentLanguage,
      year: 2025,
      prob: "problem2",
    );

    if (data != null) {
      setState(() {
        _question = data["question"];
        _question2 = data["question2"];
        _options = data["options"];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("2025 Problem 2"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        // ✅ 右上角语言切换（跟第一题完全一样）
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
                setState(() {
                  _currentLanguage = val;
                });
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
            // ✅ 图片上面的问题（数据库取）
            Text(
              _question.isEmpty ? "Loading..." : _question,
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),

            // 固定图片1（你原本的）
            const Image(
              image: NetworkImage('https://artofproblemsolving.com/wiki/images/d/de/Mathh.PNG'),
            ),
            const SizedBox(height: 20),

            // ✅ 图片下面的问题（数据库取）
            Text(
              _question2.isEmpty ? "" : _question2,
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),

            // 固定图片2（你原本的）
            const Image(
              image: NetworkImage('https://artofproblemsolving.com/wiki/images/3/38/Amc8_2025_prob_2_pic.PNG'),
            ),
            const SizedBox(height: 20),

            // ✅ 选项（数据库取）
            Text(
              _options.isEmpty ? "" : _options,
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}