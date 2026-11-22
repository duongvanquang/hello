import 'app_strings.dart';

/// Kiểm tra dữ liệu người dùng nhập trong các form.
/// Trả về câu báo lỗi, hoặc null nếu hợp lệ (đúng kiểu validator của TextFormField).
class Validators {
  Validators._();

  static final RegExp _emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  static const int minPasswordLength = 6;

  static String? name(String? value) {
    if (value == null || value.trim().isEmpty) return AppStrings.nameRequired;
    if (value.trim().length < 2) return AppStrings.nameTooShort;
    return null;
  }

  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) return AppStrings.emailRequired;
    if (!_emailPattern.hasMatch(value.trim())) return AppStrings.emailInvalid;
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) return AppStrings.passwordRequired;
    if (value.length < minPasswordLength) {
      return AppStrings.passwordTooShort(minPasswordLength);
    }
    return null;
  }

  /// Dùng cho ô "Nhập lại mật khẩu".
  static String? Function(String?) confirmPassword(String Function() original) {
    return (value) {
      if (value == null || value.isEmpty) {
        return AppStrings.confirmPasswordRequired;
      }
      if (value != original()) return AppStrings.passwordMismatch;
      return null;
    };
  }
}
