import 'package:material_ui/material_ui.dart';

import '../common/app_colors.dart';
import '../common/app_text_styles.dart';
import '../common/app_radius.dart';
import '../common/app_sizes.dart';

/// Nút chính màu nhấn, rộng hết chiều ngang.
/// [loading] = true thì hiện vòng xoay và không bấm được.
class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.loading = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: AppSizes.buttonHeight,
      child: FilledButton(
        onPressed: loading ? null : onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.light,
          disabledBackgroundColor: AppColors.primaryDisabled,
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
                  color: AppColors.light,
                ),
              )
            : Text(label, style: AppTextStyles.button),
      ),
    );
  }
}
