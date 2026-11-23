import '../common/app_config.dart';
import '../common/app_strings.dart';
import '../models/genre.dart';
import '../models/home_data.dart';
import '../models/media_type.dart';
import '../models/movie.dart';
import '../models/movie_category.dart';
import '../models/video.dart';
import '../services/api_exception.dart';
import '../services/tmdb_api.dart';
import '../common/app_durations.dart';
import '../common/app_limits.dart';

/// Lấy phim lẻ / phim bộ từ TMDB và đổi thành [Movie]. Các trang chỉ gọi lớp này.
class MovieRepository {
  MovieRepository({TmdbApi? api}) : _api = api ?? TmdbApi();

  final TmdbApi _api;

  /// Bảng mã thể loại → tên của cả phim lẻ và phim bộ, chỉ tải một lần.
  Map<int, String>? _genreNames;

  /// Danh sách thể loại phim lẻ (cho nút "Thể loại"), chỉ tải một lần.
  List<Genre>? _movieGenres;

  /// Phiên khách TMDB để gửi đánh giá mà không cần tài khoản TMDB.
  String? _guestSessionId;

  /// Trang chủ. [type] = null: phim lẻ + phim bộ; hoặc chỉ một loại.
  Future<HomeData> loadHome({MediaType? type}) {
    switch (type) {
      case MediaType.tv:
        return _buildHome(
          featuredPath: '/trending/tv/week',
          rows: {
            AppStrings.rowTvTrending: '/trending/tv/week',
            AppStrings.rowTvAiringToday: '/tv/airing_today',
            AppStrings.rowTvPopular: '/tv/popular',
            AppStrings.rowTvTopRated: '/tv/top_rated',
          },
        );
      case MediaType.movie:
        return _buildHome(
          featuredPath: '/trending/movie/week',
          rows: {
            AppStrings.rowMovieTrending: '/trending/movie/week',
            AppStrings.rowNowPlaying: '/movie/now_playing',
            AppStrings.rowPopular: '/movie/popular',
            AppStrings.rowTopRated: '/movie/top_rated',
          },
        );
      case null:
        return _buildHome(
          featuredPath: '/trending/movie/week',
          rows: {
            AppStrings.rowTrending: '/trending/movie/week',
            AppStrings.rowTvTrending: '/trending/tv/week',
            AppStrings.rowNowPlaying: '/movie/now_playing',
            AppStrings.rowTvPopular: '/tv/popular',
            AppStrings.rowTopRated: '/movie/top_rated',
          },
        );
    }
  }

  /// Danh sách thể loại để người dùng chọn.
  Future<List<Genre>> loadGenres() async {
    final cached = _movieGenres;
    if (cached != null) return cached;
    final json = await _api.get('/genre/movie/list');
    return _movieGenres = _parseGenres(json);
  }

  /// Phim phổ biến thuộc một thể loại.
  Future<List<Movie>> loadByGenre(Genre genre) => _list(
    '/discover/movie',
    query: {'with_genres': '${genre.id}', 'sort_by': 'popularity.desc'},
  );

  /// Phim sắp ra mắt (khởi chiếu từ ngày mai trở đi), được chú ý nhiều nhất,
  /// xếp theo ngày chiếu gần nhất lên trước.
  Future<List<Movie>> loadUpcoming() async {
    final tomorrow = DateTime.now().add(AppDurations.oneDay);
    final from = tomorrow.toIso8601String().split('T').first; // yyyy-MM-dd
    final movies = await _list(
      '/discover/movie',
      query: {
        'primary_release_date.gte': from,
        'sort_by': 'popularity.desc',
        'include_adult': 'false',
      },
    );
    final far = DateTime.utc(AppLimits.unknownReleaseYear);
    return movies
      ..sort((a, b) => (a.releaseDate ?? far).compareTo(b.releaseDate ?? far));
  }

  /// Tìm phim lẻ và phim bộ theo tên.
  Future<List<Movie>> search(String query) async {
    final text = query.trim();
    if (text.isEmpty) return const [];
    final movies = await _list(
      '/search/multi',
      query: {'query': text, 'include_adult': 'false'},
    );
    return movies;
  }

  /// Thông tin đầy đủ: thể loại, thời lượng, mô tả (tiếng Anh nếu chưa có tiếng Việt).
  Future<Movie> loadDetails(Movie movie) async {
    final path = '/${movie.mediaType.path}/${movie.id}';
    final json = await _api.get(path);
    if ((json['overview'] as String? ?? '').trim().isEmpty) {
      final english = await _api.get(
        path,
        language: AppConfig.tmdbFallbackLanguage,
      );
      json['overview'] = english['overview'];
    }
    return Movie.fromJson(json, mediaType: movie.mediaType);
  }

