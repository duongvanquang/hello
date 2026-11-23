import 'package:material_ui/material_ui.dart';

import '../common/app_colors.dart';
import '../common/app_radius.dart';

/// Một khối xám bo góc, đặt trong [AppShimmer] để giả chỗ ảnh / chữ / nút.
/// Không truyền [width] / [height] thì lấp đầy chỗ trống.
class ShimmerBox extends StatelessWidget {
  const ShimmerBox({
    super.key,
    this.width,
    this.height,
    this.radius = AppRadius.sm,
  });

  final double? width;
  final double? height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.shimmerBase,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}
