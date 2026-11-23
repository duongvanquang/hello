import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repositories/movie_repository.dart';
import '../../services/api_exception.dart';
import '../load_status.dart';
import 'coming_soon_state.dart';

/// Tải phim sắp chiếu.
class ComingSoonCubit extends Cubit<ComingSoonState> {
  ComingSoonCubit(this._repository) : super(const ComingSoonState());

  final MovieRepository _repository;

  Future<void> load() async {
    emit(ComingSoonState(status: LoadStatus.loading, movies: state.movies));
    try {
      final movies = await _repository.loadUpcoming();
      emit(ComingSoonState(status: LoadStatus.success, movies: movies));
    } on ApiException catch (e) {
      emit(
        ComingSoonState(status: LoadStatus.failure, errorMessage: e.message),
      );
    }
  }
}
