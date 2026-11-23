import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';

import '../blocs/auth_form/auth_action.dart';
import '../blocs/auth_form/auth_form_cubit.dart';
import '../blocs/auth_form/auth_form_state.dart';
import '../common/app_messages.dart';
import '../common/app_spacing.dart';
import '../common/app_strings.dart';
import '../common/app_text_styles.dart';
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
import 'forgot_password_page.dart';
import 'register_page.dart';

/// Trang đăng nhập bằng email/mật khẩu hoặc Google.
/// Logic nằm trong [AuthFormCubit]; đăng nhập xong thì AuthGate tự chuyển trang.
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  late final _cubit = AuthFormCubit(context.read<AuthService>());

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _cubit.close();
    super.dispose();
  }

  void _signInWithEmail() {
    if (!_formKey.currentState!.validate()) return;
    _cubit.signInWithEmail(_email.text.trim(), _password.text);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthFormCubit, AuthFormState>(
      bloc: _cubit,
      listener: (context, state) {
        final error = state.errorMessage;
        if (error != null) AppMessages.show(context, error);
      },
      builder: (context, state) => AuthScaffold(
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
                  onPressed: state.isBusy
                      ? null
                      : () => ForgotPasswordPage.open(context, _email.text),
                  child: const Text(
                    AppStrings.forgotPasswordLink,
                    style: AppTextStyles.secondary,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              PrimaryButton(
                label: AppStrings.login,
                loading: state.runningAction == AuthAction.email,
                onPressed: state.isBusy ? null : _signInWithEmail,
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
                text: AppStrings.noAccount,
                linkText: AppStrings.register,
                onTap: () => RegisterPage.open(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
