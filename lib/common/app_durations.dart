/// Các khoảng thời gian dùng trong app (hiệu ứng, chờ gõ, chờ mạng).
class AppDurations {
  AppDurations._();

  /// Hiệu ứng nhỏ (đổi màu chip).
  static const Duration fast = Duration(milliseconds: 200);

  /// Ảnh hiện dần khi tải xong.
  static const Duration imageFade = Duration(milliseconds: 250);

  /// Một lượt vệt sáng shimmer chạy qua.
  static const Duration shimmer = Duration(milliseconds: 1300);

  /// Đợi người dùng ngừng gõ rồi mới tìm kiếm.
  static const Duration searchDebounce = Duration(milliseconds: 450);

  /// Thời gian tối đa chờ API trả lời.
  static const Duration apiTimeout = Duration(seconds: 15);

  static const Duration oneDay = Duration(days: 1);
}
