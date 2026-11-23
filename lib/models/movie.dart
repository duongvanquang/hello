import '../common/app_config.dart';
import '../common/app_strings.dart';
import 'media_type.dart';
import '../common/app_limits.dart';

/// Một phim lẻ hoặc phim bộ, lấy từ TMDB.
class Movie {
  const Movie({
    required this.id,
    required this.title,
    required this.description,
    required this.rating,
    this.mediaType = MediaType.movie,
    this.releaseDate,
    this.genres = const [],
    this.runtimeMinutes,
    this.isAdult = false,
    this.posterPath,
    this.backdropPath,
  });

  /// Đọc từ JSON của TMDB. Phim lẻ dùng `title`/`release_date`,
  /// phim bộ dùng `name`/`first_air_date`. Danh sách chỉ có `genre_ids`
  /// nên cần [genreNames] để đổi mã thành tên; trang chi tiết có sẵn `genres`.
  factory Movie.fromJson(
    Map<String, dynamic> json, {
    Map<int, String> genreNames = const {},
    MediaType? mediaType,
  }) {
    final type =
        mediaType ??
        (json.containsKey('media_type')
            ? MediaType.fromName(json['media_type'] as String?)
            : (json.containsKey('first_air_date')
                  ? MediaType.tv
                  : MediaType.movie));

    final genres = json['genres'] is List
        ? (json['genres'] as List)
              .map((g) => (g as Map<String, dynamic>)['name'] as String)
              .toList()
        : (json['genre_ids'] as List? ?? const [])
              .map((id) => genreNames[id as int])
              .whereType<String>()
              .toList();

    final title = _firstText([json['title'], json['name']]);
    final originalTitle = _firstText([
      json['original_title'],
      json['original_name'],
    ]);
    final episodeRuntimes = json['episode_run_time'] as List? ?? const [];

    return Movie(
      id: json['id'] as int,
      mediaType: type,
      title: title.isNotEmpty ? title : originalTitle,
      description: (json['overview'] as String? ?? '').trim(),
      rating: (json['vote_average'] as num? ?? AppLimits.noRating).toDouble(),
      releaseDate: DateTime.tryParse(
        _firstText([json['release_date'], json['first_air_date']]),
      ),
      genres: genres,
      runtimeMinutes:
          json['runtime'] as int? ??
          (episodeRuntimes.isEmpty ? null : episodeRuntimes.first as int?),
      isAdult: json['adult'] as bool? ?? false,
      posterPath: json['poster_path'] as String?,
      backdropPath: json['backdrop_path'] as String?,
    );
  }

  final int id;
  final MediaType mediaType;
  final String title;
  final String description;

  /// Điểm trung bình trên thang 10.
  final double rating;
  final DateTime? releaseDate;
  final List<String> genres;

  /// Thời lượng phim (phim bộ: thời lượng một tập). Chỉ có khi đã tải chi tiết.
  final int? runtimeMinutes;
  final bool isAdult;
  final String? posterPath;
  final String? backdropPath;

  /// Khóa duy nhất: phim lẻ và phim bộ có thể trùng id nên ghép thêm loại.
  String get key => '${mediaType.path}-$id';

  int? get year => releaseDate?.year;

  /// Ví dụ "Hành động, Phiêu lưu".
  String get genreText => genres.join(', ');

  /// Ví dụ "2g 08p". Null khi chưa biết thời lượng.
  String? get durationText {
    final minutes = runtimeMinutes;
    if (minutes == null || minutes <= AppLimits.noRuntime) return null;
    return AppStrings.duration(
      minutes ~/ Duration.minutesPerHour,
      minutes % Duration.minutesPerHour,
    );
  }

  /// Link trang phim trên TMDB (dùng khi chia sẻ).
  String get webUrl => '${AppConfig.tmdbWebBase}/${mediaType.path}/$id';

  /// Ảnh dọc (poster).
  String? get posterUrl => posterPath == null
      ? null
      : '${AppConfig.tmdbImageBase}${AppConfig.posterSize}$posterPath';

  /// Ảnh ngang (cảnh trong phim). Không có thì dùng poster.
  String? get backdropUrl => backdropPath == null
      ? posterUrl
      : '${AppConfig.tmdbImageBase}${AppConfig.backdropSize}$backdropPath';

  static String _firstText(List<Object?> values) {
    for (final value in values) {
      if (value is String && value.trim().isNotEmpty) return value.trim();
    }
    return '';
  }
}
