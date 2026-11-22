import 'movie.dart';
import 'movie_category.dart';

/// Toàn bộ dữ liệu của trang chủ: phim nổi bật + các hàng phim.
class HomeData {
  const HomeData({required this.featured, required this.categories});

  final Movie? featured;
  final List<MovieCategory> categories;
}
