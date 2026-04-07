// dart run tool/patch_app_language.dart
import 'dart:io';

void main() {
  final scriptDir = File(Platform.script.toFilePath()).parent;
  final lib = Directory('${scriptDir.parent.path}${Platform.pathSeparator}lib');
  if (!lib.existsSync()) {
    stderr.writeln('Missing lib: ${lib.path}');
    exit(1);
  }

  final files = lib
      .listSync()
      .whereType<File>()
      .where((f) => RegExp(r'year2025_problem\d+_page\.dart$').hasMatch(f.path))
      .toList()
    ..sort((a, b) => a.path.compareTo(b.path));

  const initOld = '''  @override
  void initState() {
    super.initState();
    _loadData();
  }''';

  const initNew = '''  @override
  void initState() {
    super.initState();
    _currentLanguage = AppLanguage.code;
    _loadData();
  }''';

  const changedArrowOld = '''            onChanged: (val) {
              if (val != null) {
                setState(() => _currentLanguage = val);
                _loadData();
              }
            },''';

  const changedArrowNew = '''            onChanged: (val) {
              if (val != null) {
                AppLanguage.setCode(val);
                setState(() => _currentLanguage = val);
                _loadData();
              }
            },''';

  const changedBlockOld = '''            onChanged: (val) {
              if (val != null) {
                setState(() {
                  _currentLanguage = val;
                });
                _loadData();
              }
            },''';

  const changedBlockNew = '''            onChanged: (val) {
              if (val != null) {
                AppLanguage.setCode(val);
                setState(() {
                  _currentLanguage = val;
                });
                _loadData();
              }
            },''';

  for (final p in files) {
    var t = p.readAsStringSync().replaceAll('\r\n', '\n');

    if (!t.contains("import 'package:amc8/core/app_language.dart';")) {
      if (t.contains('flutter_math_fork')) {
        t = t.replaceFirst(
          "import 'package:flutter_math_fork/flutter_math.dart';",
          "import 'package:flutter_math_fork/flutter_math.dart';\nimport 'package:amc8/core/app_language.dart';",
        );
      } else {
        t = t.replaceFirst(
          "import 'package:flutter/material.dart';",
          "import 'package:flutter/material.dart';\nimport 'package:amc8/core/app_language.dart';",
        );
      }
    }

    if (!t.contains('late String _currentLanguage;')) {
      t = t.replaceAll("String _currentLanguage = 'en';", 'late String _currentLanguage;');
    }

    if (t.contains(initOld) && !t.contains('_currentLanguage = AppLanguage.code;')) {
      t = t.replaceFirst(initOld, initNew);
    }

    if (t.contains(changedArrowOld)) {
      t = t.replaceFirst(changedArrowOld, changedArrowNew);
    }
    if (t.contains(changedBlockOld)) {
      t = t.replaceFirst(changedBlockOld, changedBlockNew);
    }

    p.writeAsStringSync(t);
    print('OK ${p.uri.pathSegments.last}');
  }
}
