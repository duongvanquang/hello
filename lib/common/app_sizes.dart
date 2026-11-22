/// Kích thước cố định: biểu tượng, nút, ảnh, thanh, đường viền.
class AppSizes {
  AppSizes._();

  // ===== Biểu tượng =====
  static const double iconXs = 11;
  static const double iconS = 16;
  static const double iconM = 24;
  static const double iconL = 26;
  static const double iconXl = 36;
  static const double iconXxl = 56;

  /// Ngôi sao trong bảng đánh giá.
  static const double iconStar = 40;

  // ===== Ảnh đại diện / logo =====
  static const double avatar = 30;
  static const double avatarLarge = 64;

  /// Biểu tượng người bên trong ảnh đại diện, tính theo cỡ ảnh.
  static const double avatarIconRatio = 0.66;
  static const double authLogo = 76;

  // ===== Nút / thanh =====
  static const double buttonHeight = 50;
  static const double buttonHeightSmall = 48;
  static const double navBarHeight = 64;
  static const double chipBarHeight = 44;

  /// Vòng xoay trong nút đang tải.
  static const double buttonLoader = 22;
  static const double loaderStroke = 2.5;

  // ===== Đường viền / đường kẻ =====
  static const double borderWidth = 1.5;
  static const double dividerThick = 2;

  // ===== Phim =====
  static const double posterWidth = 120;
  static const double posterRowHeight = 180;
  static const double bannerHeight = 520;
  static const double detailHeaderHeight = 260;

  /// Tỉ lệ ảnh dọc (poster) và ảnh ngang (cảnh phim).
  static const double posterAspectRatio = 2 / 3;
  static const double backdropAspectRatio = 16 / 9;

  // ===== Bố cục =====
  /// Chiều rộng tối đa của form đăng nhập/đăng ký (trên máy tính bảng).
  static const double authMaxWidth = 420;

  /// Bảng chọn thể loại cao bằng phần này của màn hình.
  static const double sheetHeightRatio = 0.6;
}
