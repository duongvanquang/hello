import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';

import '../common/app_colors.dart';
import '../common/app_radius.dart';
import '../common/app_spacing.dart';
import '../common/app_strings.dart';
import '../common/app_text_styles.dart';
import '../services/auth_service.dart';

/// Khung cảnh báo khi app chưa kết nối Firebase. Đã kết nối thì không hiện gì.
class FirebaseSetupNotice extends StatelessWidget {
  const FirebaseSetupNotice({super.key});

  @override
  Widget build(BuildContext context) {
    if (context.read<AuthService>().isReady) return const SizedBox.shrink();
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: AppSpacing.l),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.warningBackground,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.warningBorder),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.warning_amber_rounded, color: AppColors.rating),
          SizedBox(width: AppSpacing.m),
          Expanded(
            child: Text(
              AppStrings.firebaseNotConfigured,
              style: AppTextStyles.small,
            ),
          ),
        ],
      ),
    );
  }
}
