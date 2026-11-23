import 'package:material_ui/material_ui.dart';

import '../common/app_strings.dart';
import '../widgets/sliver_my_list_grid.dart';
import '../widgets/tab_title.dart';

/// Tab Danh sách của tôi: lưới các phim đã lưu.
class MyListPage extends StatelessWidget {
  const MyListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      bottom: false,
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: TabTitle(title: AppStrings.myListFull)),
          SliverMyListGrid(heroPrefix: 'mylist'),
        ],
      ),
    );
  }
}
