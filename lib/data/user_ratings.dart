import 'package:material_ui/material_ui.dart';

import '../models/movie.dart';

/// Số sao người dùng đã chấm cho từng phim (khóa là [Movie.key]).
/// Hiện chỉ lưu trong bộ nhớ: tắt app sẽ mất (điểm trên TMDB vẫn còn).
class UserRatings {
  UserRatings._();

  static final ValueNotifier<Map<String, int>> stars = ValueNotifier(const {});

  static int? of(Movie movie) => stars.value[movie.key];

  static void set(Movie movie, int value) {
    stars.value = {...stars.value, movie.key: value};
  }
}
