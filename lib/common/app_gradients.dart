import 'package:material_ui/material_ui.dart';

import 'app_colors.dart';

/// Các dải màu chuyển dùng chung.
class AppGradients {
  AppGradients._();

  static const LinearGradient bannerFade = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    stops: [0, 0.25, 0.6, 1],
    colors: [
      Color(0x99000000),
      Colors.transparent,
      Color(0x880E0E12),
      AppColors.background,
    ],
  );
}
