import 'package:material_ui/material_ui.dart';

import '../common/app_colors.dart';
import '../common/app_strings.dart';
import '../data/my_list.dart';
import '../models/genre.dart';
import '../models/home_data.dart';
import '../models/home_filter.dart';
import '../models/media_type.dart';
import '../models/movie.dart';
import '../repositories/movie_repository.dart';
import '../widgets/empty_view.dart';
import '../widgets/error_view.dart';
import '../widgets/featured_banner.dart';
import '../widgets/genre_picker_sheet.dart';
import '../widgets/home_app_bar.dart';
import '../widgets/loading_view.dart';
import '../widgets/movie_row.dart';
import '../widgets/sliver_movie_grid.dart';
import 'movie_detail_page.dart';
import 'trailer_page.dart';
import '../common/app_spacing.dart';

/// Trang chủ: thanh trên cùng + chip lọc + nội dung theo bộ lọc, lấy từ TMDB.
/// - Không lọc / Phim bộ / Phim lẻ: banner nổi bật + các hàng phim.
/// - Thể loại: lưới phim thuộc thể loại đã chọn.
/// - Danh sách của tôi: lưới phim đã lưu.
/// Bấm lại chip đang chọn để bỏ lọc. Kéo xuống để tải lại.
class HomePage extends StatefulWidget {
  const HomePage({super.key, this.onSearch});

  /// Bấm kính lúp trên thanh tiêu đề (chuyển sang tab Tìm kiếm).
  final VoidCallback? onSearch;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  /// Thứ tự chip trên thanh lọc.
  static const _chipFilters = [
    HomeFilter.tvSeries,
    HomeFilter.movies,
    HomeFilter.genre,
    HomeFilter.myList,
  ];

  HomeFilter _filter = HomeFilter.all;
  Genre? _genre;
  Future<HomeData>? _homeFuture;
  Future<List<Movie>>? _genreFuture;

  MovieRepository get _repository => MovieRepository.instance;

  @override
  void initState() {
    super.initState();
    _load();
  }

  /// Tải dữ liệu cho bộ lọc hiện tại.
  void _load() {
    switch (_filter) {
      case HomeFilter.all:
        _homeFuture = _repository.loadHome();
      case HomeFilter.tvSeries:
        _homeFuture = _repository.loadHome(type: MediaType.tv);
      case HomeFilter.movies:
        _homeFuture = _repository.loadHome(type: MediaType.movie);
      case HomeFilter.genre:
        _genreFuture = _repository.loadByGenre(_genre!);
      case HomeFilter.myList:
        break;
    }
  }

  Future<void> _reload() async {
    setState(_load);
    try {
      await (_filter == HomeFilter.genre ? _genreFuture : _homeFuture);
    } catch (_) {
      // Lỗi đã hiện trên màn hình.
    }
  }

  Future<void> _onChipSelected(int index) async {
    final tapped = _chipFilters[index];

    if (tapped == HomeFilter.genre) {
      final genre = await GenrePickerSheet.show(context, selected: _genre);
      if (genre == null || !mounted) return;
      setState(() {
        _filter = HomeFilter.genre;
        _genre = genre;
        _load();
      });
      return;
    }

    setState(() {
      // Bấm lại chip đang chọn thì bỏ lọc.
      _filter = tapped == _filter ? HomeFilter.all : tapped;
      _load();
    });
  }

  List<String> get _chipLabels => [
    AppStrings.tvSeries,
    AppStrings.singleMovies,
    _filter == HomeFilter.genre && _genre != null
        ? _genre!.name
        : AppStrings.genre,
    AppStrings.myListFull,
  ];

  @override
  Widget build(BuildContext context) {
    final selected = _chipFilters.indexOf(_filter);
    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: _reload,
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          HomeAppBar(
            filterLabels: _chipLabels,
            selectedFilter: selected.isNegative ? null : selected,
            onFilterSelected: _onChipSelected,
            onSearch: widget.onSearch,
          ),
          ..._content(),
        ],
      ),
    );
  }

  List<Widget> _content() {
    switch (_filter) {
      case HomeFilter.myList:
        return [_myList()];
      case HomeFilter.genre:
        return [_genreGrid()];
      case HomeFilter.all:
      case HomeFilter.tvSeries:
      case HomeFilter.movies:
        return [_homeRows()];
    }
  }

  Widget _homeRows() {
    return FutureBuilder<HomeData>(
      future: _homeFuture,
      builder: (context, snapshot) {
        final state = _loadingOrError(snapshot);
        if (state != null) return state;

        final data = snapshot.requireData;
        final featured = data.featured;
        if (featured == null && data.categories.isEmpty) {
          return const SliverFillRemaining(
            hasScrollBody: false,
            child: EmptyView(
              icon: Icons.movie_outlined,
              message: AppStrings.noMovies,
            ),
          );
        }

        return SliverMainAxisGroup(
          slivers: [
            if (featured != null)
              SliverToBoxAdapter(
                child: ValueListenableBuilder<List<Movie>>(
                  valueListenable: MyList.movies,
                  builder: (context, _, _) => FeaturedBanner(
                    movie: featured,
                    inMyList: MyList.contains(featured),
                    onPlay: () => TrailerPage.open(context, featured),
                    onToggleMyList: () => MyList.toggle(featured),
                    onInfo: () =>
                        MovieDetailPage.open(context, featured, 'featured'),
                  ),
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
      },
    );
  }

  Widget _genreGrid() {
    return FutureBuilder<List<Movie>>(
      future: _genreFuture,
      builder: (context, snapshot) {
        final state = _loadingOrError(snapshot);
        if (state != null) return state;
        final movies = snapshot.requireData;
        if (movies.isEmpty) {
          return const SliverFillRemaining(
            hasScrollBody: false,
            child: EmptyView(
              icon: Icons.movie_outlined,
              message: AppStrings.noMovies,
            ),
          );
        }
        return SliverMovieGrid(movies: movies, heroPrefix: 'genre');
      },
    );
  }

  Widget _myList() {
    return ValueListenableBuilder<List<Movie>>(
      valueListenable: MyList.movies,
      builder: (context, movies, _) => movies.isEmpty
          ? const SliverFillRemaining(
              hasScrollBody: false,
              child: EmptyView(
                icon: Icons.bookmark_border,
                message: AppStrings.myListEmpty,
              ),
            )
          : SliverMovieGrid(movies: movies, heroPrefix: 'home-mylist'),
    );
  }

  /// Trả về sliver "đang tải" hoặc "lỗi"; null khi đã có dữ liệu.
  Widget? _loadingOrError(AsyncSnapshot<Object?> snapshot) {
    if (snapshot.connectionState != ConnectionState.done) {
      return const SliverFillRemaining(
        hasScrollBody: false,
        child: LoadingView(),
      );
    }
    if (snapshot.hasError) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: ErrorView(message: '${snapshot.error}', onRetry: _reload),
      );
    }
    return null;
  }
}
