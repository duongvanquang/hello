import 'package:material_ui/material_ui.dart';

import '../common/app_colors.dart';
import '../common/app_strings.dart';
import 'account_sheet.dart';
import 'filter_chips_bar.dart';
import 'user_avatar.dart';
import '../common/app_text_styles.dart';
import '../common/app_spacing.dart';

/// Thanh trên cùng của trang chủ: tên app, nút tìm kiếm, ảnh đại diện,
/// và hàng chip lọc bên dưới. Ẩn khi kéo xuống, hiện lại khi kéo lên.
/// Đây là một sliver, nên đặt trong CustomScrollView.
class HomeAppBar extends StatelessWidget {
  const HomeAppBar({
    super.key,
    required this.filterLabels,
    required this.selectedFilter,
    required this.onFilterSelected,
    this.onSearch,
  });

  final List<String> filterLabels;
  final int? selectedFilter;
  final ValueChanged<int> onFilterSelected;
  final VoidCallback? onSearch;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      floating: true,
      snap: true,
      backgroundColor: AppColors.barBackground,
      surfaceTintColor: Colors.transparent,
      titleSpacing: AppSpacing.l,
      title: const Text(AppStrings.appName, style: AppTextStyles.brand),
      actions: [
        IconButton(
          onPressed: onSearch,
          icon: const Icon(Icons.search, color: AppColors.textPrimary),
        ),
        Padding(
          padding: const EdgeInsets.only(
            right: AppSpacing.l,
            left: AppSpacing.xs,
          ),
          child: GestureDetector(
            onTap: () => AccountSheet.show(context),
            child: const UserAvatar(),
          ),
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(FilterChipsBar.height),
        child: FilterChipsBar(
          labels: filterLabels,
          selectedIndex: selectedFilter,
          onSelected: onFilterSelected,
        ),
      ),
    );
  }
}
