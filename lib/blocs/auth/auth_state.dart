import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'auth_status.dart';

/// Phiên đăng nhập hiện tại.
class AuthState extends Equatable {
  const AuthState({this.status = AuthStatus.unknown, this.user});

  final AuthStatus status;
  final User? user;

  @override
  List<Object?> get props => [status, user?.uid];
}
