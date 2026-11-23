import 'package:material_ui/material_ui.dart';

import 'app_opacity.dart';

class AppColors {
  AppColors._();

  /// Màu nhấn chính (nút, logo, chỉ báo đang chọn).
  static const Color primary = Color(0xFFFF6B4A);

  /// Nền tối của toàn app.
  static const Color background = Color(0xFF0E0E12);

  /// Nền của thẻ, ô, thanh điều hướng.
  static const Color surface = Color(0xFF1A1A22);

  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Color(0xFFB3B3C0);

  /// Hiệu ứng shimmer khi đang tải: nền khung và vệt sáng chạy qua.
  static const Color shimmerBase = Color(0xFF1C1C24);
  static const Color shimmerHighlight = Color(0xFF2E2E3A);

  /// Chữ trên nền sáng (nút Phát màu trắng, nút Google).
  static const Color textOnLight = Colors.black;

  /// Nút sáng (Phát, Google).
  static const Color light = Colors.white;

  /// Màu báo lỗi (ô nhập sai).
  static const Color error = Color(0xFFFF5A5F);

  /// Màu xanh của chữ G trên nút Google.
  static const Color googleBlue = Color(0xFF4285F4);

  /// Màu điểm đánh giá, khung cảnh báo.
  static const Color rating = Color(0xFFFFC94A);

  // ===== Màu có độ trong suốt (dùng chung) =====

  /// Thanh tiêu đề trang chủ, nổi trên ảnh.
  static final Color barBackground = background.withValues(
    alpha: AppOpacity.bar,
  );

  /// Nền chỉ báo tab đang chọn.
  static final Color navIndicator = primary.withValues(
    alpha: AppOpacity.indicator,
  );

  /// Nút chính khi đang tắt.
  static final Color primaryDisabled = primary.withValues(
    alpha: AppOpacity.half,
  );

  /// Nút sáng khi đang tắt.
  static final Color lightDisabled = light.withValues(alpha: AppOpacity.half);

  /// Viền mờ (chip chưa chọn).
  static final Color border = textSecondary.withValues(alpha: AppOpacity.half);

  /// Nền nhãn điểm trên poster.
  static final Color badgeBackground = textOnLight.withValues(
    alpha: AppOpacity.strong,
  );

  static final Color warningBackground = rating.withValues(
    alpha: AppOpacity.tint,
  );
  static final Color warningBorder = rating.withValues(alpha: AppOpacity.half);

  static final ColorScheme scheme = ColorScheme.fromSeed(
    seedColor: primary,
    brightness: Brightness.dark,
    primary: primary,
    surface: background,
  );
}
