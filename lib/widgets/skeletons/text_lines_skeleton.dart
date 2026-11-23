import 'package:material_ui/material_ui.dart';

import '../../common/app_limits.dart';
import '../../common/app_radius.dart';
import '../../common/app_sizes.dart';
import '../../common/app_spacing.dart';
import '../shimmer_box.dart';

/// Vài dòng chữ giả (dòng cuối ngắn hơn), dùng trong [AppShimmer].
class TextLinesSkeleton extends StatelessWidget {
  const TextLinesSkeleton({
    super.key,
    this.lines = AppLimits.skeletonTextLines,
  });

  final int lines;

  @override
  Widget build(BuildContext context) {
    final widths = List.filled(lines, AppSizes.skeletonFullRatio)
      ..last = AppSizes.skeletonTitleRatio;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final width in widths) ...[
          FractionallySizedBox(
            widthFactor: width,
            child: const ShimmerBox(
              height: AppSizes.skeletonLine,
              radius: AppRadius.xs,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
        ],
      ],
    );
  }
}
