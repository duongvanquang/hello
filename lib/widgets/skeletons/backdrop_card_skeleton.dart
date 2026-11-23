import 'package:material_ui/material_ui.dart';

import '../../common/app_radius.dart';
import '../../common/app_sizes.dart';
import '../../common/app_spacing.dart';
import '../shimmer_box.dart';
import 'text_lines_skeleton.dart';

/// Thẻ giả: ảnh ngang + tiêu đề + vài dòng chữ (giống [ComingSoonTile]),
/// dùng trong [AppShimmer] ở tab Sắp chiếu và trang trailer.
class BackdropCardSkeleton extends StatelessWidget {
  const BackdropCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.l,
        AppSpacing.md,
        AppSpacing.l,
        AppSpacing.xl,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AspectRatio(
            aspectRatio: AppSizes.backdropAspectRatio,
            child: ShimmerBox(radius: AppRadius.md),
          ),
          const SizedBox(height: AppSpacing.md),
          FractionallySizedBox(
            widthFactor: AppSizes.skeletonTitleRatio,
            child: const ShimmerBox(
              height: AppSizes.skeletonTitle,
              radius: AppRadius.xs,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          const TextLinesSkeleton(),
        ],
      ),
    );
  }
}
