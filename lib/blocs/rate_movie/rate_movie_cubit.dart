import 'package:flutter_bloc/flutter_bloc.dart';

import '../../common/app_strings.dart';
import '../../models/movie.dart';
import '../../repositories/movie_repository.dart';
import '../../services/api_exception.dart';
import '../load_status.dart';
import '../user_ratings/user_ratings_cubit.dart';
import 'rate_movie_state.dart';

/// Chọn số sao và gửi đánh giá lên TMDB; gửi xong thì lưu vào [UserRatingsCubit].
class RateMovieCubit extends Cubit<RateMovieState> {
  RateMovieCubit(this._repository, this._ratings, this._movie)
    : super(RateMovieState(stars: _ratings.starsOf(_movie)));

  final MovieRepository _repository;
  final UserRatingsCubit _ratings;
  final Movie _movie;

  void selectStars(int stars) =>
      emit(state.copyWith(stars: stars, status: LoadStatus.initial));

  Future<void> submit() async {
    final stars = state.stars;
    if (stars == null) {
      emit(state.copyWith(errorMessage: AppStrings.rateChooseStars));
      return;
    }
    if (state.isSending) return;
    emit(state.copyWith(status: LoadStatus.loading));
    try {
      await _repository.rate(_movie, stars);
      _ratings.save(_movie, stars);
      emit(state.copyWith(status: LoadStatus.success));
    } on ApiException catch (e) {
      emit(state.copyWith(status: LoadStatus.failure, errorMessage: e.message));
    }
  }
}
