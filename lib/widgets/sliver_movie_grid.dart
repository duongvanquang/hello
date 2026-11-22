import 'package:material_ui/material_ui.dart';

import '../models/movie.dart';
import '../pages/movie_detail_page.dart';
import 'movie_poster.dart';
import '../common/app_spacing.dart';
import '../common/app_limits.dart';
import '../common/app_sizes.dart';

/// Lưới poster (dạng sliver, đặt trong CustomScrollView).
/// Bấm poster mở trang chi tiết. Dùng cho: thể loại, tìm kiếm,
/// danh sách của tôi, phim tương tự.
class SliverMovieGrid extends StatelessWidget {
  const SliverMovieGrid({
    super.key,
    required this.movies,
    required this.heroPrefix,
  });

  final List<Movie> movies;

  /// Tiền tố cho tag hiệu ứng chuyển trang, để không trùng giữa các màn hình.
  final String heroPrefix;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.l,
        AppSpacing.sm,
        AppSpacing.l,
        AppSpacing.huge,
      ),
      sliver: SliverGrid.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: AppLimits.gridColumns,
          mainAxisSpacing: AppSpacing.m,
          crossAxisSpacing: AppSpacing.m,
          childAspectRatio: AppSizes.posterAspectRatio,
        ),
        itemCount: movies.length,
        itemBuilder: (context, i) {
          final movie = movies[i];
          final tag = '$heroPrefix-${movie.key}';
          return MoviePoster(
            movie: movie,
            heroTag: tag,
            onTap: () => MovieDetailPage.open(context, movie, tag),
          );
        },
      ),
    );
  }
}
