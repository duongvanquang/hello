import 'package:material_ui/material_ui.dart';

import '../common/app_colors.dart';
import '../common/app_text_styles.dart';
import '../common/app_spacing.dart';
import '../common/app_sizes.dart';

/// Màn hình trống: biểu tượng + một dòng chữ (chưa có kết quả, danh sách rỗng...).
class EmptyView extends StatelessWidget {
  const EmptyView({super.key, required this.icon, required this.message});

  final IconData icon;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.huge),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: AppSizes.iconXxl, color: AppColors.textSecondary),
            const SizedBox(height: AppSpacing.md),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyles.secondary,
            ),
          ],
        ),
      ),
    );
  }
}
