import 'package:equatable/equatable.dart';

import '../load_status.dart';

/// Bảng chấm sao: số sao đang chọn và trạng thái gửi.
class RateMovieState extends Equatable {
  const RateMovieState({
    this.stars,
    this.status = LoadStatus.initial,
    this.errorMessage,
  });

  final int? stars;

  /// initial = chưa gửi; loading = đang gửi; success = gửi xong.
  final LoadStatus status;
  final String? errorMessage;

  bool get isSending => status == LoadStatus.loading;

  RateMovieState copyWith({
    int? stars,
    LoadStatus? status,
    String? errorMessage,
  }) => RateMovieState(
    stars: stars ?? this.stars,
    status: status ?? this.status,
    errorMessage: errorMessage,
  );

  @override
  List<Object?> get props => [stars, status, errorMessage];
}
