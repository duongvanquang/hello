import 'package:material_ui/material_ui.dart';

import '../common/app_share.dart';
import '../common/app_strings.dart';
import '../data/my_list.dart';
import '../data/user_ratings.dart';
import '../models/movie.dart';
import 'icon_label_button.dart';
import 'rating_sheet.dart';

/// Hàng nút dưới mô tả phim: Danh sách / Đánh giá / Chia sẻ.
/// Tự cập nhật khi phim được thêm vào danh sách hoặc được chấm sao.
class MovieActionRow extends StatelessWidget {
  const MovieActionRow({super.key, required this.movie});

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([MyList.movies, UserRatings.stars]),
      builder: (context, _) {
        final saved = MyList.contains(movie);
        final stars = UserRatings.of(movie);
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconLabelButton(
              icon: saved ? Icons.check : Icons.add,
              label: saved ? AppStrings.addedToList : AppStrings.myList,
              highlighted: saved,
              onTap: () => MyList.toggle(movie),
            ),
            IconLabelButton(
              icon: stars == null
                  ? Icons.star_border_rounded
                  : Icons.star_rounded,
              label: stars == null ? AppStrings.rate : AppStrings.rated(stars),
              highlighted: stars != null,
              onTap: () => RatingSheet.show(context, movie),
            ),
            // Builder để lấy đúng vị trí nút (bảng chia sẻ trên iPad gắn vào nút).
            Builder(
              builder: (buttonContext) => IconLabelButton(
                icon: Icons.ios_share,
                label: AppStrings.share,
                onTap: () => AppShare.movie(buttonContext, movie),
              ),
            ),
          ],
        );
      },
    );
  }
}
