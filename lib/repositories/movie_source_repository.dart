import '../models/movie.dart';

/// Nơi DUY NHẤT để lấy link xem phim đầy đủ.
///
/// Hiện app chưa có nguồn phim riêng nên luôn trả về null → nút "Xem phim"
/// mở bảng "Xem phim ở đâu" (rạp, dịch vụ hợp pháp).
///
/// Khi có server phim của bạn (có quyền phát), chỉ cần sửa [findFullMovie]:
/// gọi API của bạn bằng `ApiClient` và trả về link (trang xem phim hoặc file
/// .mp4 / .m3u8). Nút "Xem phim" ở mọi màn hình sẽ tự mở link đó.
class MovieSourceRepository {
  const MovieSourceRepository();

  /// Link xem phim đầy đủ của [movie], hoặc null nếu chưa có.
  Future<Uri?> findFullMovie(Movie movie) async => null;
}
