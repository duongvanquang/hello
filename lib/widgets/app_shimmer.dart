import 'package:material_ui/material_ui.dart';
import 'package:shimmer/shimmer.dart';

import '../common/app_colors.dart';
import '../common/app_durations.dart';

/// Phủ hiệu ứng shimmer (vệt sáng chạy qua) lên [child].
/// [child] thường là các [ShimmerBox] xếp giống bố cục thật.
class AppShimmer extends StatelessWidget {
  const AppShimmer({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.shimmerBase,
      highlightColor: AppColors.shimmerHighlight,
      period: AppDurations.shimmer,
      child: child,
    );
  }
}
