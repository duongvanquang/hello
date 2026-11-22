import 'package:http/http.dart' as http;

import '../common/app_config.dart';
import '../common/app_strings.dart';
import 'api_client.dart';
import 'api_exception.dart';

/// API phim TMDB, dựng trên [ApiClient] dùng chung.
/// Chỉ lo phần riêng của TMDB: địa chỉ, khóa API, ngôn ngữ, câu báo lỗi khóa.
class TmdbApi {
  TmdbApi({http.Client? client, String? apiKey})
    : _apiKey = apiKey ?? AppConfig.tmdbApiKey,
      _client = ApiClient(
        baseUrl: 'https://${AppConfig.tmdbHost}/3',
        defaultQuery: {'api_key': apiKey ?? AppConfig.tmdbApiKey},
        httpClient: client,
      );

  final String _apiKey;
  final ApiClient _client;

  /// `GET https://api.themoviedb.org/3{path}`.
  Future<Map<String, dynamic>> get(
    String path, {
    String language = AppConfig.tmdbLanguage,
    Map<String, String> query = const {},
  }) => _call(() => _client.get(path, query: {'language': language, ...query}));

  /// `POST https://api.themoviedb.org/3{path}` với [body] dạng JSON.
  Future<Map<String, dynamic>> post(
    String path, {
    required Map<String, Object?> body,
    Map<String, String> query = const {},
  }) => _call(() => _client.post(path, body: body, query: query));

  Future<Map<String, dynamic>> _call(Future<dynamic> Function() request) async {
    if (_apiKey.isEmpty) throw const ApiException(AppStrings.missingApiKey);
    try {
      final json = await request();
      return json is Map<String, dynamic> ? json : <String, dynamic>{};
    } on ApiException catch (e) {
      if (e.isUnauthorized) {
        throw ApiException(AppStrings.invalidApiKey, statusCode: e.statusCode);
      }
      rethrow;
    }
  }
}
