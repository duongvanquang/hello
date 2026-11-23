import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/movie.dart';

/// Số sao người dùng đã chấm cho từng phim (khóa là [Movie.key]).
/// Dùng chung cả app. Hiện chỉ lưu trong bộ nhớ (điểm trên TMDB vẫn còn).
class UserRatingsCubit extends Cubit<Map<String, int>> {
  UserRatingsCubit() : super(const {});

  int? starsOf(Movie movie) => state[movie.key];

  void save(Movie movie, int stars) => emit({...state, movie.key: stars});
}
