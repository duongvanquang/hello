import 'package:equatable/equatable.dart';

import '../../models/video.dart';
import '../load_status.dart';

/// Trailer của phim. Tải xong mà [video] null = phim chưa có trailer.
class TrailerState extends Equatable {
  const TrailerState({
    this.status = LoadStatus.initial,
    this.video,
    this.errorMessage,
  });

  final LoadStatus status;
  final Video? video;
  final String? errorMessage;

  @override
  List<Object?> get props => [status, video?.key, errorMessage];
}
