import 'dart:async';

import 'package:material_ui/material_ui.dart';

import '../common/app_strings.dart';
import '../models/movie.dart';
import '../repositories/movie_repository.dart';
import '../widgets/empty_view.dart';
import '../widgets/error_view.dart';
import '../widgets/loading_view.dart';
import '../widgets/search_box.dart';
import '../widgets/sliver_movie_grid.dart';
import '../common/app_spacing.dart';
import '../common/app_durations.dart';

/// Tab Tìm kiếm: gõ tên phim, đợi một chút sau khi ngừng gõ rồi gọi TMDB
/// tìm cả phim lẻ lẫn phim bộ.
class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _controller = TextEditingController();
  Timer? _timer;
  String _query = '';
  Future<List<Movie>>? _results;

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  /// Chỉ gọi API khi người dùng ngừng gõ một lúc, tránh gọi liên tục.
  void _onChanged(String text) {
    _timer?.cancel();
    _timer = Timer(AppDurations.searchDebounce, () => _search(text));
  }

  void _search(String text) {
    final query = text.trim();
    if (query == _query) return;
    setState(() {
      _query = query;
      _results = query.isEmpty ? null : MovieRepository.instance.search(query);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: CustomScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.l,
                AppSpacing.md,
                AppSpacing.l,
                AppSpacing.sm,
              ),
              child: SearchBox(controller: _controller, onChanged: _onChanged),
            ),
          ),
          _body(),
        ],
      ),
    );
  }

  Widget _body() {
    final results = _results;
    if (results == null) {
      return const SliverFillRemaining(
        hasScrollBody: false,
        child: EmptyView(icon: Icons.search, message: AppStrings.searchStart),
      );
    }
    return FutureBuilder<List<Movie>>(
      future: results,
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
              onRetry: () => setState(
                () => _results = MovieRepository.instance.search(_query),
              ),
            ),
          );
        }
        final movies = snapshot.requireData;
        if (movies.isEmpty) {
          return const SliverFillRemaining(
            hasScrollBody: false,
            child: EmptyView(
              icon: Icons.search_off,
              message: AppStrings.searchNoResult,
            ),
          );
        }
        return SliverMovieGrid(movies: movies, heroPrefix: 'search');
      },
    );
  }
}
