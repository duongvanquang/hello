import 'dart:async';
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import 'package:hello/common/app_strings.dart';
import 'package:hello/services/api_client.dart';
import 'package:hello/services/api_exception.dart';

void main() {
  late http.Request lastRequest;

  ApiClient clientReturning(
    int status, [
    Object? body,
    Duration timeout = const Duration(seconds: 5),
  ]) {
    return ApiClient(
      baseUrl: 'https://example.com/api',
      defaultQuery: {'key': 'abc'},
      defaultHeaders: {'X-App': 'test'},
      timeout: timeout,
      httpClient: MockClient((request) async {
        lastRequest = request;
        final bytes = body == null ? <int>[] : utf8.encode(jsonEncode(body));
        return http.Response.bytes(bytes, status);
      }),
    );
  }

  test('GET ghép đúng URL, query và header, đọc JSON tiếng Việt', () async {
    final client = clientReturning(200, {'title': 'Phim hay'});

    final json = await client.get('/movies', query: {'page': '2'});

    expect(json, {'title': 'Phim hay'});
    expect(lastRequest.method, 'GET');
    expect(
      lastRequest.url.toString(),
      'https://example.com/api/movies?key=abc&page=2',
    );
    expect(lastRequest.headers['X-App'], 'test');
  });

  test('POST gửi body dạng JSON', () async {
    final client = clientReturning(201, {'id': 1});

    await client.post('/users', body: {'name': 'Quang'});

    expect(lastRequest.method, 'POST');
    expect(lastRequest.headers['Content-Type'], contains('application/json'));
    expect(jsonDecode(lastRequest.body), {'name': 'Quang'});
  });

  test('Không có nội dung trả về thì nhận null', () async {
    final client = clientReturning(204);
    expect(await client.delete('/users/1'), isNull);
  });

  test('Mã lỗi HTTP đổi thành ApiException có câu tiếng Việt', () async {
    await expectLater(
      clientReturning(404).get('/x'),
      throwsA(
        isA<ApiException>()
            .having((e) => e.statusCode, 'statusCode', 404)
            .having((e) => e.message, 'message', AppStrings.notFound),
      ),
    );
    await expectLater(
      clientReturning(401).get('/x'),
      throwsA(isA<ApiException>().having((e) => e.isUnauthorized, '401', true)),
    );
  });

  test('Mất mạng thì báo "Không có kết nối mạng."', () async {
    final client = ApiClient(
      baseUrl: 'https://example.com',
      httpClient: MockClient(
        (_) async => throw http.ClientException('offline'),
      ),
    );
    await expectLater(
      client.get('/x'),
      throwsA(
        isA<ApiException>().having(
          (e) => e.message,
          'message',
          AppStrings.noNetwork,
        ),
      ),
    );
  });

  test('Quá thời gian chờ thì báo mạng chậm', () async {
    final client = ApiClient(
      baseUrl: 'https://example.com',
      timeout: const Duration(milliseconds: 10),
      httpClient: MockClient((_) => Completer<http.Response>().future),
    );
    await expectLater(
      client.get('/x'),
      throwsA(
        isA<ApiException>().having(
          (e) => e.message,
          'message',
          AppStrings.networkTimeout,
        ),
      ),
    );
  });
}
