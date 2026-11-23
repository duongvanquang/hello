import 'package:material_ui/material_ui.dart';

import '../common/app_colors.dart';
import '../models/movie.dart';
import 'app_shimmer.dart';
import 'broken_image.dart';
import 'rating_badge.dart';
import 'shimmer_box.dart';
import '../common/app_radius.dart';
import '../common/app_opacity.dart';
import '../common/app_durations.dart';
import '../common/app_spacing.dart';

/// Ảnh của phim tải từ TMDB. Đang tải thì hiện nền tối, lỗi thì hiện biểu tượng.
/// [useBackdrop] = true dùng ảnh ngang (trang chi tiết), mặc định dùng poster dọc.
class MovieArtwork extends StatelessWidget {
  const MovieArtwork({
    super.key,
    required this.movie,
    this.borderRadius = AppRadius.none,
    this.useBackdrop = false,
    this.showRating = false,
  });

  final Movie movie;
  final double borderRadius;
  final bool useBackdrop;
  final bool showRating;

  @override
  Widget build(BuildContext context) {
    final url = useBackdrop ? movie.backdropUrl : movie.posterUrl;

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Stack(
        fit: StackFit.expand,
        children: [
          const ColoredBox(color: AppColors.surface),
          if (url != null)
            Image.network(
              url,
              fit: BoxFit.cover,
              gaplessPlayback: true,
              frameBuilder: (context, child, frame, loadedSync) {
                final loaded = loadedSync || frame != null;
                return Stack(
                  fit: StackFit.expand,
                  children: [
                    // Ảnh chưa tải xong thì hiện shimmer bên dưới.
                    if (!loaded)
                      const AppShimmer(
                        child: ShimmerBox(radius: AppRadius.none),
                      ),
                    AnimatedOpacity(
                      opacity: loaded ? AppOpacity.visible : AppOpacity.hidden,
                      duration: AppDurations.imageFade,
                      child: child,
                    ),
                  ],
                );
              },
              errorBuilder: (_, _, _) => const BrokenImage(),
            )
          else
            const BrokenImage(),
          if (showRating)
            Positioned(
              top: AppSpacing.s,
              right: AppSpacing.s,
              child: RatingBadge(rating: movie.rating),
            ),
        ],
      ),
    );
  }
}
