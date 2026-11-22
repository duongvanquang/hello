import 'package:material_ui/material_ui.dart';

import '../common/app_colors.dart';
import '../common/app_spacing.dart';
import '../common/app_sizes.dart';

/// Khung chung cho các trang đăng nhập / đăng ký / quên mật khẩu:
/// nền tối, cuộn được khi bàn phím bật, nội dung không quá rộng.
class AuthScaffold extends StatelessWidget {
  const AuthScaffold({super.key, required this.child, this.showBack = false});

  final Widget child;

  /// Hiện nút quay lại ở góc trên (trang con như Đăng ký, Quên mật khẩu).
  final bool showBack;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: showBack
          ? AppBar(
              backgroundColor: Colors.transparent,
              surfaceTintColor: Colors.transparent,
              iconTheme: const IconThemeData(color: AppColors.textPrimary),
            )
          : null,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.xxl,
              vertical: AppSpacing.xxl,
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: AppSizes.authMaxWidth,
              ),
              child: AutofillGroup(child: child),
            ),
          ),
        ),
      ),
    );
  }
}
