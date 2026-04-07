import 'dart:async';

import 'package:amc8/services/api_service.dart';

/// 登录 / 注册 与后端交互（通过 [appApiService]）。
abstract final class AuthActions {
  AuthActions._();

  static bool _apiSuccess(Map<String, dynamic> res) {
    final c = res['code'];
    return c == 200 || c == '200';
  }

  static String _apiMessage(Map<String, dynamic> res) {
    final m = res['msg'] ?? res['message'];
    if (m == null) return 'Request failed';
    return m.toString();
  }

  /// [ApiService] 网络层失败时写入的 code（见 [_wrapNetworkError]）。
  static bool _isNetworkFailure(Map<String, dynamic> res) {
    final c = res['code'];
    return c == -1 || c == '-1';
  }

  /// `/api/user/info` 成功体里是否像有效用户（与线上返回的 `data.id` 等一致）。
  static bool _userInfoPayloadLooksValid(Map<String, dynamic> res) {
    final data = res['data'];
    if (data is! Map) return false;
    final map = Map<String, dynamic>.from(data);
    final id = map['id'];
    final u = map['username'];
    if (id != null) return true;
    if (u is String && u.trim().isNotEmpty) return true;
    return false;
  }

  /// 先 [ApiService.getUserInfo] 判断用户是否存在，再 [ApiService.login]。
  ///
  /// No account → English message; wrong password → English hint (network still uses API `msg` when present).
  static Future<void> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    final trimmed = email.trim();

    final info = await appApiService.getUserInfo(username: trimmed);
    if (_isNetworkFailure(info)) {
      throw AuthException(_apiMessage(info));
    }
    if (!_apiSuccess(info) || !_userInfoPayloadLooksValid(info)) {
      throw AuthException('No account found for this email.');
    }

    final res = await appApiService.login(
      username: trimmed,
      password: password,
      appName: kApiAppName,
    );
    if (!_apiSuccess(res)) {
      if (_isNetworkFailure(res)) {
        throw AuthException(_apiMessage(res));
      }
      throw AuthException('Check your password and try again.');
    }
  }

  static Future<void> signInWithGoogle() async {
    throw AuthException('Google sign-in is not available yet. Use email and password.');
  }

  static Future<void> requestPasswordReset({required String email}) async {
    throw AuthException('Password reset is not available in the app. Contact support or your admin.');
  }

  /// 调用 `/api/user/create`；邮箱作为 `username`。
  static Future<void> signUpWithEmailPassword({
    required String fullName,
    required String email,
    required String password,
  }) async {
    final res = await appApiService.createUser(
      username: email.trim(),
      password: password,
      fullName: fullName.trim(),
      appRelation: kApiAppRelation,
      expireTime: kApiDefaultUserExpireTime,
    );
    if (!_apiSuccess(res)) {
      throw AuthException(_apiMessage(res));
    }
  }

  static Future<void> signUpWithGoogle() async {
    throw AuthException('Google sign-up is not available yet. Register with email.');
  }

  /// 清除本地 JWT（可在首页退出登录时调用）。
  static Future<void> clearLocalSession() => appApiService.logout();
}

/// 抛给 UI 展示的错误文案。
class AuthException implements Exception {
  AuthException(this.message);
  final String message;

  @override
  String toString() => message;
}
