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
import 'forgot_password_page.dart';
import 'register_page.dart';
import '../common/app_text_styles.dart';
import '../common/app_spacing.dart';

/// Trang đăng nhập bằng email/mật khẩu hoặc Google.
/// Đăng nhập thành công thì AuthGate tự chuyển sang trang chủ.
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _emailLoading = false;
  bool _googleLoading = false;

  bool get _busy => _emailLoading || _googleLoading;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _signInWithEmail() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _emailLoading = true);
    await _run(
      () => AuthService.instance.signInWithEmail(
        _email.text.trim(),
        _password.text,
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
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const AuthHeader(
              title: AppStrings.login,
              subtitle: AppStrings.loginSubtitle,
            ),
            const SizedBox(height: AppSpacing.xxxl),
            const FirebaseSetupNotice(),
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
              textInputAction: TextInputAction.done,
              autofillHints: const [AutofillHints.password],
              validator: Validators.password,
              onSubmitted: (_) => _signInWithEmail(),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: _busy
                    ? null
                    : () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) =>
                              ForgotPasswordPage(initialEmail: _email.text),
                        ),
                      ),
                child: const Text(
                  AppStrings.forgotPasswordLink,
                  style: AppTextStyles.secondary,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            PrimaryButton(
              label: AppStrings.login,
              loading: _emailLoading,
              onPressed: _busy ? null : _signInWithEmail,
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
              text: AppStrings.noAccount,
              linkText: AppStrings.register,
              onTap: () => Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (_) => const RegisterPage())),
            ),
          ],
        ),
      ),
    );
  }
}
