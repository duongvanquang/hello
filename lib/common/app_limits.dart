/// Giới hạn số lượng hiển thị (số cột, số dòng, số mục).
class AppLimits {
  AppLimits._();

  /// Số cột của lưới poster.
  static const int gridColumns = 3;

  /// Số thể loại hiện dưới tên phim trên banner.
  static const int bannerGenres = 2;

  /// Chữ chỉ hiện một dòng (tiêu đề dài thì cắt bằng "...").
  static const int singleLine = 1;

  /// Số dòng mô tả ngắn (tab Sắp chiếu).
  static const int previewLines = 3;

  /// Phim chưa có điểm / chưa có thời lượng thì TMDB trả về 0.
  static const int noRating = 0;
  static const int noRuntime = 0;

  /// Phim chưa có ngày chiếu được xếp cuối danh sách Sắp chiếu.
  static const int unknownReleaseYear = 9999;

  /// Số sao tối thiểu / tối đa khi người dùng đánh giá phim.
  static const int firstStar = 1;
  static const int maxStars = 5;

  /// TMDB chấm thang 10: mỗi sao = 2 điểm.
  static const int pointsPerStar = 2;

  /// Chất lượng nén ảnh đại diện (0–100).
  static const int avatarQuality = 85;

  /// Số khung giả hiện khi đang tải (shimmer).
  static const int skeletonRows = 3;
  static const int skeletonPostersPerRow = 4;
  static const int skeletonGridItems = 9;
  static const int skeletonListItems = 3;
  static const int skeletonTextLines = 3;

  /// Số chữ số sau dấu phẩy của điểm (7.8).
  static const int ratingDecimals = 1;
}
