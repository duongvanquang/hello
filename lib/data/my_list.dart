import 'package:material_ui/material_ui.dart';

import '../models/movie.dart';

class MyList {
  MyList._();

  static final ValueNotifier<List<Movie>> movies = ValueNotifier(const []);

  static bool contains(Movie movie) =>
      movies.value.any((m) => m.key == movie.key);

  static void toggle(Movie movie) {
    movies.value = contains(movie)
        ? movies.value.where((m) => m.key != movie.key).toList()
        : [movie, ...movies.value];
  }
}
