/// Mã trạng thái HTTP mà app cần xử lý.
class HttpStatusCode {
  HttpStatusCode._();

  static const int okStart = 200;
  static const int okEnd = 299;
  static const int unauthorized = 401;
  static const int forbidden = 403;
  static const int notFound = 404;
  static const int serverErrorStart = 500;

  static bool isSuccess(int code) => code >= okStart && code <= okEnd;
  static bool isUnauthorized(int? code) =>
      code == unauthorized || code == forbidden;
  static bool isServerError(int code) => code >= serverErrorStart;
}
