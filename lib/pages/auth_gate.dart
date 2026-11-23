import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';

import '../blocs/auth/auth_cubit.dart';
import '../blocs/auth/auth_state.dart';
import '../blocs/auth/auth_status.dart';
import '../widgets/loading_view.dart';
import 'login_page.dart';
import 'main_page.dart';

/// Trang đầu tiên: đã đăng nhập thì vào MainPage, chưa thì LoginPage.
/// Tự đổi trang khi đăng nhập / đăng xuất (theo [AuthCubit]).
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) => switch (state.status) {
        AuthStatus.unknown => const Scaffold(body: LoadingView()),
        AuthStatus.authenticated => const MainPage(),
        AuthStatus.unauthenticated => const LoginPage(),
      },
    );
  }
}
