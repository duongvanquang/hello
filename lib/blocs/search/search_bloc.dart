import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../common/app_durations.dart';
import '../../repositories/movie_repository.dart';
import '../../services/api_exception.dart';
import '../load_status.dart';
import 'search_query_changed.dart';
import 'search_state.dart';

/// Tìm phim lẻ và phim bộ theo tên.
/// Đợi người dùng ngừng gõ một lúc rồi mới gọi API; gõ tiếp thì hủy lần cũ.
class SearchBloc extends Bloc<SearchQueryChanged, SearchState> {
  SearchBloc(this._repository) : super(const SearchState()) {
    on<SearchQueryChanged>(_onQueryChanged, transformer: restartable());
  }

  final MovieRepository _repository;

  Future<void> _onQueryChanged(
    SearchQueryChanged event,
    Emitter<SearchState> emit,
  ) async {
    final query = event.query.trim();
    if (!event.retry && query == state.query) return;
    if (query.isEmpty) {
      emit(const SearchState());
      return;
    }
    if (!event.retry) await Future<void>.delayed(AppDurations.searchDebounce);

    emit(SearchState(query: query, status: LoadStatus.loading));
    try {
      final movies = await _repository.search(query);
      emit(
        SearchState(query: query, status: LoadStatus.success, movies: movies),
      );
    } on ApiException catch (e) {
      emit(
        SearchState(
          query: query,
          status: LoadStatus.failure,
          errorMessage: e.message,
        ),
      );
    }
  }
}
