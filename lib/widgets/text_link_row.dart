import 'package:material_ui/material_ui.dart';

import '../common/app_text_styles.dart';

/// Dòng chữ kèm liên kết, ví dụ "Chưa có tài khoản? Đăng ký".
class TextLinkRow extends StatelessWidget {
  const TextLinkRow({
    super.key,
    required this.text,
    required this.linkText,
    required this.onTap,
  });

  final String text;
  final String linkText;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(text, style: AppTextStyles.secondary),
        TextButton(
          onPressed: onTap,
          child: Text(linkText, style: AppTextStyles.link),
        ),
      ],
    );
  }
}
