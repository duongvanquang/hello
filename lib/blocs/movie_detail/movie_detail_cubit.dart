import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/movie.dart';
import '../../repositories/movie_repository.dart';
import '../../services/api_exception.dart';
import '../load_status.dart';
import 'movie_detail_state.dart';

/// Tải thông tin đầy đủ và phim tương tự (song song) cho trang chi tiết.
class MovieDetailCubit extends Cubit<MovieDetailState> {
  MovieDetailCubit(this._repository, Movie movie)
    : super(MovieDetailState(movie: movie));

  final MovieRepository _repository;

  Future<void> load() async {
    emit(
      state.copyWith(
        detailsStatus: LoadStatus.loading,
        similarStatus: LoadStatus.loading,
      ),
    );
    await Future.wait([_loadDetails(), _loadSimilar()]);
  }

  Future<void> _loadDetails() async {
    try {
      final movie = await _repository.loadDetails(state.movie);
      emit(state.copyWith(movie: movie, detailsStatus: LoadStatus.success));
    } on ApiException {
      // Lỗi thì vẫn hiện thông tin có sẵn từ danh sách.
      emit(state.copyWith(detailsStatus: LoadStatus.failure));
    }
  }

  Future<void> _loadSimilar() async {
    try {
      final similar = await _repository.loadSimilar(state.movie);
      emit(state.copyWith(similar: similar, similarStatus: LoadStatus.success));
    } on ApiException {
      emit(state.copyWith(similarStatus: LoadStatus.failure));
    }
  }
}
