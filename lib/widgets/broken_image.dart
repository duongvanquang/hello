import 'package:material_ui/material_ui.dart';

import '../common/app_colors.dart';
import '../common/app_sizes.dart';

/// Biểu tượng thay ảnh khi phim không có ảnh hoặc tải ảnh lỗi.
class BrokenImage extends StatelessWidget {
  const BrokenImage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Icon(
        Icons.movie_outlined,
        color: AppColors.textSecondary,
        size: AppSizes.iconXl,
      ),
    );
  }
}
