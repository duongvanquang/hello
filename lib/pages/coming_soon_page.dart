import 'package:material_ui/material_ui.dart';

import '../common/app_colors.dart';
import '../common/app_strings.dart';
import '../models/movie.dart';
import '../repositories/movie_repository.dart';
import '../widgets/coming_soon_tile.dart';
import '../widgets/empty_view.dart';
import '../widgets/error_view.dart';
import '../widgets/loading_view.dart';
import '../widgets/tab_title.dart';
import 'movie_detail_page.dart';

/// Tab Sắp chiếu: phim sắp ra mắt từ TMDB, ngày gần nhất lên trước.
class ComingSoonPage extends StatefulWidget {
  const ComingSoonPage({super.key});

  @override
  State<ComingSoonPage> createState() => _ComingSoonPageState();
}

class _ComingSoonPageState extends State<ComingSoonPage> {
  late Future<List<Movie>> _future = MovieRepository.instance.loadUpcoming();

  Future<void> _reload() async {
    final future = MovieRepository.instance.loadUpcoming();
    setState(() => _future = future);
    try {
      await future;
    } catch (_) {
      // Lỗi đã hiện trên màn hình.
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: RefreshIndicator(
        color: AppColors.primary,
        onRefresh: _reload,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            const SliverToBoxAdapter(
              child: TabTitle(title: AppStrings.tabComingSoon),
            ),
            FutureBuilder<List<Movie>>(
              future: _future,
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return const SliverFillRemaining(
                    hasScrollBody: false,
                    child: LoadingView(),
                  );
                }
                if (snapshot.hasError) {
                  return SliverFillRemaining(
                    hasScrollBody: false,
                    child: ErrorView(
                      message: '${snapshot.error}',
                      onRetry: _reload,
                    ),
                  );
                }
                final movies = snapshot.requireData;
                if (movies.isEmpty) {
                  return const SliverFillRemaining(
                    hasScrollBody: false,
                    child: EmptyView(
                      icon: Icons.event_busy,
                      message: AppStrings.noMovies,
                    ),
                  );
                }
                return SliverList.builder(
                  itemCount: movies.length,
                  itemBuilder: (context, i) {
                    final movie = movies[i];
                    final tag = 'coming-${movie.key}';
                    return ComingSoonTile(
                      movie: movie,
                      heroTag: tag,
                      onTap: () => MovieDetailPage.open(context, movie, tag),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
