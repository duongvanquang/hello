import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_ui/material_ui.dart';

import 'blocs/auth/auth_cubit.dart';
import 'blocs/avatar/avatar_cubit.dart';
import 'blocs/my_list/my_list_cubit.dart';
import 'blocs/user_ratings/user_ratings_cubit.dart';
import 'common/app_colors.dart';
import 'common/app_strings.dart';
import 'common/app_text_styles.dart';
import 'pages/auth_gate.dart';
import 'repositories/movie_repository.dart';
import 'services/auth_service.dart';
import 'services/avatar_storage.dart';

/// Gốc của app: cung cấp repository và các Cubit dùng chung cho mọi trang.
/// Test có thể truyền [movieRepository] / [authService] giả.
class MyApp extends StatelessWidget {
  const MyApp({super.key, this.movieRepository, this.authService});

  final MovieRepository? movieRepository;
  final AuthService? authService;

  @override
  Widget build(BuildContext context) {
    final theme = ThemeData(
      colorScheme: AppColors.scheme,
      scaffoldBackgroundColor: AppColors.background,
      fontFamily: AppTextStyles.fontFamily,
    );

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<MovieRepository>(
          create: (_) => movieRepository ?? MovieRepository(),
        ),
        RepositoryProvider<AuthService>(
          create: (_) => authService ?? AuthService.instance,
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (ctx) => AuthCubit(ctx.read<AuthService>())),
          BlocProvider(
            create: (ctx) => AvatarCubit(
              AvatarStorage(),
              ImagePicker(),
              ctx.read<AuthCubit>(),
            ),
          ),
          BlocProvider(create: (_) => MyListCubit()),
          BlocProvider(create: (_) => UserRatingsCubit()),
        ],
        child: MaterialApp(
          title: AppStrings.appName,
          debugShowCheckedModeBanner: false,
          themeMode: ThemeMode.dark,
          darkTheme: theme,
          theme: theme,
          home: const AuthGate(),
        ),
      ),
    );
  }
}
