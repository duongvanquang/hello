import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';

import '../blocs/search/search_bloc.dart';
import '../blocs/search/search_query_changed.dart';
import '../blocs/search/search_state.dart';
import '../common/app_spacing.dart';
import '../common/app_strings.dart';
import '../widgets/empty_view.dart';
import '../widgets/search_box.dart';
import '../widgets/sliver_load_state_view.dart';
import '../widgets/sliver_movie_grid.dart';

/// Tab Tìm kiếm: gõ tên phim, [SearchBloc] tự đợi ngừng gõ rồi gọi TMDB.
class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _search(String text, {bool retry = false}) =>
      context.read<SearchBloc>().add(SearchQueryChanged(text, retry: retry));

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
              child: SearchBox(controller: _controller, onChanged: _search),
            ),
          ),
          BlocBuilder<SearchBloc, SearchState>(
            builder: (context, state) {
              if (state.isIdle) {
                return const SliverFillRemaining(
                  hasScrollBody: false,
                  child: EmptyView(
                    icon: Icons.search,
                    message: AppStrings.searchStart,
                  ),
                );
              }
              return SliverLoadStateView(
                status: state.status,
                errorMessage: state.errorMessage,
                onRetry: () => _search(state.query, retry: true),
                isEmpty: state.movies.isEmpty,
                emptyIcon: Icons.search_off,
                emptyMessage: AppStrings.searchNoResult,
                builder: (_) =>
                    SliverMovieGrid(movies: state.movies, heroPrefix: 'search'),
              );
            },
          ),
        ],
      ),
    );
  }
}
