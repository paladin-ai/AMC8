import 'package:shared_preferences/shared_preferences.dart';

/// 登录后本地会话字段（与 [ApiService.logout] 一并清理）。
abstract final class SessionPrefs {
  SessionPrefs._();

  static const String keyUsername = 'session_username';
  static const String keyFullName = 'session_full_name';

  /// 仅本地存储的 `full_name`（无则 null，不套用邮箱前缀等展示规则）。
  static Future<String?> getStoredFullName() async {
    final p = await SharedPreferences.getInstance();
    final s = p.getString(keyFullName);
    if (s == null || s.trim().isEmpty) return null;
    return s.trim();
  }

  static Future<void> setFullName(String fullName) async {
    final p = await SharedPreferences.getInstance();
    final t = fullName.trim();
    if (t.isEmpty) {
      await p.remove(keyFullName);
    } else {
      await p.setString(keyFullName, t);
    }
  }

  /// 个人中心展示用（与 [getWelcomeDisplayName] 规则一致，并返回邮箱）。
  static Future<SessionProfileSnapshot> loadProfileSnapshot() async {
    final p = await SharedPreferences.getInstance();
    final email = p.getString(keyUsername) ?? '';
    final full = p.getString(keyFullName);
    var name = full?.trim() ?? '';
    if (name.isEmpty && email.contains('@')) {
      name = email.split('@').first;
    }
    if (name.isEmpty) name = 'Student';
    return SessionProfileSnapshot(displayName: name, email: email);
  }

  /// 欢迎语优先用全名，否则用邮箱 @ 前一段，再否则占位。
  static Future<String> getWelcomeDisplayName() async {
    final p = await SharedPreferences.getInstance();
    final full = p.getString(keyFullName);
    if (full != null && full.trim().isNotEmpty) return full.trim();
    final user = p.getString(keyUsername);
    if (user != null && user.contains('@')) {
      return user.split('@').first;
    }
    if (user != null && user.isNotEmpty) return user;
    return 'Student';
  }
}

/// 本地会话中的展示名与登录邮箱（邮箱即 API `username`）。
class SessionProfileSnapshot {
  const SessionProfileSnapshot({
    required this.displayName,
    required this.email,
  });

  final String displayName;
  final String email;
}
