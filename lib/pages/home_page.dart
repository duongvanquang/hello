import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';

import '../blocs/home/home_cubit.dart';
import '../blocs/home/home_state.dart';
import '../blocs/my_list/my_list_cubit.dart';
import '../common/app_colors.dart';
import '../common/app_spacing.dart';
import '../common/app_strings.dart';
import '../models/home_data.dart';
import '../models/home_filter.dart';
import '../models/movie.dart';
import '../widgets/featured_banner.dart';
import '../widgets/genre_picker_sheet.dart';
import '../widgets/home_app_bar.dart';
import '../widgets/movie_row.dart';
import '../widgets/sliver_load_state_view.dart';
import '../widgets/sliver_movie_grid.dart';
import '../widgets/sliver_my_list_grid.dart';
import 'movie_detail_page.dart';
import 'trailer_page.dart';
import '../widgets/skeletons/home_skeleton.dart';
import '../widgets/skeletons/poster_grid_skeleton.dart';

/// Trang chủ: thanh tiêu đề + chip lọc + nội dung theo bộ lọc ([HomeCubit]).
/// Bấm lại chip đang chọn để bỏ lọc. Kéo xuống để tải lại.
class HomePage extends StatelessWidget {
  const HomePage({super.key, this.onSearch});

  /// Bấm kính lúp trên thanh tiêu đề (chuyển sang tab Tìm kiếm).
  final VoidCallback? onSearch;

  /// Thứ tự chip trên thanh lọc.
  static const _chipFilters = [
    HomeFilter.tvSeries,
    HomeFilter.movies,
    HomeFilter.genre,
    HomeFilter.myList,
  ];

  Future<void> _onChipSelected(BuildContext context, int index) async {
    final cubit = context.read<HomeCubit>();
    final filter = _chipFilters[index];
    if (filter != HomeFilter.genre) {
      await cubit.selectFilter(filter);
      return;
    }
    final genre = await GenrePickerSheet.show(
      context,
      selected: cubit.state.genre,
    );
    if (genre != null) await cubit.selectGenre(genre);
  }

  List<String> _chipLabels(HomeState state) => [
    AppStrings.tvSeries,
    AppStrings.singleMovies,
    state.filter == HomeFilter.genre ? state.genre!.name : AppStrings.genre,
    AppStrings.myListFull,
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        final selected = _chipFilters.indexOf(state.filter);
        return RefreshIndicator(
          color: AppColors.primary,
          onRefresh: context.read<HomeCubit>().load,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              HomeAppBar(
                filterLabels: _chipLabels(state),
                selectedFilter: selected.isNegative ? null : selected,
                onFilterSelected: (i) => _onChipSelected(context, i),
                onSearch: onSearch,
              ),
              _content(context, state),
            ],
          ),
        );
      },
    );
  }

  Widget _content(BuildContext context, HomeState state) {
    if (state.filter == HomeFilter.myList) {
      return const SliverMyListGrid(heroPrefix: 'home-mylist');
    }

    final isGenre = state.filter == HomeFilter.genre;
    final data = state.homeData;
    return SliverLoadStateView(
      status: state.status,
      errorMessage: state.errorMessage,
      onRetry: context.read<HomeCubit>().load,
      isEmpty: isGenre
          ? state.genreMovies.isEmpty
          : data == null || (data.featured == null && data.categories.isEmpty),
      emptyIcon: Icons.movie_outlined,
      emptyMessage: AppStrings.noMovies,
      skeleton: isGenre ? const PosterGridSkeleton() : const HomeSkeleton(),
      builder: (context) => isGenre
          ? SliverMovieGrid(movies: state.genreMovies, heroPrefix: 'genre')
          : _rows(context, data!),
    );
  }

  Widget _rows(BuildContext context, HomeData data) {
    final featured = data.featured;
    return SliverMainAxisGroup(
      slivers: [
        if (featured != null)
          SliverToBoxAdapter(
            child: BlocBuilder<MyListCubit, List<Movie>>(
              builder: (context, _) {
                final myList = context.read<MyListCubit>();
                return FeaturedBanner(
                  movie: featured,
                  inMyList: myList.contains(featured),
                  onPlay: () => TrailerPage.open(context, featured),
                  onToggleMyList: () => myList.toggle(featured),
                  onInfo: () =>
                      MovieDetailPage.open(context, featured, 'featured'),
                );
              },
            ),
          ),
        SliverList.builder(
          itemCount: data.categories.length,
          itemBuilder: (context, index) => MovieRow(
            category: data.categories[index],
            onMovieTap: (movie, tag) =>
                MovieDetailPage.open(context, movie, tag),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xxl)),
      ],
    );
  }
}
