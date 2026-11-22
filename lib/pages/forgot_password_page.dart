import 'package:material_ui/material_ui.dart';

import '../common/app_messages.dart';
import '../common/app_strings.dart';
import '../common/validators.dart';
import '../services/auth_failure.dart';
import '../services/auth_service.dart';
import '../widgets/auth_header.dart';
import '../widgets/auth_scaffold.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/primary_button.dart';
import '../widgets/text_link_row.dart';
import '../common/app_spacing.dart';

/// Trang gửi email đặt lại mật khẩu.
class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key, this.initialEmail = ''});

  /// Điền sẵn email người dùng đã gõ ở trang đăng nhập.
  final String initialEmail;

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  late final _email = TextEditingController(text: widget.initialEmail.trim());
  bool _loading = false;

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      await AuthService.instance.sendPasswordReset(_email.text.trim());
      if (!mounted) return;
      AppMessages.show(context, AppStrings.resetLinkSent);
      Navigator.of(context).pop();
    } on AuthFailure catch (e) {
      if (mounted) AppMessages.show(context, e.message);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      showBack: true,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const AuthHeader(
              title: AppStrings.forgotTitle,
              subtitle: AppStrings.forgotSubtitle,
            ),
            const SizedBox(height: AppSpacing.xxxl),
            AuthTextField(
              controller: _email,
              label: AppStrings.email,
              icon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.done,
              autofillHints: const [AutofillHints.email],
              validator: Validators.email,
              onSubmitted: (_) => _send(),
            ),
            const SizedBox(height: AppSpacing.xxl),
            PrimaryButton(
              label: AppStrings.sendResetLink,
              loading: _loading,
              onPressed: _send,
            ),
            const SizedBox(height: AppSpacing.sm),
            TextLinkRow(
              text: '',
              linkText: AppStrings.backToLogin,
              onTap: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
    );
  }
}
