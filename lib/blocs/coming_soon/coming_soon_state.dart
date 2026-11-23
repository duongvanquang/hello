import 'package:equatable/equatable.dart';

import '../../models/movie.dart';
import '../load_status.dart';

/// Danh sách phim sắp chiếu.
class ComingSoonState extends Equatable {
  const ComingSoonState({
    this.status = LoadStatus.initial,
    this.movies = const [],
    this.errorMessage,
  });

  final LoadStatus status;
  final List<Movie> movies;
  final String? errorMessage;

  @override
  List<Object?> get props => [status, movies, errorMessage];
}
