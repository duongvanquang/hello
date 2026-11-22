import 'package:material_ui/material_ui.dart';

import '../common/app_colors.dart';
import '../common/app_strings.dart';
import '../common/app_text_styles.dart';
import '../common/app_spacing.dart';
import '../common/app_radius.dart';
import '../common/app_sizes.dart';

/// Nút "Tiếp tục với Google" (nền trắng, chữ G nhiều màu).
class GoogleSignInButton extends StatelessWidget {
  const GoogleSignInButton({
    super.key,
    required this.onPressed,
    this.loading = false,
  });

  final VoidCallback? onPressed;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: AppSizes.buttonHeight,
      child: OutlinedButton(
        onPressed: loading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: AppColors.light,
          foregroundColor: AppColors.textOnLight,
          disabledBackgroundColor: AppColors.lightDisabled,
          side: BorderSide.none,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
        ),
        child: loading
            ? const SizedBox(
                width: AppSizes.buttonLoader,
                height: AppSizes.buttonLoader,
                child: CircularProgressIndicator(
                  strokeWidth: AppSizes.loaderStroke,
                  color: AppColors.primary,
                ),
              )
            : const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    AppStrings.googleLogoLetter,
                    style: AppTextStyles.googleLogo,
                  ),
                  SizedBox(width: AppSpacing.md),
                  Text(
                    AppStrings.continueWithGoogle,
                    style: AppTextStyles.button,
                  ),
                ],
              ),
      ),
    );
  }
}
