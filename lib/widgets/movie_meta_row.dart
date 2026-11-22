import 'package:material_ui/material_ui.dart';

import '../common/app_colors.dart';
import '../common/app_strings.dart';
import '../models/movie.dart';
import '../common/app_text_styles.dart';
import '../common/app_spacing.dart';
import '../common/app_radius.dart';
import '../common/app_sizes.dart';

/// Hàng thông tin phim: năm • 18+ • thời lượng • điểm.
class MovieMetaRow extends StatelessWidget {
  const MovieMetaRow({super.key, required this.movie});

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    const meta = AppTextStyles.bodySecondary;
    final duration = movie.durationText;

    return Wrap(
      spacing: AppSpacing.md,
      runSpacing: AppSpacing.s,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        if (movie.year != null) Text('${movie.year}', style: meta),
        if (movie.isAdult)
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.s,
              vertical: AppSpacing.xxs,
            ),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppRadius.xs),
            ),
            child: const Text(AppStrings.adultBadge, style: meta),
          ),
        if (duration != null) Text(duration, style: meta),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.star,
              size: AppSizes.iconS,
              color: AppColors.rating,
            ),
            const SizedBox(width: AppSpacing.xs),
            Text(
              AppStrings.rating(movie.rating),
              style: AppTextStyles.bodyStrong,
            ),
          ],
        ),
      ],
    );
  }
}
