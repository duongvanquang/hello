import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';

import '../blocs/my_list/my_list_cubit.dart';
import '../blocs/user_ratings/user_ratings_cubit.dart';
import '../common/app_share.dart';
import '../common/app_strings.dart';
import '../models/movie.dart';
import 'icon_label_button.dart';
import 'rating_sheet.dart';

/// Hàng nút dưới mô tả phim: Danh sách / Đánh giá / Chia sẻ.
/// Tự cập nhật theo [MyListCubit] và [UserRatingsCubit].
class MovieActionRow extends StatelessWidget {
  const MovieActionRow({super.key, required this.movie});

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    final myList = context.watch<MyListCubit>();
    final stars = context.watch<UserRatingsCubit>().starsOf(movie);
    final saved = myList.contains(movie);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        IconLabelButton(
          icon: saved ? Icons.check : Icons.add,
          label: saved ? AppStrings.addedToList : AppStrings.myList,
          highlighted: saved,
          onTap: () => myList.toggle(movie),
        ),
        IconLabelButton(
          icon: stars == null ? Icons.star_border_rounded : Icons.star_rounded,
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
  }
}
