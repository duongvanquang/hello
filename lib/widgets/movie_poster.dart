import 'package:material_ui/material_ui.dart';

import '../models/movie.dart';
import 'movie_artwork.dart';
import '../common/app_sizes.dart';
import '../common/app_radius.dart';

/// Poster phim (ảnh dọc từ TMDB) kèm điểm. Bấm vào để xem chi tiết.
class MoviePoster extends StatelessWidget {
  const MoviePoster({
    super.key,
    required this.movie,
    this.width = AppSizes.posterWidth,
    this.onTap,
    this.heroTag,
  });

  final Movie movie;
  final double width;
  final VoidCallback? onTap;

  /// Tag cho hiệu ứng chuyển cảnh sang trang chi tiết.
  final String? heroTag;

  @override
  Widget build(BuildContext context) {
    final poster = MovieArtwork(
      movie: movie,
      borderRadius: AppRadius.sm,
      showRating: true,
    );

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: width,
        child: AspectRatio(
          aspectRatio: AppSizes.posterAspectRatio,
          child: heroTag == null ? poster : Hero(tag: heroTag!, child: poster),
        ),
      ),
    );
  }
}
