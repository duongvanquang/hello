import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:material_ui/material_ui.dart';

import 'package:hello/blocs/auth/auth_cubit.dart';
import 'package:hello/blocs/my_list/my_list_cubit.dart';
import 'package:hello/blocs/user_ratings/user_ratings_cubit.dart';
import 'package:hello/repositories/movie_repository.dart';
import 'package:hello/services/auth_service.dart';
import 'package:hello/services/tmdb_api.dart';

import '../fakes/fake_tmdb_client.dart';

/// Repository dùng API giả (không cần mạng, không cần khóa thật).
MovieRepository fakeRepository({int statusCode = 200, http.Client? client}) =>
    MovieRepository(
      api: TmdbApi(
        client: client ?? FakeTmdbClient.create(statusCode: statusCode),
        apiKey: 'test-key',
      ),
    );

/// Bọc [home] bằng đủ repository + Cubit dùng chung giống app thật.
Widget testApp(Widget home, {MovieRepository? repository}) {
  return MultiRepositoryProvider(
    providers: [
      RepositoryProvider<MovieRepository>.value(
        value: repository ?? fakeRepository(),
      ),
      RepositoryProvider<AuthService>.value(value: AuthService.instance),
    ],
    child: MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthCubit(AuthService.instance)),
        BlocProvider(create: (_) => MyListCubit()),
        BlocProvider(create: (_) => UserRatingsCubit()),
      ],
      child: MaterialApp(home: home),
    ),
  );
}

/// Màn hình cỡ iPhone 17 Pro Max.
void useIphoneSize(WidgetTester tester) {
  tester.view.physicalSize = const Size(1320, 2868);
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);
}
