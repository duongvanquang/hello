import 'package:material_ui/material_ui.dart';

import '../common/app_colors.dart';
import '../common/app_strings.dart';
import '../models/movie.dart';
import '../repositories/movie_repository.dart';
import '../widgets/movie_action_row.dart';
import '../widgets/movie_artwork.dart';
import '../widgets/movie_meta_row.dart';
import '../widgets/sliver_movie_grid.dart';
import '../widgets/wide_button.dart';
import 'trailer_page.dart';
import '../common/app_text_styles.dart';
import '../common/app_spacing.dart';
import '../common/app_sizes.dart';

/// Trang chi tiết một bộ phim. Hiện ngay thông tin đã có, rồi tải thêm
/// thể loại, thời lượng, mô tả đầy đủ và phim tương tự từ TMDB.
class MovieDetailPage extends StatefulWidget {
  const MovieDetailPage({
    super.key,
    required this.movie,
    required this.heroTag,
  });

  final Movie movie;
  final String heroTag;

  /// Mở trang chi tiết của [movie]. [heroTag] phải trùng tag của poster vừa bấm.
  static Future<void> open(BuildContext context, Movie movie, String heroTag) {
    return Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => MovieDetailPage(movie: movie, heroTag: heroTag),
      ),
    );
  }

  @override
  State<MovieDetailPage> createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  late final Future<Movie> _details = MovieRepository.instance.loadDetails(
    widget.movie,
  );
  late final Future<List<Movie>> _similar = MovieRepository.instance
      .loadSimilar(widget.movie);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: FutureBuilder<Movie>(
        future: _details,
        builder: (context, snapshot) {
          // Chưa tải xong (hoặc lỗi) thì dùng thông tin có sẵn từ danh sách.
          final movie = snapshot.data ?? widget.movie;
          return CustomScrollView(
            slivers: [
              _header(movie),
              SliverToBoxAdapter(child: _info(context, movie, snapshot)),
              _similarGrid(),
            ],
          );
        },
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
          tag: widget.heroTag,
          child: MovieArtwork(movie: movie, useBackdrop: true),
        ),
      ),
    );
  }

  Widget _info(
    BuildContext context,
    Movie movie,
    AsyncSnapshot<Movie> snapshot,
  ) {
    final loadingDetails = snapshot.connectionState != ConnectionState.done;
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
            label: AppStrings.play,
            background: AppColors.textPrimary,
            foreground: AppColors.textOnLight,
            onTap: () => TrailerPage.open(context, movie),
          ),
          const SizedBox(height: AppSpacing.sm),
          WideButton(
            icon: Icons.download,
            label: AppStrings.download,
            background: AppColors.surface,
            foreground: AppColors.textPrimary,
            onTap: () {},
          ),
          const SizedBox(height: AppSpacing.l),
          if (loadingDetails && description.isEmpty)
            const LinearProgressIndicator(
              color: AppColors.primary,
              backgroundColor: AppColors.surface,
            )
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

  Widget _similarGrid() {
    return FutureBuilder<List<Movie>>(
      future: _similar,
      builder: (context, snapshot) {
        final movies = snapshot.data ?? const <Movie>[];
        if (snapshot.connectionState != ConnectionState.done) {
          return const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(AppSpacing.xxl),
              child: Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              ),
            ),
          );
        }
        if (movies.isEmpty) {
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
          movies: movies,
          heroPrefix: 'similar-${widget.movie.key}',
        );
      },
    );
  }
}
