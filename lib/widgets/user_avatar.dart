import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';

import '../blocs/auth/auth_cubit.dart';
import '../blocs/avatar/avatar_cubit.dart';
import '../common/app_colors.dart';
import '../common/app_radius.dart';
import '../common/app_sizes.dart';

/// Ảnh đại diện người dùng. Ưu tiên: ảnh tự chọn ([AvatarCubit]) → ảnh
/// tài khoản Google → biểu tượng người.
class UserAvatar extends StatelessWidget {
  const UserAvatar({super.key, this.size = AppSizes.avatar});

  final double size;

  @override
  Widget build(BuildContext context) {
    final localPath = context.watch<AvatarCubit>().state.localPath;
    final photoUrl = context.watch<AuthCubit>().state.user?.photoURL;
    final ImageProvider? image = localPath != null
        ? FileImage(File(localPath))
        : (photoUrl != null ? NetworkImage(photoUrl) : null);

    final fallback = Icon(
      Icons.person,
      size: size * AppSizes.avatarIconRatio,
      color: AppColors.light,
    );

    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.s),
      child: Container(
        width: size,
        height: size,
        color: AppColors.primary,
        child: image == null
            ? fallback
            : Image(
                image: image,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => fallback,
              ),
      ),
    );
  }
}
