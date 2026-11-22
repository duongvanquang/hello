import 'package:material_ui/material_ui.dart';

import 'common/app_colors.dart';
import 'pages/my_home_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: AppColors.scheme,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}
