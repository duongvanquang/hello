import 'package:material_ui/material_ui.dart';

import '../../common/app_limits.dart';
import '../../common/app_radius.dart';
import '../../common/app_sizes.dart';
import '../../common/app_spacing.dart';
import '../app_shimmer.dart';
import '../shimmer_box.dart';
import 'poster_row_skeleton.dart';

/// Trang chủ giả khi đang tải (dạng sliver): banner + nút + các hàng poster.
class HomeSkeleton extends StatelessWidget {
  const HomeSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: AppShimmer(
        child: Column(
          children: [
            const ShimmerBox(
              height: AppSizes.bannerHeight,
              radius: AppRadius.none,
            ),
            const SizedBox(height: AppSpacing.l),
            FractionallySizedBox(
              widthFactor: AppSizes.skeletonButtonRatio,
              child: const ShimmerBox(
                height: AppSizes.buttonHeightSmall,
                radius: AppRadius.s,
              ),
            ),
            ...List.generate(
              AppLimits.skeletonRows,
              (_) => const PosterRowSkeleton(),
            ),
          ],
        ),
      ),
    );
  }
}
