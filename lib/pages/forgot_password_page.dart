import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';

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
import '../widgets/primary_button.dart';
import '../widgets/text_link_row.dart';

/// Trang gửi email đặt lại mật khẩu.
class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key, this.initialEmail = ''});

  /// Điền sẵn email người dùng đã gõ ở trang đăng nhập.
  final String initialEmail;

  static Future<void> open(BuildContext context, String email) =>
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => ForgotPasswordPage(initialEmail: email),
        ),
      );

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  late final _email = TextEditingController(text: widget.initialEmail.trim());
  late final _cubit = AuthFormCubit(context.read<AuthService>());

  @override
  void dispose() {
    _email.dispose();
    _cubit.close();
    super.dispose();
  }

  void _send() {
    if (!_formKey.currentState!.validate()) return;
    _cubit.sendPasswordReset(_email.text.trim());
  }

  void _onStateChanged(BuildContext context, AuthFormState state) {
    final error = state.errorMessage;
    if (error != null) AppMessages.show(context, error);
    if (state.isSuccess) {
      AppMessages.show(context, AppStrings.resetLinkSent);
      Navigator.of(context).pop();
    }
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
                loading: state.isBusy,
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
      ),
    );
  }
}
