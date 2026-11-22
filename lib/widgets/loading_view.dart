import 'package:material_ui/material_ui.dart';

import '../common/app_colors.dart';
import '../common/app_strings.dart';
import '../common/app_text_styles.dart';
import '../common/app_spacing.dart';

/// Vòng xoay + chữ "Đang tải phim..." ở giữa màn hình.
class LoadingView extends StatelessWidget {
  const LoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(color: AppColors.primary),
          SizedBox(height: AppSpacing.ml),
          Text(AppStrings.loading, style: AppTextStyles.secondary),
        ],
      ),
    );
  }
}
