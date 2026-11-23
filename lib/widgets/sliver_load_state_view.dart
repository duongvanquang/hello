import 'package:material_ui/material_ui.dart';

import '../blocs/load_status.dart';
import 'empty_view.dart';
import 'error_view.dart';

/// Hiển thị đúng phần theo trạng thái tải (dạng sliver, đặt trong CustomScrollView):
/// đang tải → [skeleton] (khung shimmer); lỗi → thông báo + Thử lại; trống → [emptyMessage];
/// có dữ liệu → [builder].
class SliverLoadStateView extends StatelessWidget {
  const SliverLoadStateView({
    super.key,
    required this.status,
    required this.isEmpty,
    required this.emptyIcon,
    required this.emptyMessage,
    required this.builder,
    required this.skeleton,
    this.errorMessage,
    this.onRetry,
  });

  final LoadStatus status;
  final bool isEmpty;
  final IconData emptyIcon;
  final String emptyMessage;
  final WidgetBuilder builder;

  /// Khung giả (sliver) hiện trong lúc đang tải.
  final Widget skeleton;
  final String? errorMessage;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    if (status.isLoading) return skeleton;
    final Widget? fill = switch (status) {
      LoadStatus.initial || LoadStatus.loading => null,
      LoadStatus.failure => ErrorView(
        message: errorMessage ?? '',
        onRetry: onRetry ?? () {},
      ),
      LoadStatus.success when isEmpty => EmptyView(
        icon: emptyIcon,
        message: emptyMessage,
      ),
      LoadStatus.success => null,
    };
    if (fill == null) return builder(context);
    return SliverFillRemaining(hasScrollBody: false, child: fill);
  }
}
