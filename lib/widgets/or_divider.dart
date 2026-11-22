import 'package:material_ui/material_ui.dart';

import '../common/app_colors.dart';
import '../common/app_strings.dart';
import '../common/app_text_styles.dart';
import '../common/app_spacing.dart';
import '../common/app_sizes.dart';

/// Đường kẻ ngang có chữ "hoặc" ở giữa.
class OrDivider extends StatelessWidget {
  const OrDivider({super.key});

  @override
  Widget build(BuildContext context) {
    const line = Expanded(
      child: Divider(color: AppColors.surface, thickness: AppSizes.borderWidth),
    );
    return const Row(
      children: [
        line,
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Text(AppStrings.orDivider, style: AppTextStyles.secondary),
        ),
        line,
      ],
    );
  }
}
