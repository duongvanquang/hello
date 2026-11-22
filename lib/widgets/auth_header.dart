import 'package:material_ui/material_ui.dart';

import '../common/app_assets.dart';
import '../common/app_strings.dart';
import '../common/app_text_styles.dart';
import '../common/app_spacing.dart';
import '../common/app_radius.dart';
import '../common/app_sizes.dart';

/// Phần đầu các trang đăng nhập / đăng ký: icon app, tên app, tiêu đề, mô tả.
class AuthHeader extends StatelessWidget {
  const AuthHeader({super.key, required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.logo),
          child: Image.asset(
            AppAssets.appIcon,
            width: AppSizes.authLogo,
            height: AppSizes.authLogo,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        const Text(AppStrings.appName, style: AppTextStyles.brand),
        const SizedBox(height: AppSpacing.xxl),
        Text(title, style: AppTextStyles.headline),
        const SizedBox(height: AppSpacing.s),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: AppTextStyles.bodySecondary,
        ),
      ],
    );
  }
}
