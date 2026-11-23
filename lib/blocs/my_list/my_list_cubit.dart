import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/movie.dart';

/// "Danh sách của tôi": các phim đã lưu, phim mới lưu đứng đầu.
/// Dùng chung cả app. Hiện chỉ lưu trong bộ nhớ: tắt app sẽ mất.
class MyListCubit extends Cubit<List<Movie>> {
  MyListCubit() : super(const []);

  bool contains(Movie movie) => state.any((m) => m.key == movie.key);

  void toggle(Movie movie) => emit(
    contains(movie)
        ? state.where((m) => m.key != movie.key).toList()
        : [movie, ...state],
  );
}
