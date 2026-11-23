import 'package:material_ui/material_ui.dart';

import '../common/app_colors.dart';
import '../common/app_radius.dart';
import '../common/app_spacing.dart';
import '../common/app_strings.dart';
import '../common/app_text_styles.dart';
import '../models/avatar_action.dart';

/// Bảng chọn cách đổi ảnh đại diện: Chụp ảnh / Chọn từ thư viện / Xóa ảnh.
/// Trả về lựa chọn, hoặc null nếu đóng bảng.
class AvatarSourceSheet extends StatelessWidget {
  const AvatarSourceSheet({super.key, required this.canRemove});

  /// Hiện nút "Xóa ảnh đại diện" khi người dùng đã có ảnh tự chọn.
  final bool canRemove;

  static Future<AvatarAction?> show(
    BuildContext context, {
    required bool canRemove,
  }) {
    return showModalBottomSheet<AvatarAction>(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppRadius.sheet),
        ),
      ),
      builder: (_) => AvatarSourceSheet(canRemove: canRemove),
    );
  }

  Widget _option(
    BuildContext context,
    IconData icon,
    String label,
    AvatarAction action, {
    Color color = AppColors.textPrimary,
  }) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(label, style: AppTextStyles.primary.copyWith(color: color)),
      onTap: () => Navigator.of(context).pop(action),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.all(AppSpacing.sm),
              child: Text(AppStrings.changeAvatar, style: AppTextStyles.title),
            ),
            _option(
              context,
              Icons.photo_camera_outlined,
              AppStrings.takePhoto,
              AvatarAction.camera,
            ),
            _option(
              context,
              Icons.photo_library_outlined,
              AppStrings.chooseFromLibrary,
              AvatarAction.gallery,
            ),
            if (canRemove)
              _option(
                context,
                Icons.delete_outline,
                AppStrings.removePhoto,
                AvatarAction.remove,
                color: AppColors.error,
              ),
          ],
        ),
      ),
    );
  }
}
