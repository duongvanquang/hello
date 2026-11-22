import 'package:material_ui/material_ui.dart';

import '../common/app_text_styles.dart';
import '../common/app_spacing.dart';

/// Tiêu đề lớn ở đầu các tab (Sắp chiếu, Danh sách của tôi).
class TabTitle extends StatelessWidget {
  const TabTitle({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.l,
        AppSpacing.l,
        AppSpacing.l,
        AppSpacing.xs,
      ),
      child: Text(title, style: AppTextStyles.headline),
    );
  }
}
