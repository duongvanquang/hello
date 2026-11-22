import '../common/http_status_code.dart';

/// Lỗi khi gọi API, đã có sẵn câu thông báo tiếng Việt để hiện cho người dùng.
class ApiException implements Exception {
  const ApiException(this.message, {this.statusCode});

  final String message;

  /// Mã HTTP (401, 404, 500...). Null khi lỗi mạng / hết thời gian chờ.
  final int? statusCode;

  bool get isUnauthorized => HttpStatusCode.isUnauthorized(statusCode);
  bool get isNotFound => statusCode == HttpStatusCode.notFound;

  @override
  String toString() => message;
}
