import 'package:material_ui/material_ui.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import '../common/app_colors.dart';
import '../common/app_limits.dart';
import '../common/app_sizes.dart';
import '../common/app_spacing.dart';
import '../common/app_strings.dart';
import '../common/app_text_styles.dart';
import '../models/movie.dart';
import '../models/video.dart';
import '../repositories/movie_repository.dart';
import '../widgets/empty_view.dart';
import '../widgets/error_view.dart';
import '../widgets/loading_view.dart';

/// Trang phát trailer của phim (video YouTube lấy từ TMDB), tự phát khi mở.
class TrailerPage extends StatefulWidget {
  const TrailerPage({super.key, required this.movie});

  final Movie movie;

  static Future<void> open(BuildContext context, Movie movie) {
    return Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => TrailerPage(movie: movie)));
  }

  @override
  State<TrailerPage> createState() => _TrailerPageState();
}

class _TrailerPageState extends State<TrailerPage> {
  late Future<Video?> _trailer = MovieRepository.instance.loadTrailer(
    widget.movie,
  );
  YoutubePlayerController? _controller;

  @override
  void dispose() {
    _controller?.close();
    super.dispose();
  }

  void _retry() => setState(
    () => _trailer = MovieRepository.instance.loadTrailer(widget.movie),
  );

  /// Tạo trình phát một lần cho video, tự phát ngay.
  YoutubePlayerController _controllerFor(Video video) {
    return _controller ??= YoutubePlayerController.fromVideoId(
      videoId: video.key,
      autoPlay: true,
      params: const YoutubePlayerParams(
        showFullscreenButton: true,
        strictRelatedVideos: true,
        playsInline: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.transparent,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        title: Text(
          widget.movie.title,
          style: AppTextStyles.title,
          maxLines: AppLimits.singleLine,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: FutureBuilder<Video?>(
        future: _trailer,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const LoadingView();
          }
          if (snapshot.hasError) {
            return ErrorView(message: '${snapshot.error}', onRetry: _retry);
          }
          final video = snapshot.data;
          if (video == null) {
            return const EmptyView(
              icon: Icons.videocam_off_outlined,
              message: AppStrings.noTrailer,
            );
          }
          return ListView(
            children: [
              YoutubePlayer(
                controller: _controllerFor(video),
                aspectRatio: AppSizes.backdropAspectRatio,
                backgroundColor: AppColors.textOnLight,
              ),
              Padding(
                padding: const EdgeInsets.all(AppSpacing.screen),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(video.name, style: AppTextStyles.title),
                    const SizedBox(height: AppSpacing.sm),
                    if (widget.movie.description.isNotEmpty)
                      Text(widget.movie.description, style: AppTextStyles.body),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
