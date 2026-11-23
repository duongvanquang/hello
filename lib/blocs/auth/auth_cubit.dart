import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../services/auth_service.dart';
import 'auth_state.dart';
import 'auth_status.dart';

/// Theo dõi đăng nhập / đăng xuất để AuthGate chọn trang.
class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this._authService) : super(_initialState(_authService)) {
    _subscription = _authService.userChanges.listen(_onUserChanged);
  }

  final AuthService _authService;
  late final StreamSubscription<User?> _subscription;

  static AuthState _initialState(AuthService service) {
    final user = service.currentUser;
    if (user != null) {
      return AuthState(status: AuthStatus.authenticated, user: user);
    }
    // Chưa kết nối Firebase thì chắc chắn chưa đăng nhập, khỏi chờ.
    return service.isReady
        ? const AuthState()
        : const AuthState(status: AuthStatus.unauthenticated);
  }

  void _onUserChanged(User? user) => emit(
    user == null
        ? const AuthState(status: AuthStatus.unauthenticated)
        : AuthState(status: AuthStatus.authenticated, user: user),
  );

  Future<void> signOut() => _authService.signOut();

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }
}
