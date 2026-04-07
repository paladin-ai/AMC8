import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:amc8/services/session_prefs.dart';

/// API 根地址。生产默认直连服务器；Flutter Web 本地调试若遇 CORS，先运行
/// `python tool/dev_api_proxy.py`，再：
/// `flutter run -d chrome --dart-define=API_BASE_URL=http://127.0.0.1:8787`
const String baseUrl = String.fromEnvironment(
  'API_BASE_URL',
  defaultValue: 'http://47.76.160.69',
);

/// 登录接口 `app_name`（与后端约定，例如 `AMC8`）
const String kApiAppName = 'AMC8';

/// 创建用户时的 `app_relation`（与后端约定）
const String kApiAppRelation = 'amc8';

/// 创建用户时的默认 `expire_time`（按后端要求的格式调整）
const String kApiDefaultUserExpireTime = '2099-12-31 23:59:59';

/// 将 Dio 返回体统一成 Map，并处理 HTTP 非 2xx 仍带 JSON 的情况。
Map<String, dynamic> _parseApiBody(dynamic raw, {int? httpStatus}) {
  if (raw == null) {
    return {
      'code': -1,
      'msg': httpStatus != null
          ? 'Empty response (HTTP $httpStatus)'
          : 'Empty response',
    };
  }
  if (raw is Map<String, dynamic>) return raw;
  if (raw is Map) return Map<String, dynamic>.from(raw);
  if (raw is String) {
    final s = raw.trim();
    if (s.isEmpty) {
      return {'code': -1, 'msg': 'Empty response'};
    }
    try {
      final decoded = jsonDecode(s);
      if (decoded is Map<String, dynamic>) return decoded;
      if (decoded is Map) return Map<String, dynamic>.from(decoded);
    } catch (_) {
      /* 非 JSON 字符串 */
    }
    return {'code': -1, 'msg': s};
  }
  return {'code': -1, 'msg': raw.toString()};
}

/// 业务 code 是否表示成功（兼容 int / String）。
bool _bizCodeOk(dynamic code) => code == 200 || code == '200';

/// 从整包 JSON 里取 token / expire（支持嵌套在 `data` 下）。
Future<void> _persistLoginTokens(Map<String, dynamic> root) async {
  Map<String, dynamic> bag = root;
  final nested = root['data'];
  if (nested is Map) {
    bag = Map<String, dynamic>.from(nested);
  }

  final token = bag['token'] ?? root['token'];
  final expire = bag['expire_time'] ?? bag['expireTime'] ?? root['expire_time'];

  final prefs = await SharedPreferences.getInstance();
  if (token is String && token.isNotEmpty) {
    await prefs.setString('token', token);
  }
  if (expire is String && expire.isNotEmpty) {
    await prefs.setString('expire_time', expire);
  }
}

/// 从登录 / 用户信息 JSON 中解析 full name（兼容多种字段与 `data` 嵌套）。
String? extractFullNameFromApiMap(Map<String, dynamic> root) {
  String? pick(Map<String, dynamic> m) {
    for (final key in [
      'full_name',
      'fullName',
      'real_name',
      'name',
      'display_name',
      'nickname',
    ]) {
      final v = m[key];
      if (v is String && v.trim().isNotEmpty) return v.trim();
    }
    return null;
  }

  final fromRoot = pick(root);
  if (fromRoot != null) return fromRoot;
  final nested = root['data'];
  if (nested is Map) {
    return pick(Map<String, dynamic>.from(nested));
  }
  return null;
}