  /// Phim gợi ý tương tự; nếu TMDB không có gợi ý thì lấy phim cùng loại.
  Future<List<Movie>> loadSimilar(Movie movie) async {
    final base = '/${movie.mediaType.path}/${movie.id}';
    final recommended = await _list(
      '$base/recommendations',
      type: movie.mediaType,
    );
    if (recommended.isNotEmpty) return recommended;
    return _list('$base/similar', type: movie.mediaType);
  }

  /// Trailer YouTube phù hợp nhất của phim; null nếu phim chưa có video.
  /// Ưu tiên: trailer > teaser > video khác; chính thức; tiếng Việt trước.
  Future<Video?> loadTrailer(Movie movie) async {
    final json = await _api.get(
      '/${movie.mediaType.path}/${movie.id}/videos',
      query: {'include_video_language': AppConfig.tmdbVideoLanguages},
    );
    final videos = (json['results'] as List? ?? const [])
        .cast<Map<String, dynamic>>()
        .map(Video.fromJson)
        .where((v) => v.isYouTube)
        .toList();
    if (videos.isEmpty) return null;

    const preferred = AppConfig.tmdbVideoPreferredLanguage;
    final choices = <bool Function(Video)>[
      (v) => v.isTrailer && v.isOfficial && v.language == preferred,
      (v) => v.isTrailer && v.isOfficial,
      (v) => v.isTrailer,
      (v) => v.isTeaser,
    ];
    for (final matches in choices) {
      final found = videos.where(matches);
      if (found.isNotEmpty) return found.first;
    }
    return videos.first;
  }

  /// Gửi điểm [stars] (1–5 sao) của người dùng cho phim lên TMDB.
  /// TMDB chấm trên thang 10 nên mỗi sao = [AppLimits.pointsPerStar] điểm.
  Future<void> rate(Movie movie, int stars) async {
    final sessionId = await _loadGuestSession();
    await _api.post(
      '/${movie.mediaType.path}/${movie.id}/rating',
      query: {'guest_session_id': sessionId},
      body: {'value': stars * AppLimits.pointsPerStar},
    );
  }

  Future<String> _loadGuestSession() async {
    final cached = _guestSessionId;
    if (cached != null) return cached;
    final json = await _api.get('/authentication/guest_session/new');
    final sessionId = json['guest_session_id'];
    if (sessionId is! String) {
      throw const ApiException(AppStrings.invalidResponse);
    }
    return _guestSessionId = sessionId;
  }

  Future<HomeData> _buildHome({
    required String featuredPath,
    required Map<String, String> rows,
  }) async {
    final lists = await Future.wait(rows.values.map(_list));
    final titles = rows.keys.toList();
    final featuredIndex = rows.values.toList().indexOf(featuredPath);
    final featuredList = featuredIndex.isNegative
        ? <Movie>[]
        : lists[featuredIndex];
    final featured = featuredList.isEmpty ? null : featuredList.first;

    return HomeData(
      featured: featured,
      categories: [
        for (final (i, list) in lists.indexed)
          MovieCategory(
            title: titles[i],
            movies: list.where((m) => m.key != featured?.key).toList(),
          ),
      ].where((c) => c.movies.isNotEmpty).toList(),
    );
  }

  /// Gọi một API trả về danh sách và đổi thành [Movie].
  /// Bỏ phim không có poster và kết quả không phải phim (ví dụ diễn viên).
  Future<List<Movie>> _list(
    String path, {
    Map<String, String> query = const {},
    MediaType? type,
  }) async {
    final genreNames = await _loadGenreNames();
    final json = await _api.get(path, query: query);
    final results = (json['results'] as List? ?? const [])
        .cast<Map<String, dynamic>>()
        .where((item) {
          final mediaType = item['media_type'];
          return mediaType == null || mediaType == 'movie' || mediaType == 'tv';
        });

    // Đường dẫn /tv/... trả về phim bộ dù không ghi media_type.
    final pathType = type ?? (path.contains('/tv') ? MediaType.tv : null);
    return results
        .map(
          (item) => Movie.fromJson(
            item,
            genreNames: genreNames,
            mediaType: item.containsKey('media_type') ? null : pathType,
          ),
        )
        .where((movie) => movie.posterUrl != null)
        .toList();
  }

  Future<Map<int, String>> _loadGenreNames() async {
    final cached = _genreNames;
    if (cached != null) return cached;
    final lists = await Future.wait([
      _api.get('/genre/movie/list'),
      _api.get('/genre/tv/list'),
    ]);
    _movieGenres ??= _parseGenres(lists.first);
    return _genreNames = {
      for (final json in lists)
        for (final genre in _parseGenres(json)) genre.id: genre.name,
    };
  }

  List<Genre> _parseGenres(Map<String, dynamic> json) =>
      (json['genres'] as List? ?? const [])
          .cast<Map<String, dynamic>>()
          .map(Genre.fromJson)
          .toList();
}
