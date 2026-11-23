import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import 'package:hello/app.dart';
import 'package:hello/common/app_strings.dart';
import 'package:hello/models/movie.dart';
import 'package:hello/pages/main_page.dart';
import 'package:hello/pages/movie_detail_page.dart';
import 'package:hello/pages/register_page.dart';
import 'package:hello/widgets/movie_poster.dart';
import 'package:hello/widgets/skeletons/home_skeleton.dart';
import 'package:hello/widgets/sliver_movie_grid.dart';

import 'fakes/fake_tmdb_client.dart';
import 'helpers/test_app.dart';

void main() {
  group('Đăng nhập', () {
    testWidgets('Chưa đăng nhập thì mở trang Đăng nhập', (tester) async {
      useIphoneSize(tester);
      await tester.pumpWidget(MyApp(movieRepository: fakeRepository()));
      await tester.pump();

      expect(find.text(AppStrings.loginSubtitle), findsOneWidget);
      expect(find.text(AppStrings.continueWithGoogle), findsOneWidget);
    });

    testWidgets('Bấm Đăng nhập khi để trống thì báo lỗi', (tester) async {
      useIphoneSize(tester);
      await tester.pumpWidget(MyApp(movieRepository: fakeRepository()));
      await tester.pump();

      await tester.tap(find.widgetWithText(FilledButton, AppStrings.login));
      await tester.pump();

      expect(find.text(AppStrings.emailRequired), findsOneWidget);
      expect(find.text(AppStrings.passwordRequired), findsOneWidget);
    });

    testWidgets('Đăng ký: mật khẩu nhập lại không khớp', (tester) async {
      useIphoneSize(tester);
      await tester.pumpWidget(MyApp(movieRepository: fakeRepository()));
      await tester.pump();

      await tester.tap(find.widgetWithText(TextButton, AppStrings.register));
      await tester.pumpAndSettle();
      expect(find.byType(RegisterPage), findsOneWidget);

      final fields = find.byType(TextFormField);
      await tester.enterText(fields.at(0), 'Quang');
      await tester.enterText(fields.at(1), 'test@example.com');
      await tester.enterText(fields.at(2), '123456');
      await tester.enterText(fields.at(3), '654321');
      await tester.tap(find.widgetWithText(FilledButton, AppStrings.register));
      await tester.pump();

      expect(find.text(AppStrings.passwordMismatch), findsOneWidget);
    });
  });

  group('Trang chủ (dữ liệu từ API)', () {
    Widget app({int statusCode = 200}) => testApp(
      const MainPage(),
      repository: fakeRepository(statusCode: statusCode),
    );

    testWidgets('Tải xong thì hiện banner và các hàng phim', (tester) async {
      useIphoneSize(tester);
      await tester.pumpWidget(app());
      expect(find.byType(HomeSkeleton), findsOneWidget); // shimmer khi đang tải

      await tester.pumpAndSettle();
      expect(find.text(AppStrings.featuredLabel), findsOneWidget);
      expect(find.text(FakeTmdbClient.featuredTitle), findsOneWidget);
      expect(find.text(AppStrings.rowTrending), findsOneWidget);
    });

    testWidgets('API lỗi thì hiện thông báo và nút Thử lại', (tester) async {
      useIphoneSize(tester);
      await tester.pumpWidget(app(statusCode: 401));
      await tester.pumpAndSettle();

      expect(find.text(AppStrings.invalidApiKey), findsOneWidget);
      expect(find.text(AppStrings.retry), findsOneWidget);
    });

    testWidgets('Bấm Thông tin mở chi tiết, có thời lượng và thể loại', (
      tester,
    ) async {
      useIphoneSize(tester);
      await tester.pumpWidget(app());
      await tester.pumpAndSettle();

      await tester.tap(find.text(AppStrings.info));
      await tester.pumpAndSettle();

      expect(find.byType(MovieDetailPage), findsOneWidget);
      expect(find.text(FakeTmdbClient.featuredOverview), findsOneWidget);
      expect(find.text(AppStrings.duration(2, 8)), findsOneWidget);
      expect(find.text(AppStrings.genreLine('Hành động')), findsOneWidget);

      await tester.tap(find.text(AppStrings.myList).last);
      await tester.pump();
      expect(find.text(AppStrings.addedToList), findsWidgets);
    });

    testWidgets('Chip Phim bộ tải các hàng phim bộ', (tester) async {
      useIphoneSize(tester);
      await tester.pumpWidget(app());
      await tester.pumpAndSettle();

      await tester.tap(find.text(AppStrings.tvSeries));
      await tester.pumpAndSettle();
      expect(find.text(AppStrings.rowTvTrending), findsOneWidget);

      // Bấm lại thì bỏ lọc.
      await tester.tap(find.text(AppStrings.tvSeries));
      await tester.pumpAndSettle();
      expect(find.text(AppStrings.rowTrending), findsOneWidget);
    });

    testWidgets('Chip Thể loại: chọn thể loại rồi hiện lưới phim', (
      tester,
    ) async {
      useIphoneSize(tester);
      await tester.pumpWidget(app());
      await tester.pumpAndSettle();

      await tester.tap(find.text(AppStrings.genre));
      await tester.pumpAndSettle();
      expect(find.text(AppStrings.chooseGenre), findsOneWidget);

      await tester.tap(find.text('Hài'));
      await tester.pumpAndSettle();
      expect(find.text('Hài'), findsOneWidget); // chip đổi tên thành thể loại
      expect(find.byType(SliverMovieGrid), findsOneWidget);
    });

    testWidgets('Tab Tìm kiếm gọi API khi gõ tên phim', (tester) async {
      useIphoneSize(tester);
      await tester.pumpWidget(app());
      await tester.pumpAndSettle();

      await tester.tap(find.text(AppStrings.tabSearch));
      await tester.pumpAndSettle();
      expect(find.text(AppStrings.searchStart), findsOneWidget);

      await tester.enterText(find.byType(TextField), 'phim');
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pumpAndSettle();
      expect(find.text(FakeTmdbClient.featuredTitle), findsNothing);
      expect(find.byType(MoviePoster), findsWidgets);
    });

    testWidgets('Tab Danh sách của tôi khi chưa lưu phim', (tester) async {
      useIphoneSize(tester);
      await tester.pumpWidget(app());
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.bookmark_border).last);
      await tester.pumpAndSettle();
      expect(find.text(AppStrings.myListEmpty), findsOneWidget);
    });
  });

  test('Movie.fromJson đọc đúng dữ liệu TMDB', () {
    final movie = Movie.fromJson(
      {
        'id': 7,
        'title': '',
        'original_title': 'Original',
        'overview': ' Mô tả ',
        'vote_average': 8,
        'release_date': '2024-05-02',
        'genre_ids': [28, 99],
        'poster_path': '/a.jpg',
        'backdrop_path': null,
        'runtime': 45,
      },
      genreNames: {28: 'Hành động'},
    );

    expect(movie.title, 'Original');
    expect(movie.description, 'Mô tả');
    expect(movie.year, 2024);
    expect(movie.genres, ['Hành động']);
    expect(movie.durationText, '45p');
    expect(movie.posterUrl, 'https://image.tmdb.org/t/p/w500/a.jpg');
    expect(movie.backdropUrl, movie.posterUrl);
  });
}
