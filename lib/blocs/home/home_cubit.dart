import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/genre.dart';
import '../../models/home_filter.dart';
import '../../models/media_type.dart';
import '../../repositories/movie_repository.dart';
import '../../services/api_exception.dart';
import '../load_status.dart';
import 'home_state.dart';

/// Logic trang chủ: chọn bộ lọc, tải phim tương ứng, tải lại.
class HomeCubit extends Cubit<HomeState> {
  HomeCubit(this._repository) : super(const HomeState());

  final MovieRepository _repository;

  /// Bấm một chip lọc. Bấm lại chip đang chọn thì bỏ lọc.
  Future<void> selectFilter(HomeFilter filter) {
    final next = filter == state.filter ? HomeFilter.all : filter;
    emit(HomeState(filter: next, genre: state.genre));
    return load();
  }

  /// Chọn một thể loại trong bảng chọn.
  Future<void> selectGenre(Genre genre) {
    emit(HomeState(filter: HomeFilter.genre, genre: genre));
    return load();
  }

  /// Tải (hoặc tải lại) dữ liệu cho bộ lọc hiện tại.
  Future<void> load() async {
    final filter = state.filter;
    final genreId = state.genre?.id;
    if (filter == HomeFilter.myList) {
      // Danh sách của tôi lấy từ MyListCubit, không cần gọi API.
      emit(state.copyWith(status: LoadStatus.success));
      return;
    }
    emit(state.copyWith(status: LoadStatus.loading));
    try {
      if (filter == HomeFilter.genre) {
        final movies = await _repository.loadByGenre(state.genre!);
        if (_isStale(filter, genreId)) return;
        emit(state.copyWith(status: LoadStatus.success, genreMovies: movies));
      } else {
        final data = await _repository.loadHome(type: _typeOf(filter));
        if (_isStale(filter, genreId)) return;
        emit(state.copyWith(status: LoadStatus.success, homeData: data));
      }
    } on ApiException catch (e) {
      if (_isStale(filter, genreId)) return;
      emit(state.copyWith(status: LoadStatus.failure, errorMessage: e.message));
    }
  }

  /// Người dùng đã đổi bộ lọc trong lúc đang tải thì bỏ kết quả cũ.
  bool _isStale(HomeFilter filter, int? genreId) =>
      state.filter != filter || state.genre?.id != genreId;

  MediaType? _typeOf(HomeFilter filter) => switch (filter) {
    HomeFilter.tvSeries => MediaType.tv,
    HomeFilter.movies => MediaType.movie,
    _ => null,
  };
}
