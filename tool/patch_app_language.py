# One-off: wire AppLanguage into all year2025 problem pages
import pathlib

root = pathlib.Path(__file__).resolve().parent.parent / "lib" / "screens" / "problems"
for p in sorted(root.glob("year2025_problem*_page.dart")):
    t = p.read_text(encoding="utf-8")
    if "app_language.dart" in t:
        print("skip", p.name)
        continue
    if "flutter_math_fork" in t:
        t = t.replace(
            "import 'package:flutter_math_fork/flutter_math.dart';\nimport 'package:amc8/data/db_helper.dart';",
            "import 'package:flutter_math_fork/flutter_math.dart';\nimport 'package:amc8/core/app_language.dart';\nimport 'package:amc8/data/db_helper.dart';",
        )
    else:
        t = t.replace(
            "import 'package:flutter/material.dart';\nimport 'package:amc8/data/db_helper.dart';",
            "import 'package:flutter/material.dart';\nimport 'package:amc8/core/app_language.dart';\nimport 'package:amc8/data/db_helper.dart';",
        )
    t = t.replace("String _currentLanguage = 'en';", "late String _currentLanguage;")
    t = t.replace(
        """  @override
  void initState() {
    super.initState();
    _loadData();
  }""",
        """  @override
  void initState() {
    super.initState();
    _currentLanguage = AppLanguage.code;
    _loadData();
  }""",
    )
    t = t.replace(
        """            onChanged: (val) {
              if (val != null) {
                setState(() => _currentLanguage = val);
                _loadData();
              }
            },""",
        """            onChanged: (val) {
              if (val != null) {
                AppLanguage.setCode(val);
                setState(() => _currentLanguage = val);
                _loadData();
              }
            },""",
    )
    t = t.replace(
        """            onChanged: (val) {
              if (val != null) {
                setState(() {
                  _currentLanguage = val;
                });
                _loadData();
              }
            },""",
        """            onChanged: (val) {
              if (val != null) {
                AppLanguage.setCode(val);
                setState(() {
                  _currentLanguage = val;
                });
                _loadData();
              }
            },""",
    )
    p.write_text(t, encoding="utf-8")
    print("OK", p.name)
