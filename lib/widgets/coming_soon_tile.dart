import 'package:material_ui/material_ui.dart';

import '../common/app_strings.dart';
import '../models/movie.dart';
import 'movie_artwork.dart';
import '../common/app_text_styles.dart';
import '../common/app_spacing.dart';
import '../common/app_sizes.dart';
import '../common/app_radius.dart';
import '../common/app_limits.dart';

/// Một phim sắp chiếu: ảnh ngang, ngày khởi chiếu, tên, thể loại, mô tả ngắn.
class ComingSoonTile extends StatelessWidget {
  const ComingSoonTile({
    super.key,
    required this.movie,
    required this.heroTag,
    required this.onTap,
  });

  final Movie movie;
  final String heroTag;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final date = movie.releaseDate;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.l,
          AppSpacing.md,
          AppSpacing.l,
          AppSpacing.xl,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: AppSizes.backdropAspectRatio,
              child: Hero(
                tag: heroTag,
                child: MovieArtwork(
                  movie: movie,
                  useBackdrop: true,
                  borderRadius: AppRadius.md,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.m),
            if (date != null)
              Text(AppStrings.releaseOn(date), style: AppTextStyles.highlight),
            const SizedBox(height: AppSpacing.xs),
            Text(movie.title, style: AppTextStyles.title),
            if (movie.genres.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.xs),
              Text(
                movie.genres.join(AppStrings.metaSeparator),
                style: AppTextStyles.label,
              ),
            ],
            if (movie.description.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.s),
              Text(
                movie.description,
                maxLines: AppLimits.previewLines,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.caption,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
