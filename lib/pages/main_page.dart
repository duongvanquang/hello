import 'package:material_ui/material_ui.dart';

import '../common/app_colors.dart';
import '../common/app_strings.dart';
import 'coming_soon_page.dart';
import 'home_page.dart';
import 'my_list_page.dart';
import 'search_page.dart';
import '../common/app_sizes.dart';
import '../models/main_tab.dart';

/// Khung chính của app: thanh tab dưới và 4 tab.
/// Muốn thêm tab: thêm 1 trang vào [_pages] và 1 nút vào [_destinations].
class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _tabIndex = MainTab.home.index;

  late final List<Widget> _pages = [
    HomePage(onSearch: () => _selectTab(MainTab.search.index)),
    const SearchPage(),
    const ComingSoonPage(),
    const MyListPage(),
  ];

  static const _destinations = [
    NavigationDestination(
      icon: Icon(Icons.home_outlined),
      selectedIcon: Icon(Icons.home, color: AppColors.primary),
      label: AppStrings.tabHome,
    ),
    NavigationDestination(
      icon: Icon(Icons.search),
      selectedIcon: Icon(Icons.search, color: AppColors.primary),
      label: AppStrings.tabSearch,
    ),
    NavigationDestination(
      icon: Icon(Icons.video_library_outlined),
      selectedIcon: Icon(Icons.video_library, color: AppColors.primary),
      label: AppStrings.tabComingSoon,
    ),
    NavigationDestination(
      icon: Icon(Icons.bookmark_border),
      selectedIcon: Icon(Icons.bookmark, color: AppColors.primary),
      label: AppStrings.myList,
    ),
  ];

  void _selectTab(int index) => setState(() => _tabIndex = index);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: IndexedStack(index: _tabIndex, children: _pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tabIndex,
        onDestinationSelected: _selectTab,
        backgroundColor: AppColors.surface,
        indicatorColor: AppColors.navIndicator,
        height: AppSizes.navBarHeight,
        destinations: _destinations,
      ),
    );
  }
}
