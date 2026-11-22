import 'package:material_ui/material_ui.dart';

import '../common/app_messages.dart';
import '../common/app_strings.dart';
import '../common/validators.dart';
import '../services/auth_failure.dart';
import '../services/auth_service.dart';
import '../widgets/auth_header.dart';
import '../widgets/auth_scaffold.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/firebase_setup_notice.dart';
import '../widgets/google_sign_in_button.dart';
import '../widgets/or_divider.dart';
import '../widgets/primary_button.dart';
import '../widgets/text_link_row.dart';
import '../common/app_spacing.dart';

/// Trang tạo tài khoản bằng email/mật khẩu, hoặc dùng luôn tài khoản Google.
class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  bool _emailLoading = false;
  bool _googleLoading = false;

  bool get _busy => _emailLoading || _googleLoading;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _emailLoading = true);
    await _run(
      () => AuthService.instance.register(
        name: _name.text.trim(),
        email: _email.text.trim(),
        password: _password.text,
      ),
    );
  }

  Future<void> _signInWithGoogle() async {
    setState(() => _googleLoading = true);
    await _run(AuthService.instance.signInWithGoogle);
  }

  Future<void> _run(Future<void> Function() action) async {
    try {
      await action();
      // Đã đăng nhập: đóng trang này để AuthGate hiện trang chủ.
      if (mounted) Navigator.of(context).popUntil((route) => route.isFirst);
    } on AuthFailure catch (e) {
      if (!e.isCancelled && mounted) AppMessages.show(context, e.message);
    } finally {
      if (mounted) {
        setState(() {
          _emailLoading = false;
          _googleLoading = false;
        });
      }
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
              title: AppStrings.registerTitle,
              subtitle: AppStrings.registerSubtitle,
            ),
            const SizedBox(height: AppSpacing.xxxl),
            const FirebaseSetupNotice(),
            AuthTextField(
              controller: _name,
              label: AppStrings.fullName,
              icon: Icons.person_outline,
              keyboardType: TextInputType.name,
              autofillHints: const [AutofillHints.name],
              validator: Validators.name,
            ),
            const SizedBox(height: AppSpacing.ml),
            AuthTextField(
              controller: _email,
              label: AppStrings.email,
              icon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              autofillHints: const [AutofillHints.email],
              validator: Validators.email,
            ),
            const SizedBox(height: AppSpacing.ml),
            AuthTextField(
              controller: _password,
              label: AppStrings.password,
              icon: Icons.lock_outline,
              isPassword: true,
              autofillHints: const [AutofillHints.newPassword],
              validator: Validators.password,
            ),
            const SizedBox(height: AppSpacing.ml),
            AuthTextField(
              controller: _confirm,
              label: AppStrings.confirmPassword,
              icon: Icons.lock_outline,
              isPassword: true,
              textInputAction: TextInputAction.done,
              validator: Validators.confirmPassword(() => _password.text),
              onSubmitted: (_) => _register(),
            ),
            const SizedBox(height: AppSpacing.xxl),
            PrimaryButton(
              label: AppStrings.register,
              loading: _emailLoading,
              onPressed: _busy ? null : _register,
            ),
            const SizedBox(height: AppSpacing.xl),
            const OrDivider(),
            const SizedBox(height: AppSpacing.xl),
            GoogleSignInButton(
              loading: _googleLoading,
              onPressed: _busy ? null : _signInWithGoogle,
            ),
            const SizedBox(height: AppSpacing.l),
            TextLinkRow(
              text: AppStrings.haveAccount,
              linkText: AppStrings.login,
              onTap: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
    );
  }
}
