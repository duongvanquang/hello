import 'package:material_ui/material_ui.dart';

import '../common/app_colors.dart';
import '../common/app_text_styles.dart';
import '../common/app_spacing.dart';
import '../common/app_radius.dart';
import '../common/app_sizes.dart';

/// Nút dạng biểu tượng + chữ nhỏ bên dưới (Danh sách, Thông tin, Chia sẻ...).
/// [highlighted] = true thì biểu tượng đổi sang màu nhấn.
class IconLabelButton extends StatelessWidget {
  const IconLabelButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.highlighted = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    final color = highlighted ? AppColors.primary : AppColors.textPrimary;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.sm),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.s,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: AppSizes.iconL),
            const SizedBox(height: AppSpacing.xs),
            Text(label, style: AppTextStyles.label),
          ],
        ),
      ),
    );
  }
}
