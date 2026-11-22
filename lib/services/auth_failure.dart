/// Lỗi khi đăng nhập / đăng ký, đã có sẵn câu thông báo tiếng Việt.
class AuthFailure implements Exception {
  const AuthFailure(this.message, {this.isCancelled = false});

  /// Người dùng tự đóng cửa sổ đăng nhập Google: không cần báo lỗi.
  const AuthFailure.cancelled() : message = '', isCancelled = true;

  final String message;
  final bool isCancelled;

  @override
  String toString() => message;
}
