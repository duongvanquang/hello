import 'movie.dart';

/// Một hàng phim trên trang chủ, ví dụ "Thịnh hành".
class MovieCategory {
  const MovieCategory({required this.title, required this.movies});

  final String title;
  final List<Movie> movies;
}
