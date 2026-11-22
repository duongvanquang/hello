import 'package:material_ui/material_ui.dart';

import 'common/app_colors.dart';
import 'common/app_strings.dart';
import 'pages/my_home_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppStrings.appName,
      theme: ThemeData(
        colorScheme: AppColors.scheme,
      ),
      home: const MyHomePage(title: AppStrings.appName),
    );
  }
}
