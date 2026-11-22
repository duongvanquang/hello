import '../common/app_strings.dart';
import '../common/validators.dart';

/// Đổi mã lỗi của Firebase Auth thành câu tiếng Việt (lấy từ AppStrings).
class AuthErrorMessages {
  AuthErrorMessages._();

  static String fromCode(String code) {
    switch (code) {
      case 'invalid-email':
        return AppStrings.emailInvalid;
      case 'user-disabled':
        return AppStrings.accountDisabled;
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return AppStrings.wrongCredentials;
      case 'email-already-in-use':
        return AppStrings.emailInUse;
      case 'weak-password':
        return AppStrings.passwordTooShort(Validators.minPasswordLength);
      case 'account-exists-with-different-credential':
        return AppStrings.accountExistsOtherMethod;
      case 'too-many-requests':
        return AppStrings.tooManyAttempts;
      case 'network-request-failed':
        return AppStrings.noNetwork;
      case 'operation-not-allowed':
        return AppStrings.signInMethodDisabled;
      default:
        return AppStrings.unknownError(code);
    }
  }
}
