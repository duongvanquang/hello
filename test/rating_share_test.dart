import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:material_ui/material_ui.dart';

import 'package:hello/common/app_strings.dart';
import 'package:hello/data/user_ratings.dart';
import 'package:hello/models/media_type.dart';
import 'package:hello/models/movie.dart';
import 'package:hello/repositories/movie_repository.dart';
import 'package:hello/services/tmdb_api.dart';
import 'package:hello/widgets/rating_sheet.dart';

const _movie = Movie(id: 42, title: 'Phim Hay', description: '', rating: 7);

void main() {
  late List<http.Request> requests;

  setUp(() {
    requests = [];
    UserRatings.stars.value = const {};
    MovieRepository.instance = MovieRepository(
      api: TmdbApi(
        apiKey: 'test-key',
        client: MockClient((request) async {
          requests.add(request);
          final body = request.url.path.endsWith('/guest_session/new')
              ? {'success': true, 'guest_session_id': 'guest-1'}
              : {'success': true};
          return http.Response.bytes(utf8.encode(jsonEncode(body)), 201);
        }),
      ),
    );
  });

  test('Chấm 4 sao gửi 8 điểm lên TMDB bằng phiên khách', () async {
    await MovieRepository.instance.rate(_movie, 4);

    final post = requests.last;
    expect(post.method, 'POST');
    expect(post.url.path, '/3/movie/42/rating');
    expect(post.url.queryParameters['guest_session_id'], 'guest-1');
    expect(jsonDecode(post.body), {'value': 8});

    // Lần chấm sau dùng lại phiên khách, không tạo phiên mới.
    await MovieRepository.instance.rate(_movie, 5);
    final sessions = requests.where(
      (r) => r.url.path.endsWith('/guest_session/new'),
    );
    expect(sessions, hasLength(1));
  });

  testWidgets('Bảng đánh giá: chọn sao, gửi, lưu số sao đã chấm', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => TextButton(
              onPressed: () => RatingSheet.show(context, _movie),
              child: const Text('open'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    expect(find.text(AppStrings.rateTitle), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('star-4')));
    await tester.tap(find.text(AppStrings.rateSubmit));
    await tester.pumpAndSettle();

    expect(UserRatings.of(_movie), 4);
    expect(find.text(AppStrings.rateThanks), findsOneWidget);
  });

  test('Nội dung chia sẻ có tên phim, năm và link TMDB', () {
    final movie = Movie(
      id: 7,
      title: 'Phim Bộ',
      description: '',
      rating: 8,
      mediaType: MediaType.tv,
      releaseDate: DateTime(2024),
    );
    final text = AppStrings.shareMovie(movie.title, movie.year, movie.webUrl);
    expect(text, contains('Phim Bộ (2024)'));
    expect(text, contains('https://www.themoviedb.org/tv/7'));
  });
}
