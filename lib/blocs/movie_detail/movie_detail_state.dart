import 'package:equatable/equatable.dart';

import '../../models/movie.dart';
import '../load_status.dart';

/// Trang chi tiết: thông tin đầy đủ của phim và phim tương tự.
class MovieDetailState extends Equatable {
  const MovieDetailState({
    required this.movie,
    this.detailsStatus = LoadStatus.initial,
    this.similarStatus = LoadStatus.initial,
    this.similar = const [],
  });

  /// Lúc đầu là thông tin có sẵn từ danh sách, tải xong thì đầy đủ hơn.
  final Movie movie;
  final LoadStatus detailsStatus;
  final LoadStatus similarStatus;
  final List<Movie> similar;

  MovieDetailState copyWith({
    Movie? movie,
    LoadStatus? detailsStatus,
    LoadStatus? similarStatus,
    List<Movie>? similar,
  }) => MovieDetailState(
    movie: movie ?? this.movie,
    detailsStatus: detailsStatus ?? this.detailsStatus,
    similarStatus: similarStatus ?? this.similarStatus,
    similar: similar ?? this.similar,
  );

  @override
  List<Object?> get props => [movie.key, detailsStatus, similarStatus, similar];
}
