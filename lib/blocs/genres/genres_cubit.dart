import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repositories/movie_repository.dart';
import '../../services/api_exception.dart';
import '../load_status.dart';
import 'genres_state.dart';

/// Tải danh sách thể loại.
class GenresCubit extends Cubit<GenresState> {
  GenresCubit(this._repository) : super(const GenresState());

  final MovieRepository _repository;

  Future<void> load() async {
    emit(const GenresState(status: LoadStatus.loading));
    try {
      final genres = await _repository.loadGenres();
      emit(GenresState(status: LoadStatus.success, genres: genres));
    } on ApiException catch (e) {
      emit(GenresState(status: LoadStatus.failure, errorMessage: e.message));
    }
  }
}
