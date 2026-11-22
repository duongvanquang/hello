import 'package:material_ui/material_ui.dart';

import '../common/app_colors.dart';
import '../common/app_sizes.dart';
import '../common/app_radius.dart';

/// Ảnh đại diện người dùng (tạm thời là biểu tượng).
class UserAvatar extends StatelessWidget {
  const UserAvatar({super.key, this.size = AppSizes.avatar});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(AppRadius.s),
      ),
      child: Icon(
        Icons.person,
        size: size * AppSizes.avatarIconRatio,
        color: AppColors.light,
      ),
    );
  }
}
