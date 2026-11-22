import 'package:material_ui/material_ui.dart';
import 'package:share_plus/share_plus.dart';

import '../models/movie.dart';
import 'app_strings.dart';

/// Mở bảng chia sẻ của hệ điều hành (Tin nhắn, Zalo, Messenger, copy link...).
class AppShare {
  AppShare._();

  /// Chia sẻ tên phim + link trang phim trên TMDB.
  /// [context] dùng để định vị bảng chia sẻ trên iPad (gắn vào nút vừa bấm).
  static Future<void> movie(BuildContext context, Movie movie) {
    final box = context.findRenderObject() as RenderBox?;
    return SharePlus.instance.share(
      ShareParams(
        text: AppStrings.shareMovie(movie.title, movie.year, movie.webUrl),
        subject: movie.title,
        sharePositionOrigin: box == null
            ? null
            : box.localToGlobal(Offset.zero) & box.size,
      ),
    );
  }
}
