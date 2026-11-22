import 'package:material_ui/material_ui.dart';

class AppColors {
  AppColors._();

  static const Color primary = Colors.deepPurple;
  static final ColorScheme scheme = ColorScheme.fromSeed(seedColor: primary);
  static final Color appBarBackground = scheme.inversePrimary;
}
