import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/movie.dart';
import '../../repositories/movie_repository.dart';
import '../../services/api_exception.dart';
import '../load_status.dart';
import 'trailer_state.dart';

/// Tìm trailer phù hợp nhất của phim.
class TrailerCubit extends Cubit<TrailerState> {
  TrailerCubit(this._repository, this._movie) : super(const TrailerState());

  final MovieRepository _repository;
  final Movie _movie;

  Future<void> load() async {
    emit(const TrailerState(status: LoadStatus.loading));
    try {
      final video = await _repository.loadTrailer(_movie);
      emit(TrailerState(status: LoadStatus.success, video: video));
    } on ApiException catch (e) {
      emit(TrailerState(status: LoadStatus.failure, errorMessage: e.message));
    }
  }
}
