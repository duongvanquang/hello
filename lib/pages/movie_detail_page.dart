import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';

import '../blocs/movie_detail/movie_detail_cubit.dart';
import '../blocs/movie_detail/movie_detail_state.dart';
import '../common/app_colors.dart';
import '../common/app_sizes.dart';
import '../common/app_spacing.dart';
import '../common/app_strings.dart';
import '../common/app_text_styles.dart';
import '../models/movie.dart';
import '../widgets/movie_action_row.dart';
import '../widgets/movie_artwork.dart';
import '../widgets/movie_meta_row.dart';
import '../widgets/sliver_movie_grid.dart';
import '../widgets/wide_button.dart';
import '../widgets/app_shimmer.dart';
import '../widgets/skeletons/poster_grid_skeleton.dart';
import '../widgets/skeletons/text_lines_skeleton.dart';
import '../common/app_playback.dart';

/// Trang chi tiết một bộ phim ([MovieDetailCubit]). Hiện ngay thông tin đã có,
/// rồi tải thêm thể loại, thời lượng, mô tả đầy đủ và phim tương tự.
class MovieDetailPage extends StatelessWidget {
  const MovieDetailPage({super.key, required this.heroTag});

  final String heroTag;

  /// Mở trang chi tiết của [movie]. [heroTag] phải trùng tag của poster vừa bấm.
  static Future<void> open(BuildContext context, Movie movie, String heroTag) {
    return Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (ctx) => MovieDetailCubit(ctx.read(), movie)..load(),
          child: MovieDetailPage(heroTag: heroTag),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocBuilder<MovieDetailCubit, MovieDetailState>(
        builder: (context, state) => CustomScrollView(
          slivers: [
            _header(state.movie),
            SliverToBoxAdapter(child: _info(context, state)),
            _similar(state),
          ],
        ),
      ),
    );
  }

  Widget _header(Movie movie) {
    return SliverAppBar(
      expandedHeight: AppSizes.detailHeaderHeight,
      pinned: true,
      backgroundColor: AppColors.background,
      surfaceTintColor: Colors.transparent,
      iconTheme: const IconThemeData(color: AppColors.textPrimary),
      flexibleSpace: FlexibleSpaceBar(
        background: Hero(
          tag: heroTag,
          child: MovieArtwork(movie: movie, useBackdrop: true),
        ),
      ),
    );
  }

  Widget _info(BuildContext context, MovieDetailState state) {
    final movie = state.movie;
    final loadingDetails = state.detailsStatus.isLoading;
    final description = movie.description.isNotEmpty
        ? movie.description
        : (loadingDetails ? '' : AppStrings.noDescription);

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.l,
        AppSpacing.l,
        AppSpacing.l,
        AppSpacing.none,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(movie.title, style: AppTextStyles.headline),
          const SizedBox(height: AppSpacing.sm),
          MovieMetaRow(movie: movie),
          const SizedBox(height: AppSpacing.l),
          WideButton(
            icon: Icons.play_arrow,
            label: AppPlayback.labelFor(movie),
            background: AppColors.textPrimary,
            foreground: AppColors.textOnLight,
            onTap: () => AppPlayback.play(context, movie),
          ),
          if (movie.isUpcoming && movie.releaseDate != null) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              AppStrings.releaseOn(movie.releaseDate!),
              style: AppTextStyles.highlight,
            ),
          ],
          const SizedBox(height: AppSpacing.l),
          if (loadingDetails && description.isEmpty)
            const AppShimmer(child: TextLinesSkeleton())
          else
            Text(description, style: AppTextStyles.body),
          if (movie.genres.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              AppStrings.genreLine(movie.genreText),
              style: AppTextStyles.caption,
            ),
          ],
          const SizedBox(height: AppSpacing.l),
          MovieActionRow(movie: movie),
          const SizedBox(height: AppSpacing.xl),
          const Divider(
            color: AppColors.surface,
            thickness: AppSizes.dividerThick,
          ),
          const SizedBox(height: AppSpacing.md),
          const Text(AppStrings.similar, style: AppTextStyles.title),
          const SizedBox(height: AppSpacing.md),
        ],
      ),
    );
  }

  Widget _similar(MovieDetailState state) {
    if (state.similarStatus.isLoading) return const PosterGridSkeleton();
    if (state.similar.isEmpty) {
      return const SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.l,
            AppSpacing.none,
            AppSpacing.l,
            AppSpacing.huge,
          ),
          child: Text(AppStrings.noMovies, style: AppTextStyles.secondary),
        ),
      );
    }
    return SliverMovieGrid(
      movies: state.similar,
      heroPrefix: 'similar-${state.movie.key}',
    );
  }
}
