import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:hello/blocs/load_status.dart';
import 'package:hello/blocs/search/search_bloc.dart';
import 'package:hello/blocs/search/search_query_changed.dart';
import 'package:hello/blocs/search/search_state.dart';
import 'package:hello/common/app_durations.dart';

import '../helpers/test_app.dart';

void main() {
  blocTest<SearchBloc, SearchState>(
    'Gõ liên tục chỉ tìm một lần với chữ cuối cùng',
    build: () => SearchBloc(fakeRepository()),
    act: (bloc) {
      bloc
        ..add(const SearchQueryChanged('p'))
        ..add(const SearchQueryChanged('ph'))
        ..add(const SearchQueryChanged('phim'));
    },
    wait: AppDurations.searchDebounce * 2,
    expect: () => [
      const SearchState(query: 'phim', status: LoadStatus.loading),
      isA<SearchState>()
          .having((s) => s.query, 'query', 'phim')
          .having((s) => s.status, 'status', LoadStatus.success)
          .having((s) => s.movies, 'movies', isNotEmpty),
    ],
  );

  blocTest<SearchBloc, SearchState>(
    'Xóa hết chữ thì quay về trạng thái ban đầu',
    build: () => SearchBloc(fakeRepository()),
    seed: () => const SearchState(query: 'phim', status: LoadStatus.success),
    act: (bloc) => bloc.add(const SearchQueryChanged('')),
    expect: () => [const SearchState()],
  );

  blocTest<SearchBloc, SearchState>(
    'Thử lại thì tìm ngay, không chờ',
    build: () => SearchBloc(fakeRepository()),
    seed: () => const SearchState(query: 'phim', status: LoadStatus.failure),
    act: (bloc) => bloc.add(const SearchQueryChanged('phim', retry: true)),
    expect: () => [
      const SearchState(query: 'phim', status: LoadStatus.loading),
      isA<SearchState>().having((s) => s.status, 'status', LoadStatus.success),
    ],
  );
}
