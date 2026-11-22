/// Một video của phim trên TMDB (trailer, teaser...). Hiện chỉ dùng video YouTube.
class Video {
  const Video({
    required this.key,
    required this.name,
    required this.site,
    required this.type,
    required this.isOfficial,
    required this.language,
  });

  factory Video.fromJson(Map<String, dynamic> json) => Video(
    key: json['key'] as String? ?? '',
    name: json['name'] as String? ?? '',
    site: json['site'] as String? ?? '',
    type: json['type'] as String? ?? '',
    isOfficial: json['official'] as bool? ?? false,
    language: json['iso_639_1'] as String? ?? '',
  );

  /// Mã video trên YouTube (phần sau `watch?v=`).
  final String key;
  final String name;
  final String site;
  final String type;
  final bool isOfficial;
  final String language;

  bool get isYouTube => site == 'YouTube' && key.isNotEmpty;
  bool get isTrailer => type == 'Trailer';
  bool get isTeaser => type == 'Teaser';
}
