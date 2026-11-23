import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';

import '../blocs/coming_soon/coming_soon_cubit.dart';
import '../blocs/coming_soon/coming_soon_state.dart';
import '../common/app_colors.dart';
import '../common/app_strings.dart';
import '../widgets/coming_soon_tile.dart';
import '../widgets/sliver_load_state_view.dart';
import '../widgets/tab_title.dart';
import 'movie_detail_page.dart';
import '../widgets/skeletons/coming_soon_skeleton.dart';

/// Tab Sắp chiếu: phim sắp ra mắt ([ComingSoonCubit]). Kéo xuống để tải lại.
class ComingSoonPage extends StatelessWidget {
  const ComingSoonPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ComingSoonCubit>();
    return SafeArea(
      bottom: false,
      child: RefreshIndicator(
        color: AppColors.primary,
        onRefresh: cubit.load,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            const SliverToBoxAdapter(
              child: TabTitle(title: AppStrings.tabComingSoon),
            ),
            BlocBuilder<ComingSoonCubit, ComingSoonState>(
              builder: (context, state) => SliverLoadStateView(
                status: state.status,
                errorMessage: state.errorMessage,
                onRetry: cubit.load,
                isEmpty: state.movies.isEmpty,
                emptyIcon: Icons.event_busy,
                emptyMessage: AppStrings.noMovies,
                skeleton: const ComingSoonSkeleton(),
                builder: (_) => SliverList.builder(
                  itemCount: state.movies.length,
                  itemBuilder: (context, i) {
                    final movie = state.movies[i];
                    final tag = 'coming-${movie.key}';
                    return ComingSoonTile(
                      movie: movie,
                      heroTag: tag,
                      onTap: () => MovieDetailPage.open(context, movie, tag),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
