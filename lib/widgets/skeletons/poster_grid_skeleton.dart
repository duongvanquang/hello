import 'package:material_ui/material_ui.dart';

import '../../common/app_limits.dart';
import '../../common/app_sizes.dart';
import '../../common/app_spacing.dart';
import '../app_shimmer.dart';
import '../shimmer_box.dart';

/// Lưới poster giả khi đang tải (dạng sliver, giống [SliverMovieGrid]).
class PosterGridSkeleton extends StatelessWidget {
  const PosterGridSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.l,
        AppSpacing.sm,
        AppSpacing.l,
        AppSpacing.huge,
      ),
      sliver: SliverToBoxAdapter(
        child: AppShimmer(
          child: GridView.count(
            crossAxisCount: AppLimits.gridColumns,
            mainAxisSpacing: AppSpacing.m,
            crossAxisSpacing: AppSpacing.m,
            childAspectRatio: AppSizes.posterAspectRatio,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            children: List.generate(
              AppLimits.skeletonGridItems,
              (_) => const ShimmerBox(),
            ),
          ),
        ),
      ),
    );
  }
}
