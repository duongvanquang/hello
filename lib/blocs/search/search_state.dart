import 'package:equatable/equatable.dart';

import '../../models/movie.dart';
import '../load_status.dart';

/// Kết quả tìm kiếm. [LoadStatus.initial] = chưa gõ gì.
class SearchState extends Equatable {
  const SearchState({
    this.query = '',
    this.status = LoadStatus.initial,
    this.movies = const [],
    this.errorMessage,
  });

  final String query;
  final LoadStatus status;
  final List<Movie> movies;
  final String? errorMessage;

  bool get isIdle => status == LoadStatus.initial;

  @override
  List<Object?> get props => [query, status, movies, errorMessage];
}
