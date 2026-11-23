import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:hello/blocs/load_status.dart';
import 'package:hello/blocs/my_list/my_list_cubit.dart';
import 'package:hello/blocs/rate_movie/rate_movie_cubit.dart';
import 'package:hello/blocs/rate_movie/rate_movie_state.dart';
import 'package:hello/blocs/user_ratings/user_ratings_cubit.dart';
import 'package:hello/common/app_strings.dart';
import 'package:hello/models/media_type.dart';
import 'package:hello/models/movie.dart';

import '../helpers/test_app.dart';

const _movie = Movie(id: 1, title: 'Phim', description: '', rating: 7);
const _tvWithSameId = Movie(
  id: 1,
  title: 'Phim bộ',
  description: '',
  rating: 7,
  mediaType: MediaType.tv,
);

void main() {
  blocTest<MyListCubit, List<Movie>>(
    'Thêm rồi bỏ phim khỏi danh sách; phim lẻ và phim bộ trùng id không lẫn',
    build: MyListCubit.new,
    act: (cubit) => cubit
      ..toggle(_movie)
      ..toggle(_tvWithSameId)
      ..toggle(_movie),
    expect: () => [
      [_movie],
      [_tvWithSameId, _movie],
      [_tvWithSameId],
    ],
  );

  blocTest<RateMovieCubit, RateMovieState>(
    'Gửi khi chưa chọn sao thì nhắc chọn sao',
    build: () => RateMovieCubit(fakeRepository(), UserRatingsCubit(), _movie),
    act: (cubit) => cubit.submit(),
    expect: () => [
      const RateMovieState(errorMessage: AppStrings.rateChooseStars),
    ],
  );

  test('Chọn 3 sao rồi gửi thì lưu vào UserRatingsCubit', () async {
    final ratings = UserRatingsCubit();
    final cubit = RateMovieCubit(fakeRepository(), ratings, _movie)
      ..selectStars(3);
    await cubit.submit();

    expect(cubit.state.status, LoadStatus.success);
    expect(ratings.starsOf(_movie), 3);
  });
}
