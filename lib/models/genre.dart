/// Một thể loại phim của TMDB, ví dụ id 28 = "Hành động".
class Genre {
  const Genre({required this.id, required this.name});

  factory Genre.fromJson(Map<String, dynamic> json) =>
      Genre(id: json['id'] as int, name: json['name'] as String);

  final int id;
  final String name;
}
