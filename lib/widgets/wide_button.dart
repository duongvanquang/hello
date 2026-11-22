import 'package:material_ui/material_ui.dart';

import '../common/app_text_styles.dart';
import '../common/app_radius.dart';
import '../common/app_sizes.dart';

/// Nút rộng hết chiều ngang, có biểu tượng (Phát, Tải xuống...).
class WideButton extends StatelessWidget {
  const WideButton({
    super.key,
    required this.icon,
    required this.label,
    required this.background,
    required this.foreground,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color background;
  final Color foreground;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: AppSizes.buttonHeightSmall,
      child: FilledButton.icon(
        onPressed: onTap,
        style: FilledButton.styleFrom(
          backgroundColor: background,
          foregroundColor: foreground,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.s),
          ),
        ),
        icon: Icon(icon, size: AppSizes.iconM),
        label: Text(label, style: AppTextStyles.button),
      ),
    );
  }
}
