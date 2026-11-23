import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/movie.dart';
import '../pages/trailer_page.dart';
import '../repositories/movie_source_repository.dart';
import '../widgets/where_to_watch_sheet.dart';
import 'app_messages.dart';
import 'app_strings.dart';

/// Quyết định nút Phát làm gì, dùng chung cho banner và trang chi tiết:
/// - Phim chưa chiếu → "Xem trailer".
/// - Phim đã ra → "Xem phim": có nguồn riêng ([MovieSourceRepository]) thì mở
///   phim đầy đủ; chưa có thì mở bảng "Xem phim ở đâu" (rạp, dịch vụ hợp pháp).
class AppPlayback {
  AppPlayback._();

  static String labelFor(Movie movie) =>
      movie.isUpcoming ? AppStrings.watchTrailer : AppStrings.watchMovie;

  static Future<void> play(BuildContext context, Movie movie) async {
    if (movie.isUpcoming) return openTrailer(context, movie);

    final source = await context.read<MovieSourceRepository>().findFullMovie(
      movie,
    );
    if (!context.mounted) return;
    if (source == null) return WhereToWatchSheet.show(context, movie);
    return openLink(context, source);
  }

  static Future<void> openTrailer(BuildContext context, Movie movie) =>
      TrailerPage.open(context, movie);

  /// Mở link bên ngoài (ưu tiên app của dịch vụ nếu máy đã cài).
  static Future<void> openLink(BuildContext context, Uri uri) async {
    final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!opened && context.mounted) {
      AppMessages.show(context, AppStrings.cannotOpenLink);
    }
  }
}
