import 'package:material_ui/material_ui.dart';

import '../common/app_colors.dart';
import '../common/app_playback.dart';
import '../common/app_radius.dart';
import '../common/app_spacing.dart';
import '../common/app_strings.dart';
import '../common/app_text_styles.dart';
import '../common/app_watch_providers.dart';
import '../models/movie.dart';
import '../models/watch_provider.dart';
import '../models/watch_provider_kind.dart';
import 'notice_banner.dart';

/// Bảng "Xem phim ở đâu": xem trailer ngay, hoặc mở trang tìm phim trên
/// rạp / dịch vụ xem phim hợp pháp ([AppWatchProviders]).
class WhereToWatchSheet extends StatelessWidget {
  const WhereToWatchSheet({super.key, required this.movie});

  final Movie movie;

  static Future<void> show(BuildContext context, Movie movie) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppRadius.sheet),
        ),
      ),
      builder: (_) => WhereToWatchSheet(movie: movie),
    );
  }

  /// Đóng bảng trước rồi mới mở trang, dùng context của trang bên dưới.
  void _choose(BuildContext context, Future<void> Function(BuildContext) go) {
    final pageContext = Navigator.of(context).context;
    Navigator.of(context).pop();
    go(pageContext);
  }

  Widget _providerTile(BuildContext context, WatchProvider provider) {
    final isCinema = provider.kind == WatchProviderKind.cinema;
    return ListTile(
      leading: Icon(
        isCinema ? Icons.local_movies_outlined : Icons.live_tv_outlined,
        color: AppColors.textPrimary,
      ),
      title: Text(provider.name, style: AppTextStyles.bodyStrong),
      subtitle: Text(
        isCinema ? AppStrings.cinemaShowtimes : AppStrings.streamingService,
        style: AppTextStyles.label,
      ),
      trailing: const Icon(Icons.open_in_new, color: AppColors.textSecondary),
      onTap: () => _choose(
        context,
        (ctx) => AppPlayback.openLink(ctx, provider.searchUriFor(movie.title)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.l),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.l),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    AppStrings.whereToWatch,
                    style: AppTextStyles.title,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(movie.title, style: AppTextStyles.bodySecondary),
                  const SizedBox(height: AppSpacing.md),
                  const NoticeBanner(message: AppStrings.whereToWatchNote),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            ListTile(
              leading: const Icon(
                Icons.play_circle_outline,
                color: AppColors.primary,
              ),
              title: const Text(
                AppStrings.watchTrailer,
                style: AppTextStyles.bodyStrong,
              ),
              onTap: () => _choose(
                context,
                (ctx) => AppPlayback.openTrailer(ctx, movie),
              ),
            ),
            for (final provider in AppWatchProviders.all)
              _providerTile(context, provider),
          ],
        ),
      ),
    );
  }
}
