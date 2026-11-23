import 'package:material_ui/material_ui.dart';

import '../common/app_colors.dart';
import '../common/app_strings.dart';
import '../models/movie.dart';
import 'icon_label_button.dart';
import 'movie_artwork.dart';
import '../common/app_text_styles.dart';
import '../common/app_spacing.dart';
import '../common/app_radius.dart';
import '../common/app_sizes.dart';
import '../common/app_limits.dart';
import '../common/app_gradients.dart';
import '../common/app_playback.dart';

/// Banner lớn đầu trang chủ giới thiệu một phim nổi bật.
class FeaturedBanner extends StatelessWidget {
  const FeaturedBanner({
    super.key,
    required this.movie,
    required this.inMyList,
    required this.onPlay,
    required this.onToggleMyList,
    required this.onInfo,
  });

  final Movie movie;
  final bool inMyList;
  final VoidCallback onPlay;
  final VoidCallback onToggleMyList;
  final VoidCallback onInfo;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSizes.bannerHeight,
      child: Stack(
        fit: StackFit.expand,
        children: [
          MovieArtwork(movie: movie),
          // Làm tối dần xuống dưới để chữ dễ đọc và hòa vào nền.
          const DecoratedBox(
            decoration: BoxDecoration(gradient: AppGradients.bannerFade),
          ),
          Positioned(
            left: AppSpacing.screen,
            right: AppSpacing.screen,
            bottom: AppSpacing.xl,
            child: Column(
              children: [
                const Text(
                  AppStrings.featuredLabel,
                  style: AppTextStyles.overline,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  movie.title,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.display,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  [
                    if (movie.genres.isNotEmpty)
                      movie.genres.take(AppLimits.bannerGenres).join(', '),
                    if (movie.year != null) '${movie.year}',
                  ].join(AppStrings.metaSeparator),
                  style: AppTextStyles.caption,
                ),
                const SizedBox(height: AppSpacing.l),
                // Hai nút hai bên chia đều phần còn lại, nên hàng không bị tràn
                // trên màn hình hẹp.
                Row(
                  children: [
                    Expanded(
                      child: Center(
                        child: IconLabelButton(
                          icon: inMyList ? Icons.check : Icons.add,
                          label: inMyList
                              ? AppStrings.addedToList
                              : AppStrings.myList,
                          onTap: onToggleMyList,
                        ),
                      ),
                    ),
                    FilledButton.icon(
                      onPressed: onPlay,
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.textPrimary,
                        foregroundColor: AppColors.textOnLight,
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.xxxl,
                          vertical: AppSpacing.md,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppRadius.s),
                        ),
                      ),
                      icon: const Icon(Icons.play_arrow, size: AppSizes.iconL),
                      label: Text(
                        AppPlayback.labelFor(movie),
                        style: AppTextStyles.button,
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: IconLabelButton(
                          icon: Icons.info_outline,
                          label: AppStrings.info,
                          onTap: onInfo,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
