import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:hello/blocs/home/home_cubit.dart';
import 'package:hello/blocs/home/home_state.dart';
import 'package:hello/blocs/load_status.dart';
import 'package:hello/common/app_strings.dart';
import 'package:hello/models/genre.dart';
import 'package:hello/models/home_filter.dart';

import '../helpers/test_app.dart';

void main() {
  blocTest<HomeCubit, HomeState>(
    'Tải trang chủ: đang tải rồi có dữ liệu',
    build: () => HomeCubit(fakeRepository()),
    act: (cubit) => cubit.load(),
    expect: () => [
      isA<HomeState>().having((s) => s.status, 'status', LoadStatus.loading),
      isA<HomeState>()
          .having((s) => s.status, 'status', LoadStatus.success)
          .having((s) => s.homeData?.featured, 'featured', isNotNull),
    ],
  );

  blocTest<HomeCubit, HomeState>(
    'Chọn Phim bộ rồi bấm lại thì bỏ lọc',
    build: () => HomeCubit(fakeRepository()),
    act: (cubit) async {
      await cubit.selectFilter(HomeFilter.tvSeries);
      await cubit.selectFilter(HomeFilter.tvSeries);
    },
    verify: (cubit) => expect(cubit.state.filter, HomeFilter.all),
  );

  blocTest<HomeCubit, HomeState>(
    'Chọn thể loại thì tải lưới phim của thể loại đó',
    build: () => HomeCubit(fakeRepository()),
    act: (cubit) => cubit.selectGenre(const Genre(id: 35, name: 'Hài')),
    verify: (cubit) {
      expect(cubit.state.filter, HomeFilter.genre);
      expect(cubit.state.genre?.name, 'Hài');
      expect(cubit.state.genreMovies, isNotEmpty);
    },
  );

  blocTest<HomeCubit, HomeState>(
    'API lỗi thì báo lỗi bằng tiếng Việt',
    build: () => HomeCubit(fakeRepository(statusCode: 401)),
    act: (cubit) => cubit.load(),
    verify: (cubit) {
      expect(cubit.state.status, LoadStatus.failure);
      expect(cubit.state.errorMessage, AppStrings.invalidApiKey);
    },
  );
}