/// 封装 Dio 与 JWT（SharedPreferences key: `token` / `expire_time`）
class ApiService {
  ApiService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        /// 关键：不要用默认「仅 2xx 成功」，否则 401/400 带 JSON 时会进 DioException，
        /// 客户端只能看到 “bad response” 而看不到后端的 msg。
        validateStatus: (status) => status != null && status < 600,
        headers: {
          Headers.acceptHeader: 'application/json',
        },
        // 不在全局设置 contentType，避免 GET 也带上 application/json 导致部分网关/服务异常
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final prefs = await SharedPreferences.getInstance();
          final token = prefs.getString('token');
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          if (kDebugMode) {
            debugPrint('→ ${options.method} ${options.uri}');
          }
          handler.next(options);
        },
        onResponse: (response, handler) {
          if (kDebugMode) {
            debugPrint(
              '← ${response.statusCode} ${response.requestOptions.uri}',
            );
          }
          handler.next(response);
        },
        onError: (e, handler) {
          if (kDebugMode) {
            debugPrint(
              'API错误：${e.type} ${e.message} '
              'status=${e.response?.statusCode} data=${e.response?.data}',
            );
          }
          handler.next(e);
        },
      ),
    );
  }

  late final Dio _dio;

  Map<String, dynamic> _wrapNetworkError(DioException e) {
    final status = e.response?.statusCode;
    final fromBody = e.response?.data != null
        ? _parseApiBody(e.response!.data, httpStatus: status)
        : null;

    if (fromBody != null &&
        (fromBody.containsKey('code') || fromBody.containsKey('msg'))) {
      return fromBody;
    }

    String msg = 'Network request failed';
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        msg = 'Connection timed out. Check your network and try again.';
      case DioExceptionType.connectionError:
        msg = "Can't reach the server. Check your network or the server address.";
        if (kIsWeb) {
          msg =
              "$msg On Flutter Web, the browser may block cross-origin HTTP (CORS): "
              "enable CORS on the API, or run tool/dev_api_proxy.py and use "
              "--dart-define=API_BASE_URL=http://127.0.0.1:8787";
        }
      case DioExceptionType.badCertificate:
        msg = 'Certificate error';
      case DioExceptionType.badResponse:
        msg = status != null
            ? 'Server returned HTTP $status'
            : 'Unexpected server response';
      default:
        msg = e.message ?? msg;
    }
    return {'code': -1, 'msg': msg};
  }

  // --------------- 核心接口封装 ---------------

  /// 用户登录（返回令牌、过期时间）
  Future<Map<String, dynamic>> login({
    required String username,
    required String password,
    required String appName,
  }) async {
    try {
      // 与 Swagger 一致：POST + query 参数，body 为空（curl 里 -d ''）
      final response = await _dio.post(
        '/api/auth/login',
        queryParameters: {
          'username': username,
          'password': password,
          'app_name': appName,
        },
        options: Options(
          contentType: null,
          headers: {Headers.acceptHeader: 'application/json'},
        ),
      );

      final data = _parseApiBody(response.data, httpStatus: response.statusCode);

      if (kDebugMode) {
        debugPrint('login body: $data');
      }

      final httpOk = response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300;
      if (!httpOk && !data.containsKey('code')) {
        data['code'] = -1;
        data['msg'] = data['msg'] ?? 'HTTP ${response.statusCode}';
      }

      if (_bizCodeOk(data['code'])) {
        await _persistLoginTokens(data);
        await refreshProfileAfterLogin(
          username: username,
          loginBody: data,
        );
      }

      return data;
    } on DioException catch (e) {
      return _wrapNetworkError(e);
    }
  }

  /// 创建用户
  Future<Map<String, dynamic>> createUser({
    required String username,
    required String password,
    required String fullName,
    required String appRelation,
    required String expireTime,
  }) async {
    try {
      final response = await _dio.post(
        '/api/user/create',
        queryParameters: {
          'username': username,
          'password': password,
          'full_name': fullName,
          'app_relation': appRelation,
          'expire_time': expireTime,
        },
        options: Options(
          contentType: null,
          headers: {Headers.acceptHeader: 'application/json'},
        ),
      );
      final data = _parseApiBody(response.data, httpStatus: response.statusCode);
      return data;
    } on DioException catch (e) {
      return _wrapNetworkError(e);
    }
  }

  /// 查询用户信息
  Future<Map<String, dynamic>> getUserInfo({required String username}) async {
    try {
      final response = await _dio.get(
        '/api/user/info',
        queryParameters: {'username': username},
      );
      return _parseApiBody(response.data, httpStatus: response.statusCode);
    } on DioException catch (e) {
      return _wrapNetworkError(e);
    }
  }

  /// 更新用户全名（与 Swagger 中 POST + query 风格一致；若路径不同请改此处）。
  Future<Map<String, dynamic>> updateUserFullName({
    required String username,
    required String fullName,
  }) async {
    try {
      final response = await _dio.post(
        '/api/user/update',
        queryParameters: {
          'username': username,
          'full_name': fullName,
        },
        options: Options(
          contentType: null,
          headers: {Headers.acceptHeader: 'application/json'},
        ),
      );
      return _parseApiBody(response.data, httpStatus: response.statusCode);
    } on DioException catch (e) {
      return _wrapNetworkError(e);
    }
  }

  /// 登录成功后写入用户名，并尽量写入 [SessionPrefs.keyFullName]（登录体或 `/api/user/info`）。
  Future<void> refreshProfileAfterLogin({
    required String username,
    required Map<String, dynamic> loginBody,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(SessionPrefs.keyUsername, username);

    var name = extractFullNameFromApiMap(loginBody);
    if (name == null || name.isEmpty) {
      final info = await getUserInfo(username: username);
      if (_bizCodeOk(info['code'])) {
        name = extractFullNameFromApiMap(info);
      }
    }
    if (name != null && name.isNotEmpty) {
      await prefs.setString(SessionPrefs.keyFullName, name);
    } else {
      await prefs.remove(SessionPrefs.keyFullName);
    }
  }

  /// 退出登录（清除本地令牌）
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('expire_time');
    await prefs.remove(SessionPrefs.keyUsername);
    await prefs.remove(SessionPrefs.keyFullName);
  }
}

/// 全局单例，避免重复创建 [Dio] 与拦截器。
final ApiService appApiService = ApiService();
