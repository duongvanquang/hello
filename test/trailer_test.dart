import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:material_ui/material_ui.dart';

import 'package:hello/common/app_strings.dart';
import 'package:hello/models/movie.dart';
import 'package:hello/pages/trailer_page.dart';
import 'package:hello/repositories/movie_repository.dart';
import 'package:hello/services/tmdb_api.dart';

import 'helpers/test_app.dart';

const _movie = Movie(id: 1, title: 'Phim', description: '', rating: 7);

MovieRepository _repoWithVideos(List<Map<String, Object>> videos) {
  return MovieRepository(
    api: TmdbApi(
      apiKey: 'test-key',
      client: MockClient((request) async {
        final body = request.url.path.endsWith('/videos')
            ? {'results': videos}
            : {'results': <Object>[]};
        return http.Response.bytes(utf8.encode(jsonEncode(body)), 200);
      }),
    ),
  );
}

Map<String, Object> _video(
  String key, {
  String type = 'Trailer',
  bool official = true,
  String lang = 'en',
  String site = 'YouTube',
}) => {
  'key': key,
  'name': key,
  'site': site,
  'type': type,
  'official': official,
  'iso_639_1': lang,
};

void main() {
  test('Chọn trailer chính thức tiếng Việt trước', () async {
    final repo = _repoWithVideos([
      _video('teaser', type: 'Teaser'),
      _video('trailer-en'),
      _video('trailer-vi', lang: 'vi'),
      _video('vimeo', site: 'Vimeo', lang: 'vi'),
    ]);
    expect((await repo.loadTrailer(_movie))?.key, 'trailer-vi');
  });

  test('Không có trailer thì lấy teaser', () async {
    final repo = _repoWithVideos([
      _video('clip', type: 'Clip'),
      _video('teaser', type: 'Teaser'),
    ]);
    expect((await repo.loadTrailer(_movie))?.key, 'teaser');
  });

  test('Không có video YouTube thì trả về null', () async {
    final repo = _repoWithVideos([_video('vimeo', site: 'Vimeo')]);
    expect(await repo.loadTrailer(_movie), isNull);
  });

  testWidgets('Trang trailer báo khi phim chưa có trailer', (tester) async {
    await tester.pumpWidget(
      testApp(
        Builder(
          builder: (context) => TextButton(
            onPressed: () => TrailerPage.open(context, _movie),
            child: const Text('open'),
          ),
        ),
        repository: _repoWithVideos([]),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    expect(find.text(AppStrings.noTrailer), findsOneWidget);
  });
}
