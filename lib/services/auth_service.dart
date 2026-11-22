import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../common/app_strings.dart';
import '../firebase_options.dart';
import 'auth_error_messages.dart';
import 'auth_failure.dart';

/// Mọi thao tác đăng nhập / đăng ký / đăng xuất đi qua lớp này.
/// Các trang chỉ gọi AuthService, không gọi thẳng Firebase.
class AuthService {
  AuthService._();

  static final AuthService instance = AuthService._();

  bool _isReady = false;

  /// false khi chưa cấu hình Firebase (chưa chạy `flutterfire configure`).
  bool get isReady => _isReady;

  FirebaseAuth get _auth => FirebaseAuth.instance;

  bool get _isIOS => defaultTargetPlatform == TargetPlatform.iOS;

  /// Mã Google của app iOS. Chỉ có khi đã bật Google trong Firebase
  /// (Authentication → Sign-in method) rồi chạy lại `flutterfire configure`.
  String? get _iosGoogleClientId =>
      _isIOS ? DefaultFirebaseOptions.currentPlatform.iosClientId : null;

  /// Thiếu mã này mà vẫn gọi Google Sign-In thì app iOS bị crash.
  bool get _isGoogleConfigured => !_isIOS || _iosGoogleClientId != null;

  /// Gọi một lần trong main() trước runApp().
  Future<void> init() async {
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      _isReady = true;
    } catch (e) {
      debugPrint('Firebase chưa được cấu hình: $e');
      return;
    }
    try {
      if (_isGoogleConfigured) {
        await GoogleSignIn.instance.initialize(clientId: _iosGoogleClientId);
      }
    } catch (e) {
      debugPrint('Google Sign-In chưa được cấu hình: $e');
    }
  }

  /// Phát ra người dùng hiện tại mỗi khi đăng nhập / đăng xuất.
  Stream<User?> get userChanges =>
      _isReady ? _auth.authStateChanges() : Stream<User?>.value(null);

  User? get currentUser => _isReady ? _auth.currentUser : null;

  Future<void> signInWithEmail(String email, String password) => _run(
    () => _auth.signInWithEmailAndPassword(email: email, password: password),
  );

  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) => _run(() async {
    final result = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    await result.user?.updateDisplayName(name);
    await result.user?.reload();
  });

  Future<void> signInWithGoogle() => _run(() async {
    if (!_isGoogleConfigured) {
      throw const AuthFailure(AppStrings.googleNotEnabled);
    }
    final account = await GoogleSignIn.instance.authenticate();
    final idToken = account.authentication.idToken;
    final credential = GoogleAuthProvider.credential(idToken: idToken);
    await _auth.signInWithCredential(credential);
  });

  Future<void> sendPasswordReset(String email) =>
      _run(() => _auth.sendPasswordResetEmail(email: email));

  Future<void> signOut() => _run(() async {
    try {
      if (_isGoogleConfigured) await GoogleSignIn.instance.signOut();
    } catch (_) {
      // Không đăng nhập bằng Google thì bỏ qua.
    }
    await _auth.signOut();
  });

  /// Chạy thao tác và đổi mọi lỗi thành [AuthFailure] có câu tiếng Việt.
  Future<void> _run(Future<void> Function() action) async {
    if (!_isReady) throw const AuthFailure(AppStrings.firebaseNotConfigured);
    try {
      await action();
    } on FirebaseAuthException catch (e) {
      throw AuthFailure(AuthErrorMessages.fromCode(e.code));
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) {
        throw const AuthFailure.cancelled();
      }
      throw const AuthFailure(AppStrings.googleSignInFailed);
    }
  }
}
