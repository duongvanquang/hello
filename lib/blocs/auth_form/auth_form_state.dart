import 'package:equatable/equatable.dart';

import 'auth_action.dart';

/// Trạng thái các form Đăng nhập / Đăng ký / Quên mật khẩu.
class AuthFormState extends Equatable {
  const AuthFormState({
    this.runningAction,
    this.errorMessage,
    this.isSuccess = false,
  });

  /// Thao tác đang chạy (null = đang rảnh).
  final AuthAction? runningAction;
  final String? errorMessage;
  final bool isSuccess;

  bool get isBusy => runningAction != null;

  @override
  List<Object?> get props => [runningAction, errorMessage, isSuccess];
}
