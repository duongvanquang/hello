import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';

import '../blocs/auth/auth_cubit.dart';
import '../common/app_colors.dart';
import '../common/app_messages.dart';
import '../common/app_radius.dart';
import '../common/app_sizes.dart';
import '../common/app_spacing.dart';
import '../common/app_strings.dart';
import '../common/app_text_styles.dart';
import '../services/auth_failure.dart';
import 'user_avatar.dart';

/// Bảng trượt từ dưới lên khi bấm ảnh đại diện: tên, email, nút Đăng xuất.
class AccountSheet extends StatelessWidget {
  const AccountSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppRadius.sheet),
        ),
      ),
      builder: (_) => const AccountSheet(),
    );
  }

  Future<void> _signOut(BuildContext context) async {
    final authCubit = context.read<AuthCubit>();
    final navigator = Navigator.of(context);
    try {
      await authCubit.signOut();
      navigator.pop();
    } on AuthFailure catch (e) {
      if (context.mounted) AppMessages.show(context, e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = context.read<AuthCubit>().state.user;
    final displayName = user?.displayName ?? '';
    final email = user?.email;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.xl,
          AppSpacing.xxl,
          AppSpacing.xl,
          AppSpacing.l,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const UserAvatar(size: AppSizes.avatarLarge),
            const SizedBox(height: AppSpacing.md),
            Text(
              displayName.isNotEmpty ? displayName : AppStrings.guestName,
              style: AppTextStyles.title,
            ),
            if (email != null) ...[
              const SizedBox(height: AppSpacing.xs),
              Text(email, style: AppTextStyles.secondary),
            ],
            const SizedBox(height: AppSpacing.xl),
            SizedBox(
              width: double.infinity,
              height: AppSizes.buttonHeightSmall,
              child: OutlinedButton.icon(
                onPressed: () => _signOut(context),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.error,
                  side: const BorderSide(color: AppColors.error),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                ),
                icon: const Icon(Icons.logout),
                label: const Text(
                  AppStrings.logout,
                  style: AppTextStyles.button,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
