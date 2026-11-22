import 'package:material_ui/material_ui.dart';

import '../common/app_colors.dart';
import '../common/app_messages.dart';
import '../common/app_radius.dart';
import '../common/app_spacing.dart';
import '../common/app_strings.dart';
import '../common/app_text_styles.dart';
import '../data/user_ratings.dart';
import '../models/movie.dart';
import '../repositories/movie_repository.dart';
import '../services/api_exception.dart';
import 'primary_button.dart';
import 'star_rating_bar.dart';

/// Bảng chấm sao trượt từ dưới lên. Gửi điểm lên TMDB rồi lưu lại để nút
/// "Đánh giá" hiện số sao đã chấm.
class RatingSheet extends StatefulWidget {
  const RatingSheet({super.key, required this.movie});

  final Movie movie;

  static Future<void> show(BuildContext context, Movie movie) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppRadius.sheet),
        ),
      ),
      builder: (_) => RatingSheet(movie: movie),
    );
  }

  @override
  State<RatingSheet> createState() => _RatingSheetState();
}

class _RatingSheetState extends State<RatingSheet> {
  late int? _stars = UserRatings.of(widget.movie);
  bool _sending = false;

  Future<void> _submit() async {
    final stars = _stars;
    if (stars == null) {
      AppMessages.show(context, AppStrings.rateChooseStars);
      return;
    }
    setState(() => _sending = true);
    // Lấy trước khi đóng bảng, vì sau đó context của bảng không còn dùng được.
    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);
    try {
      await MovieRepository.instance.rate(widget.movie, stars);
      UserRatings.set(widget.movie, stars);
      navigator.pop();
      messenger.showSnackBar(
        const SnackBar(
          content: Text(AppStrings.rateThanks, style: AppTextStyles.primary),
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.surface,
        ),
      );
    } on ApiException catch (e) {
      if (mounted) AppMessages.show(context, e.message);
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.xl,
          AppSpacing.xxl,
          AppSpacing.xl,
          AppSpacing.l,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.movie.title,
              style: AppTextStyles.title,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xs),
            const Text(AppStrings.rateTitle, style: AppTextStyles.secondary),
            const SizedBox(height: AppSpacing.l),
            StarRatingBar(
              value: _stars,
              onChanged: (value) => setState(() => _stars = value),
            ),
            const SizedBox(height: AppSpacing.xl),
            PrimaryButton(
              label: AppStrings.rateSubmit,
              loading: _sending,
              onPressed: _submit,
            ),
          ],
        ),
      ),
    );
  }
}
