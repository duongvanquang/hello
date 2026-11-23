import 'package:material_ui/material_ui.dart';

import '../common/app_colors.dart';
import '../common/app_radius.dart';
import '../common/app_spacing.dart';
import '../common/app_text_styles.dart';

/// Khung thông báo màu vàng nhạt có biểu tượng cảnh báo.
class NoticeBanner extends StatelessWidget {
  const NoticeBanner({super.key, required this.message, this.margin});

  final String message;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: margin,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.warningBackground,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.warningBorder),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline, color: AppColors.rating),
          const SizedBox(width: AppSpacing.m),
          Expanded(child: Text(message, style: AppTextStyles.small)),
        ],
      ),
    );
  }
}
