import 'package:material_ui/material_ui.dart';

import '../common/app_strings.dart';
import '../data/my_list.dart';
import '../models/movie.dart';
import '../widgets/empty_view.dart';
import '../widgets/sliver_movie_grid.dart';
import '../widgets/tab_title.dart';

/// Tab Danh sách của tôi: lưới các phim đã lưu.
class MyListPage extends StatelessWidget {
  const MyListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: ValueListenableBuilder<List<Movie>>(
        valueListenable: MyList.movies,
        builder: (context, movies, _) => CustomScrollView(
          slivers: [
            const SliverToBoxAdapter(
              child: TabTitle(title: AppStrings.myListFull),
            ),
            if (movies.isEmpty)
              const SliverFillRemaining(
                hasScrollBody: false,
                child: EmptyView(
                  icon: Icons.bookmark_border,
                  message: AppStrings.myListEmpty,
                ),
              )
            else
              SliverMovieGrid(movies: movies, heroPrefix: 'mylist'),
          ],
        ),
      ),
    );
  }
}
