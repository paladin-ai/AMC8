import 'package:flutter/material.dart';
import 'package:amc8/core/app_language.dart';
import 'package:amc8/data/db_helper.dart';

class Y2025Problem9Page extends StatefulWidget {
  const Y2025Problem9Page({super.key});

  @override
  State<Y2025Problem9Page> createState() => _Y2025Problem9PageState();
}

class _Y2025Problem9PageState extends State<Y2025Problem9Page> {
  late String _currentLanguage;
  String _question = "";
  String _options = "";
  final _db = DBHelper.instance;

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
      prob: "problem9",
    );

    if (data != null) {
      setState(() {
        _question = data["question"];
        _options = data["options"] ?? "";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("2025 Problem 9"),
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

            // 图片
            Image.network(
              "https://latex.artofproblemsolving.com/a/d/e/ade0d0a5fb7d05e6a8166bee8fda14dbe1c68178.png",
            ),
            const SizedBox(height: 20),

            // 选项
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