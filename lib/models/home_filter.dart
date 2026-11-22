/// Bộ lọc đang chọn trên trang chủ (các chip dưới thanh tiêu đề).
enum HomeFilter {
  /// Không lọc: phim lẻ và phim bộ nổi bật.
  all,

  /// Chỉ phim bộ (TV).
  tvSeries,

  /// Chỉ phim lẻ.
  movies,

  /// Lọc theo một thể loại.
  genre,

  /// Các phim đã lưu vào "Danh sách của tôi".
  myList,
}
