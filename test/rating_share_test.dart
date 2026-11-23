import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:material_ui/material_ui.dart';

import 'package:hello/common/app_strings.dart';
import 'package:hello/models/media_type.dart';
import 'package:hello/models/movie.dart';
import 'package:hello/repositories/movie_repository.dart';
import 'package:hello/widgets/movie_action_row.dart';
import 'package:hello/widgets/rating_sheet.dart';

import 'helpers/test_app.dart';

const _movie = Movie(id: 42, title: 'Phim Hay', description: '', rating: 7);

void main() {
  late List<http.Request> requests;
  late MovieRepository repository;

  setUp(() {
    requests = [];
    repository = fakeRepository(
      client: MockClient((request) async {
        requests.add(request);
        final body = request.url.path.endsWith('/guest_session/new')
            ? {'success': true, 'guest_session_id': 'guest-1'}
            : {'success': true};
        return http.Response.bytes(utf8.encode(jsonEncode(body)), 201);
      }),
    );
  });

  test('Chấm 4 sao gửi 8 điểm lên TMDB bằng phiên khách', () async {
    await repository.rate(_movie, 4);

    final post = requests.last;
    expect(post.method, 'POST');
    expect(post.url.path, '/3/movie/42/rating');
    expect(post.url.queryParameters['guest_session_id'], 'guest-1');
    expect(jsonDecode(post.body), {'value': 8});

    // Lần chấm sau dùng lại phiên khách, không tạo phiên mới.
    await repository.rate(_movie, 5);
    final sessions = requests.where(
      (r) => r.url.path.endsWith('/guest_session/new'),
    );
    expect(sessions, hasLength(1));
  });

  testWidgets('Bảng đánh giá: chọn sao, gửi, nút đổi thành "Đã chấm"', (
    tester,
  ) async {
    await tester.pumpWidget(
      testApp(
        const Scaffold(body: MovieActionRow(movie: _movie)),
        repository: repository,
      ),
    );
    expect(find.text(AppStrings.rate), findsOneWidget);

    await tester.tap(find.text(AppStrings.rate));
    await tester.pumpAndSettle();
    expect(find.byType(RatingSheet), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('star-4')));
    await tester.tap(find.text(AppStrings.rateSubmit));
    await tester.pumpAndSettle();

    expect(find.byType(RatingSheet), findsNothing);
    expect(find.text(AppStrings.rateThanks), findsOneWidget);
    expect(find.text(AppStrings.rated(4)), findsOneWidget);
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
