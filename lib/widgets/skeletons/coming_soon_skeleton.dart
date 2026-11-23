import 'package:material_ui/material_ui.dart';

import '../../common/app_limits.dart';
import '../app_shimmer.dart';
import 'backdrop_card_skeleton.dart';

/// Danh sách Sắp chiếu giả khi đang tải (dạng sliver).
class ComingSoonSkeleton extends StatelessWidget {
  const ComingSoonSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: AppShimmer(
        child: Column(
          children: List.generate(
            AppLimits.skeletonListItems,
            (_) => const BackdropCardSkeleton(),
          ),
        ),
      ),
    );
  }
}
