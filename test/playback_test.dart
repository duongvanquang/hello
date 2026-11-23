import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import 'package:hello/common/app_playback.dart';
import 'package:hello/common/app_strings.dart';
import 'package:hello/common/app_watch_providers.dart';
import 'package:hello/models/movie.dart';
import 'package:hello/pages/trailer_page.dart';
import 'package:hello/repositories/movie_source_repository.dart';
import 'package:hello/widgets/where_to_watch_sheet.dart';

import 'helpers/test_app.dart';

Movie _movieReleased(DateTime? date) =>
    Movie(id: 1, title: 'Phim', description: '', rating: 7, releaseDate: date);

void main() {
  final today = DateTime.now();
  final upcoming = _movieReleased(today.add(const Duration(days: 30)));
  final released = _movieReleased(today.subtract(const Duration(days: 30)));

  group('Phim sắp chiếu hay đã ra', () {
    test('Ngày chiếu sau hôm nay là sắp chiếu', () {
      expect(upcoming.isUpcoming, isTrue);
      expect(AppPlayback.labelFor(upcoming), AppStrings.watchTrailer);
    });

    test('Đã chiếu (kể cả hôm nay) là đã ra', () {
      expect(released.isUpcoming, isFalse);
      expect(_movieReleased(today).isUpcoming, isFalse);
      expect(AppPlayback.labelFor(released), AppStrings.watchMovie);
    });

    test('Chưa biết ngày chiếu thì coi như đã ra', () {
      expect(_movieReleased(null).isUpcoming, isFalse);
    });

    test('Chưa nối nguồn phim thì không có link phim đầy đủ', () async {
      expect(
        await const MovieSourceRepository().findFullMovie(released),
        isNull,
      );
    });
  });

  Widget playButton(Movie movie) => testApp(
    Builder(
      builder: (context) => TextButton(
        onPressed: () => AppPlayback.play(context, movie),
        child: const Text('play'),
      ),
    ),
  );

  testWidgets('Phim sắp chiếu: mở thẳng trailer', (tester) async {
    await tester.pumpWidget(playButton(upcoming));
    await tester.tap(find.text('play'));
    await tester.pumpAndSettle();

    expect(find.byType(TrailerPage), findsOneWidget);
    expect(find.byType(WhereToWatchSheet), findsNothing);
  });

  testWidgets('Phim đã ra, chưa có nguồn: mở bảng Xem phim ở đâu', (
    tester,
  ) async {
    await tester.pumpWidget(playButton(released));
    await tester.tap(find.text('play'));
    await tester.pumpAndSettle();

    expect(find.byType(WhereToWatchSheet), findsOneWidget);
    expect(find.text(AppStrings.whereToWatch), findsOneWidget);
    for (final provider in AppWatchProviders.all) {
      expect(find.text(provider.name), findsOneWidget);
    }

    // Chọn "Xem trailer" trong bảng thì đóng bảng và mở trailer.
    await tester.tap(find.text(AppStrings.watchTrailer));
    await tester.pumpAndSettle();
    expect(find.byType(WhereToWatchSheet), findsNothing);
    expect(find.byType(TrailerPage), findsOneWidget);
  });

  test('Link tìm kiếm có tên phim (mã hóa dấu tiếng Việt, dấu cách)', () {
    final uri = AppWatchProviders.all.first.searchUriFor('Biển Sao');
    expect(uri.queryParameters.values.first, 'Biển Sao');
    expect(uri.toString(), isNot(contains(' ')));
  });
}
