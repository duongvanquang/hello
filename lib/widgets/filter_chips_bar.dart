import 'package:material_ui/material_ui.dart';

import '../common/app_colors.dart';
import '../common/app_text_styles.dart';
import '../common/app_spacing.dart';
import '../common/app_radius.dart';
import '../common/app_sizes.dart';
import '../common/app_durations.dart';

/// Hàng chip lọc cuộn ngang (Phim bộ, Phim lẻ, ...).
/// Chip ở vị trí [selectedIndex] được tô màu nhấn; bấm chip gọi [onSelected].
class FilterChipsBar extends StatelessWidget {
  const FilterChipsBar({
    super.key,
    required this.labels,
    this.selectedIndex,
    this.onSelected,
  });

  static const double height = AppSizes.chipBarHeight;

  final List<String> labels;
  final int? selectedIndex;
  final ValueChanged<int>? onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.l,
          AppSpacing.xs,
          AppSpacing.l,
          AppSpacing.sm,
        ),
        itemCount: labels.length,
        separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.sm),
        itemBuilder: (context, i) {
          final selected = i == selectedIndex;
          return InkWell(
            onTap: onSelected == null ? null : () => onSelected!(i),
            borderRadius: BorderRadius.circular(AppRadius.chip),
            child: AnimatedContainer(
              duration: AppDurations.fast,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.ml),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: selected ? AppColors.primary : Colors.transparent,
                border: Border.all(
                  color: selected ? AppColors.primary : AppColors.border,
                ),
                borderRadius: BorderRadius.circular(AppRadius.chip),
              ),
              child: Text(
                labels[i],
                style: AppTextStyles.small.copyWith(
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
