import 'package:flutter_bloc/flutter_bloc.dart';

import '../../services/auth_failure.dart';
import '../../services/auth_service.dart';
import 'auth_action.dart';
import 'auth_form_state.dart';

/// Xử lý đăng nhập, đăng ký, gửi email đặt lại mật khẩu.
/// Mỗi trang form có một bản riêng.
class AuthFormCubit extends Cubit<AuthFormState> {
  AuthFormCubit(this._authService) : super(const AuthFormState());

  final AuthService _authService;

  Future<void> signInWithEmail(String email, String password) => _run(
    AuthAction.email,
    () => _authService.signInWithEmail(email, password),
  );

  Future<void> signInWithGoogle() =>
      _run(AuthAction.google, _authService.signInWithGoogle);

  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) => _run(
    AuthAction.email,
    () => _authService.register(name: name, email: email, password: password),
  );

  Future<void> sendPasswordReset(String email) =>
      _run(AuthAction.email, () => _authService.sendPasswordReset(email));

  Future<void> _run(AuthAction action, Future<void> Function() task) async {
    if (state.isBusy) return;
    emit(AuthFormState(runningAction: action));
    try {
      await task();
      emit(const AuthFormState(isSuccess: true));
    } on AuthFailure catch (e) {
      // Người dùng tự đóng cửa sổ Google thì không báo lỗi.
      emit(AuthFormState(errorMessage: e.isCancelled ? null : e.message));
    }
  }
}
