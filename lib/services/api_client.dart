import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../common/app_strings.dart';
import 'api_exception.dart';
import 'http_method.dart';
import '../common/app_durations.dart';
import '../common/http_status_code.dart';

/// Service chung để gọi mọi API REST trong app.
///
/// Lo hết phần lặp lại: ghép URL, query mặc định, header, timeout,
/// đọc JSON (UTF-8), đổi mọi lỗi thành [ApiException] có câu tiếng Việt.
///
/// Mỗi API dùng một ApiClient riêng, ví dụ:
/// ```dart
/// final client = ApiClient(
///   baseUrl: 'https://api.themoviedb.org/3',
///   defaultQuery: {'api_key': key},
/// );
/// final json = await client.get('/movie/popular');
/// final created = await client.post('/users', body: {'name': 'Quang'});
/// ```
class ApiClient {
  ApiClient({
    required this.baseUrl,
    this.defaultQuery = const {},
    this.defaultHeaders = const {},
    this.timeout = AppDurations.apiTimeout,
    http.Client? httpClient,
  }) : _http = httpClient ?? http.Client();

  /// Ví dụ `https://api.themoviedb.org/3` (không có dấu / ở cuối).
  final String baseUrl;

  /// Query gửi kèm mọi request (ví dụ khóa API, ngôn ngữ).
  final Map<String, String> defaultQuery;

  /// Header gửi kèm mọi request (ví dụ `Authorization`).
  final Map<String, String> defaultHeaders;

  final Duration timeout;
  final http.Client _http;

  Future<dynamic> get(
    String path, {
    Map<String, String> query = const {},
    Map<String, String> headers = const {},
  }) => send(HttpMethod.get, path, query: query, headers: headers);

  Future<dynamic> post(
    String path, {
    Object? body,
    Map<String, String> query = const {},
    Map<String, String> headers = const {},
  }) => send(HttpMethod.post, path, body: body, query: query, headers: headers);

  Future<dynamic> put(
    String path, {
    Object? body,
    Map<String, String> query = const {},
    Map<String, String> headers = const {},
  }) => send(HttpMethod.put, path, body: body, query: query, headers: headers);

  Future<dynamic> patch(
    String path, {
    Object? body,
    Map<String, String> query = const {},
    Map<String, String> headers = const {},
  }) =>
      send(HttpMethod.patch, path, body: body, query: query, headers: headers);

  Future<dynamic> delete(
    String path, {
    Map<String, String> query = const {},
    Map<String, String> headers = const {},
  }) => send(HttpMethod.delete, path, query: query, headers: headers);

  /// Gửi request và trả về JSON đã giải mã (Map, List...), hoặc null nếu
  /// server không trả nội dung. [body] là Map/List sẽ được gửi dạng JSON.
  Future<dynamic> send(
    HttpMethod method,
    String path, {
    Object? body,
    Map<String, String> query = const {},
    Map<String, String> headers = const {},
  }) async {
    final uri = buildUri(path, query);
    final request = http.Request(method.name.toUpperCase(), uri)
      ..headers.addAll({
        'Accept': 'application/json',
        ...defaultHeaders,
        ...headers,
      });
    if (body != null) {
      request.headers['Content-Type'] = 'application/json; charset=utf-8';
      request.bodyBytes = utf8.encode(jsonEncode(body));
    }

    final http.Response response;
    try {
      final streamed = await _http.send(request).timeout(timeout);
      response = await http.Response.fromStream(streamed).timeout(timeout);
    } on TimeoutException {
      throw const ApiException(AppStrings.networkTimeout);
    } catch (e) {
      _log('${method.name.toUpperCase()} $path → lỗi mạng: $e');
      throw const ApiException(AppStrings.noNetwork);
    }

    _log('${method.name.toUpperCase()} $path → ${response.statusCode}');
    final status = response.statusCode;
    if (!HttpStatusCode.isSuccess(status)) {
      throw ApiException(_messageFor(status), statusCode: status);
    }
    if (response.bodyBytes.isEmpty) return null;

    try {
      return jsonDecode(utf8.decode(response.bodyBytes));
    } on FormatException {
      throw ApiException(AppStrings.invalidResponse, statusCode: status);
    }
  }

  /// Ghép [baseUrl] + [path] + query mặc định + [query].
  Uri buildUri(String path, [Map<String, String> query = const {}]) {
    final base = Uri.parse(baseUrl);
    final cleanPath = path.startsWith('/') ? path : '/$path';
    final allQuery = {...defaultQuery, ...query};
    return base.replace(
      path: '${base.path}$cleanPath',
      queryParameters: allQuery.isEmpty ? null : allQuery,
    );
  }

  String _messageFor(int status) {
    if (HttpStatusCode.isUnauthorized(status)) return AppStrings.unauthorized;
    if (status == HttpStatusCode.notFound) return AppStrings.notFound;
    if (HttpStatusCode.isServerError(status)) {
      return AppStrings.withStatus(AppStrings.serverError, status);
    }
    return AppStrings.withStatus(AppStrings.requestFailed, status);
  }

  /// Ghi log khi chạy debug. Không in query vì có thể chứa khóa API.
  void _log(String message) {
    if (kDebugMode) debugPrint('[API] $message');
  }
}
