import 'package:material_ui/material_ui.dart';

import '../common/app_colors.dart';
import '../common/app_limits.dart';
import '../common/app_sizes.dart';

/// Hàng sao để chấm điểm (1 đến [AppLimits.maxStars]). Bấm sao thứ n = chấm n sao.
class StarRatingBar extends StatelessWidget {
  const StarRatingBar({
    super.key,
    required this.value,
    required this.onChanged,
  });

  /// Số sao đang chọn (null = chưa chọn).
  final int? value;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final selected = value;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var star = AppLimits.firstStar; star <= AppLimits.maxStars; star++)
          IconButton(
            key: ValueKey('star-$star'),
            iconSize: AppSizes.iconStar,
            onPressed: () => onChanged(star),
            icon: selected != null && star <= selected
                ? const Icon(Icons.star_rounded, color: AppColors.rating)
                : const Icon(
                    Icons.star_border_rounded,
                    color: AppColors.textSecondary,
                  ),
          ),
      ],
    );
  }
}
