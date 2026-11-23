import 'package:equatable/equatable.dart';

import '../load_status.dart';

/// Ảnh đại diện của người dùng đang đăng nhập.
class AvatarState extends Equatable {
  const AvatarState({
    this.localPath,
    this.status = LoadStatus.initial,
    this.errorMessage,
  });

  /// Ảnh người dùng tự chọn (lưu trong máy). Null = chưa chọn.
  final String? localPath;

  /// loading = đang lưu ảnh mới.
  final LoadStatus status;
  final String? errorMessage;

  bool get isSaving => status == LoadStatus.loading;

  @override
  List<Object?> get props => [localPath, status, errorMessage];
}
