import 'package:equatable/equatable.dart';

import '../../models/genre.dart';
import '../load_status.dart';

/// Danh sách thể loại cho bảng chọn.
class GenresState extends Equatable {
  const GenresState({
    this.status = LoadStatus.initial,
    this.genres = const [],
    this.errorMessage,
  });

  final LoadStatus status;
  final List<Genre> genres;
  final String? errorMessage;

  @override
  List<Object?> get props => [status, genres.length, errorMessage];
}
