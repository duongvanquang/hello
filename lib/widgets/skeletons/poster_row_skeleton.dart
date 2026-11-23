import 'package:material_ui/material_ui.dart';

import '../../common/app_limits.dart';
import '../../common/app_radius.dart';
import '../../common/app_sizes.dart';
import '../../common/app_spacing.dart';
import '../shimmer_box.dart';

/// Một hàng phim giả: dòng tiêu đề + các poster nằm ngang (giống [MovieRow]).
class PosterRowSkeleton extends StatelessWidget {
  const PosterRowSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.l,
            AppSpacing.xl,
            AppSpacing.l,
            AppSpacing.m,
          ),
          child: FractionallySizedBox(
            widthFactor: AppSizes.skeletonTitleRatio,
            child: const ShimmerBox(
              height: AppSizes.skeletonTitle,
              radius: AppRadius.xs,
            ),
          ),
        ),
        SizedBox(
          height: AppSizes.posterRowHeight,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.l),
            itemCount: AppLimits.skeletonPostersPerRow,
            separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.m),
            itemBuilder: (_, _) => const AspectRatio(
              aspectRatio: AppSizes.posterAspectRatio,
              child: ShimmerBox(),
            ),
          ),
        ),
      ],
    );
  }
}
