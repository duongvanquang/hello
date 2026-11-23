/// Trạng thái tải dữ liệu dùng chung cho các Cubit/Bloc.
enum LoadStatus {
  /// Chưa bắt đầu tải.
  initial,
  loading,
  success,
  failure;

  bool get isLoading => this == loading || this == initial;
  bool get isFailure => this == failure;
  bool get isSuccess => this == success;
}
