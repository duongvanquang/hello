import 'package:material_ui/material_ui.dart';

import '../models/movie.dart';
import '../models/movie_category.dart';
import 'movie_poster.dart';
import '../common/app_text_styles.dart';
import '../common/app_spacing.dart';
import '../common/app_sizes.dart';

/// Một hàng phim cuộn ngang, có tiêu đề ở trên.
class MovieRow extends StatelessWidget {
  const MovieRow({super.key, required this.category, required this.onMovieTap});

  final MovieCategory category;
  final void Function(Movie movie, String heroTag) onMovieTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.l,
            AppSpacing.xl,
            AppSpacing.l,
            AppSpacing.m,
          ),
          child: Text(category.title, style: AppTextStyles.title),
        ),
        SizedBox(
          height: AppSizes.posterRowHeight,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.l),
            itemCount: category.movies.length,
            separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.m),
            itemBuilder: (context, index) {
              final movie = category.movies[index];
              // Mỗi poster cần một tag riêng, vì cùng một phim có thể ở nhiều hàng.
              final heroTag = '${category.title}-${movie.key}';
              return MoviePoster(
                movie: movie,
                heroTag: heroTag,
                onTap: () => onMovieTap(movie, heroTag),
              );
            },
          ),
        ),
      ],
    );
  }
}
