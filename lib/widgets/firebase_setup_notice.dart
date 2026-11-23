import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';

import '../common/app_spacing.dart';
import '../common/app_strings.dart';
import '../services/auth_service.dart';
import 'notice_banner.dart';

/// Cảnh báo khi app chưa kết nối Firebase. Đã kết nối thì không hiện gì.
class FirebaseSetupNotice extends StatelessWidget {
  const FirebaseSetupNotice({super.key});

  @override
  Widget build(BuildContext context) {
    if (context.read<AuthService>().isReady) return const SizedBox.shrink();
    return const NoticeBanner(
      message: AppStrings.firebaseNotConfigured,
      margin: EdgeInsets.only(bottom: AppSpacing.l),
    );
  }
}
