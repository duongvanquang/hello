class AppConfig {
  AppConfig._();

  static const String tmdbApiKey = String.fromEnvironment('TMDB_API_KEY');

  static const String tmdbHost = 'api.themoviedb.org';

  static const String tmdbLanguage = 'vi-VN';

  static const String tmdbFallbackLanguage = 'en-US';

  /// Ngôn ngữ video (trailer) được lấy: tiếng Việt, tiếng Anh, không ghi ngôn ngữ.
  static const String tmdbVideoLanguages = 'vi,en,null';
  static const String tmdbVideoPreferredLanguage = 'vi';

  /// Trang web TMDB, dùng làm link khi chia sẻ phim.
  static const String tmdbWebBase = 'https://www.themoviedb.org';

  static const String tmdbImageBase = 'https://image.tmdb.org/t/p/';
  static const String posterSize = 'w500';
  static const String backdropSize = 'w780';
}
