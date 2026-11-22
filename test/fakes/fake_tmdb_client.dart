import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

/// HTTP client giả cho test: trả về JSON giống TMDB, không cần mạng hay khóa thật.
class FakeTmdbClient {
  FakeTmdbClient._();

  static const featuredTitle = 'Phim Nổi Bật';
  static const featuredOverview = 'Mô tả phim nổi bật.';

  static Map<String, dynamic> _movie(int id, String title) => {
    'id': id,
    'title': title,
    'overview': id == 1 ? featuredOverview : '',
    'vote_average': 7.5,
    'release_date': '2026-01-01',
    'genre_ids': [28],
    'poster_path': '/p$id.jpg',
    'backdrop_path': '/b$id.jpg',
    'adult': false,
  };

  static http.Client create({int statusCode = 200}) {
    return MockClient((request) async {
      if (statusCode != 200) return http.Response('{}', statusCode);
      final path = request.url.path;

      final Object body;
      if (path.contains('/genre/')) {
        body = {
          'genres': [
            {'id': 28, 'name': 'Hành động'},
            {'id': 35, 'name': 'Hài'},
          ],
        };
      } else if (RegExp(r'/(movie|tv)/\d+$').hasMatch(path)) {
        body = {
          ..._movie(1, featuredTitle),
          'runtime': 128,
          'genres': [
            {'id': 28, 'name': 'Hành động'},
          ],
        };
      } else {
        body = {
          'results': [
            _movie(1, featuredTitle),
            _movie(2, 'Phim Thứ Hai'),
            _movie(3, 'Phim Thứ Ba'),
          ],
        };
      }
      return http.Response.bytes(utf8.encode(jsonEncode(body)), 200);
    });
  }
}
