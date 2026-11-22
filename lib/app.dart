import 'package:material_ui/material_ui.dart';

import 'common/app_colors.dart';
import 'common/app_strings.dart';
import 'common/app_text_styles.dart';
import 'pages/auth_gate.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData(
        colorScheme: AppColors.scheme,
        scaffoldBackgroundColor: AppColors.background,
        fontFamily: AppTextStyles.fontFamily,
      ),
      theme: ThemeData(
        colorScheme: AppColors.scheme,
        scaffoldBackgroundColor: AppColors.background,
        fontFamily: AppTextStyles.fontFamily,
      ),
      home: const AuthGate(),
    );
  }
}
