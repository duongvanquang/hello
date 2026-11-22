import 'package:material_ui/material_ui.dart';

import '../common/app_colors.dart';
import '../common/app_text_styles.dart';
import '../common/app_spacing.dart';
import '../common/app_radius.dart';
import '../common/app_sizes.dart';
import '../common/app_strings.dart';
import '../common/app_limits.dart';

/// Nhãn điểm nhỏ (⭐ 7.8) đặt ở góc poster.
class RatingBadge extends StatelessWidget {
  const RatingBadge({super.key, required this.rating});

  final double rating;

  @override
  Widget build(BuildContext context) {
    if (rating <= AppLimits.noRating) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s,
        vertical: AppSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: AppColors.badgeBackground,
        borderRadius: BorderRadius.circular(AppRadius.s),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.star,
            size: AppSizes.iconXs,
            color: AppColors.rating,
          ),
          const SizedBox(width: AppSpacing.xxs),
          Text(AppStrings.rating(rating), style: AppTextStyles.badge),
        ],
      ),
    );
  }
}
