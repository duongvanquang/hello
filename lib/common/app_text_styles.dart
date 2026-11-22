import 'package:material_ui/material_ui.dart';

import 'app_colors.dart';

/// Tất cả kiểu chữ trong app (cỡ, độ đậm, màu). Muốn đổi chữ cả app thì sửa ở đây.
///
/// Cần biến thể nhỏ thì dùng `copyWith`, ví dụ:
/// `AppTextStyles.caption.copyWith(color: AppColors.primary)`.
class AppTextStyles {
  AppTextStyles._();

  /// Tên phông (khai báo trong pubspec.yaml, file ở assets/fonts/).
  static const String fontFamily = 'BeVietnamPro';

  // ===== Tiêu đề =====

  /// 34 – tên phim trên banner nổi bật.
  static const TextStyle display = TextStyle(
    fontFamily: fontFamily,
    color: AppColors.textPrimary,
    fontSize: 34,
    fontWeight: FontWeight.w900,
    height: 1.1,
  );

  /// 26 – tiêu đề trang (Đăng nhập, Sắp chiếu, tên phim ở trang chi tiết).
  static const TextStyle headline = TextStyle(
    fontFamily: fontFamily,
    color: AppColors.textPrimary,
    fontSize: 26,
    fontWeight: FontWeight.w800,
  );

  /// 24 – tên app (PhimHay) màu nhấn.
  static const TextStyle brand = TextStyle(
    fontFamily: fontFamily,
    color: AppColors.primary,
    fontSize: 24,
    fontWeight: FontWeight.w900,
    letterSpacing: 0.5,
  );

  /// 18 – tiêu đề mục (hàng phim, Phim tương tự, Chọn thể loại, tên người dùng).
  static const TextStyle title = TextStyle(
    fontFamily: fontFamily,
    color: AppColors.textPrimary,
    fontSize: 18,
    fontWeight: FontWeight.w700,
  );

  // ===== Nội dung =====

  /// 14 – đoạn văn dài (mô tả phim).
  static const TextStyle body = TextStyle(
    fontFamily: fontFamily,
    color: AppColors.textPrimary,
    fontSize: 14,
    height: 1.5,
  );

  /// 14 đậm – số liệu nổi bật (điểm đánh giá).
  static const TextStyle bodyStrong = TextStyle(
    fontFamily: fontFamily,
    color: AppColors.textPrimary,
    fontSize: 14,
    fontWeight: FontWeight.w600,
  );

  /// 14 nhạt – chữ phụ (mô tả dưới tiêu đề, năm, thời lượng).
  static const TextStyle bodySecondary = TextStyle(
    fontFamily: fontFamily,
    color: AppColors.textSecondary,
    fontSize: 14,
  );

  /// 13 nhạt – chú thích (thể loại, mô tả ngắn).
  static const TextStyle caption = TextStyle(
    fontFamily: fontFamily,
    color: AppColors.textSecondary,
    fontSize: 13,
    height: 1.4,
  );

  /// 12 nhạt – nhãn dưới biểu tượng (Danh sách, Đánh giá, Chia sẻ).
  static const TextStyle label = TextStyle(
    fontFamily: fontFamily,
    color: AppColors.textSecondary,
    fontSize: 12,
  );

  /// 12 chữ hoa giãn cách – nhãn "PHIM NỔI BẬT".
  static const TextStyle overline = TextStyle(
    fontFamily: fontFamily,
    color: AppColors.primary,
    fontSize: 12,
    fontWeight: FontWeight.w800,
    letterSpacing: 2,
  );

  /// 11 đậm – nhãn nhỏ trên poster (⭐ 7.8).
  static const TextStyle badge = TextStyle(
    fontFamily: fontFamily,
    color: AppColors.textPrimary,
    fontSize: 11,
    fontWeight: FontWeight.w600,
  );

  // ===== Nút / tương tác =====

  /// 16 đậm – chữ trên nút (Đăng nhập, Phát, Tải xuống...). Màu lấy theo nút.
  static const TextStyle button = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w700,
  );

  /// 13 – chữ nhỏ màu trắng (chip lọc, khung thông báo).
  static const TextStyle small = TextStyle(
    fontFamily: fontFamily,
    color: AppColors.textPrimary,
    fontSize: 13,
  );

  /// 13 đậm màu nhấn – thông tin cần chú ý (Khởi chiếu 12/12/2026).
  static const TextStyle highlight = TextStyle(
    fontFamily: fontFamily,
    color: AppColors.primary,
    fontSize: 13,
    fontWeight: FontWeight.w700,
  );

  /// Chữ "G" trên nút đăng nhập Google.
  static const TextStyle googleLogo = TextStyle(
    fontFamily: fontFamily,
    color: AppColors.googleBlue,
    fontSize: 22,
    fontWeight: FontWeight.w800,
  );

  /// Liên kết màu nhấn (Đăng ký, Quên mật khẩu...). Cỡ theo chỗ đặt.
  static const TextStyle link = TextStyle(
    fontFamily: fontFamily,
    color: AppColors.primary,
    fontWeight: FontWeight.w700,
  );

  // ===== Chỉ đổi màu, giữ cỡ chữ mặc định của widget =====

  /// Chữ trắng (ô nhập, thông báo).
  static const TextStyle primary = TextStyle(
    fontFamily: fontFamily,
    color: AppColors.textPrimary,
  );

  /// Chữ xám (gợi ý trong ô nhập, chữ phụ).
  static const TextStyle secondary = TextStyle(
    fontFamily: fontFamily,
    color: AppColors.textSecondary,
  );
}
