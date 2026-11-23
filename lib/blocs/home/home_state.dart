import 'package:equatable/equatable.dart';

import '../../models/genre.dart';
import '../../models/home_data.dart';
import '../../models/home_filter.dart';
import '../../models/movie.dart';
import '../load_status.dart';

/// Trạng thái trang chủ: bộ lọc đang chọn và dữ liệu tương ứng.
class HomeState extends Equatable {
  const HomeState({
    this.filter = HomeFilter.all,
    this.genre,
    this.status = LoadStatus.initial,
    this.homeData,
    this.genreMovies = const [],
    this.errorMessage,
  });

  final HomeFilter filter;

  /// Thể loại đang chọn (chỉ dùng khi [filter] là [HomeFilter.genre]).
  final Genre? genre;
  final LoadStatus status;

  /// Banner + các hàng phim (Không lọc / Phim bộ / Phim lẻ).
  final HomeData? homeData;

  /// Lưới phim khi lọc theo thể loại.
  final List<Movie> genreMovies;
  final String? errorMessage;

  HomeState copyWith({
    HomeFilter? filter,
    Genre? genre,
    LoadStatus? status,
    HomeData? homeData,
    List<Movie>? genreMovies,
    String? errorMessage,
  }) => HomeState(
    filter: filter ?? this.filter,
    genre: genre ?? this.genre,
    status: status ?? this.status,
    homeData: homeData ?? this.homeData,
    genreMovies: genreMovies ?? this.genreMovies,
    errorMessage: errorMessage,
  );

  @override
  List<Object?> get props => [
    filter,
    genre?.id,
    status,
    homeData,
    genreMovies,
    errorMessage,
  ];
}
