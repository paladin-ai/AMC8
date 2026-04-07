import 'package:flutter/material.dart';
import 'package:amc8/core/app_language.dart';
import 'package:amc8/data/db_helper.dart';

class Y2025Problem11Page extends StatefulWidget {
  const Y2025Problem11Page({super.key});

  @override
  State<Y2025Problem11Page> createState() => _Y2025Problem11PageState();
}

class _Y2025Problem11PageState extends State<Y2025Problem11Page> {
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
      prob: "problem11",
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
        title: const Text("2025 Problem 11"),
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
            Image.network(
              "https://latex.artofproblemsolving.com/f/2/1/f2172172ab6cb261dfc95f73ad4d68405a6f0ff5.png",
            ),
            const SizedBox(height: 20),
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