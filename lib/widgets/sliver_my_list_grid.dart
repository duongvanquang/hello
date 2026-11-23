import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';

import '../blocs/my_list/my_list_cubit.dart';
import '../common/app_strings.dart';
import '../models/movie.dart';
import 'empty_view.dart';
import 'sliver_movie_grid.dart';

/// Lưới "Danh sách của tôi" (dạng sliver), tự cập nhật theo [MyListCubit].
/// Dùng ở chip lọc trang chủ và tab Danh sách.
class SliverMyListGrid extends StatelessWidget {
  const SliverMyListGrid({super.key, required this.heroPrefix});

  final String heroPrefix;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MyListCubit, List<Movie>>(
      builder: (context, movies) => movies.isEmpty
          ? const SliverFillRemaining(
              hasScrollBody: false,
              child: EmptyView(
                icon: Icons.bookmark_border,
                message: AppStrings.myListEmpty,
              ),
            )
          : SliverMovieGrid(movies: movies, heroPrefix: heroPrefix),
    );
  }
}
