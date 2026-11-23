import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';

import '../blocs/avatar/avatar_cubit.dart';
import '../blocs/avatar/avatar_state.dart';
import '../common/app_colors.dart';
import '../common/app_messages.dart';
import '../common/app_sizes.dart';
import '../common/app_spacing.dart';
import 'avatar_source_sheet.dart';
import 'user_avatar.dart';

/// Ảnh đại diện có nút máy ảnh nhỏ ở góc. Bấm vào để chụp / chọn / xóa ảnh.
/// Đang lưu thì hiện vòng xoay; lỗi thì báo bằng tiếng Việt.
class EditableAvatar extends StatelessWidget {
  const EditableAvatar({super.key, this.size = AppSizes.avatarLarge});

  final double size;

  Future<void> _change(BuildContext context) async {
    final cubit = context.read<AvatarCubit>();
    final action = await AvatarSourceSheet.show(
      context,
      canRemove: cubit.state.localPath != null,
    );
    if (action != null) await cubit.handle(action);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AvatarCubit, AvatarState>(
      listenWhen: (previous, current) =>
          current.errorMessage != null &&
          current.errorMessage != previous.errorMessage,
      listener: (context, state) =>
          AppMessages.show(context, state.errorMessage!),
      builder: (context, state) => GestureDetector(
        onTap: state.isSaving ? null : () => _change(context),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            UserAvatar(size: size),
            if (state.isSaving)
              Positioned.fill(
                child: ColoredBox(
                  color: AppColors.badgeBackground,
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.light,
                      strokeWidth: AppSizes.loaderStroke,
                    ),
                  ),
                ),
              ),
            Positioned(
              right: -AppSpacing.xs,
              bottom: -AppSpacing.xs,
              child: Container(
                width: AppSizes.avatarBadge,
                height: AppSizes.avatarBadge,
                decoration: const BoxDecoration(
                  color: AppColors.surface,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.photo_camera,
                  size: AppSizes.iconS,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
