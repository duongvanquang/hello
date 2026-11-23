import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';

import '../blocs/auth_form/auth_action.dart';
import '../blocs/auth_form/auth_form_cubit.dart';
import '../blocs/auth_form/auth_form_state.dart';
import '../common/app_messages.dart';
import '../common/app_spacing.dart';
import '../common/app_strings.dart';
import '../common/validators.dart';
import '../services/auth_service.dart';
import '../widgets/auth_header.dart';
import '../widgets/auth_scaffold.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/firebase_setup_notice.dart';
import '../widgets/google_sign_in_button.dart';
import '../widgets/or_divider.dart';
import '../widgets/primary_button.dart';
import '../widgets/text_link_row.dart';

/// Trang tạo tài khoản bằng email/mật khẩu, hoặc dùng luôn tài khoản Google.
class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  static Future<void> open(BuildContext context) =>
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (_) => const RegisterPage()));

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  late final _cubit = AuthFormCubit(context.read<AuthService>());

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    _confirm.dispose();
    _cubit.close();
    super.dispose();
  }

  void _register() {
    if (!_formKey.currentState!.validate()) return;
    _cubit.register(
      name: _name.text.trim(),
      email: _email.text.trim(),
      password: _password.text,
    );
  }

  void _onStateChanged(BuildContext context, AuthFormState state) {
    final error = state.errorMessage;
    if (error != null) AppMessages.show(context, error);
    // Đã đăng nhập: đóng trang này để AuthGate hiện trang chủ.
    if (state.isSuccess) Navigator.of(context).popUntil((r) => r.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthFormCubit, AuthFormState>(
      bloc: _cubit,
      listener: _onStateChanged,
      builder: (context, state) => AuthScaffold(
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
                loading: state.runningAction == AuthAction.email,
                onPressed: state.isBusy ? null : _register,
              ),
              const SizedBox(height: AppSpacing.xl),
              const OrDivider(),
              const SizedBox(height: AppSpacing.xl),
              GoogleSignInButton(
                loading: state.runningAction == AuthAction.google,
                onPressed: state.isBusy ? null : _cubit.signInWithGoogle,
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
      ),
    );
  }
}
