/// Loại nội dung trên TMDB: phim lẻ (movie) hoặc phim bộ (tv).
/// [path] là đoạn dùng trong địa chỉ API, ví dụ `/movie/123`, `/tv/456`.
enum MediaType {
  movie('movie'),
  tv('tv');

  const MediaType(this.path);

  final String path;

  /// Đọc từ chữ `media_type` của TMDB. Không rõ thì coi là phim lẻ.
  static MediaType fromName(String? name) => name == 'tv' ? tv : movie;
}
