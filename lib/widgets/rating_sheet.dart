import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';

import '../blocs/rate_movie/rate_movie_cubit.dart';
import '../blocs/rate_movie/rate_movie_state.dart';
import '../common/app_colors.dart';
import '../common/app_messages.dart';
import '../common/app_radius.dart';
import '../common/app_spacing.dart';
import '../common/app_strings.dart';
import '../common/app_text_styles.dart';
import '../models/movie.dart';
import 'primary_button.dart';
import 'star_rating_bar.dart';

/// Bảng chấm sao trượt từ dưới lên ([RateMovieCubit]).
/// Gửi xong thì đóng bảng và cảm ơn người dùng.
class RatingSheet extends StatelessWidget {
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
      builder: (_) => BlocProvider(
        create: (ctx) => RateMovieCubit(ctx.read(), ctx.read(), movie),
        child: RatingSheet(movie: movie),
      ),
    );
  }

  void _onStateChanged(BuildContext context, RateMovieState state) {
    if (state.status.isSuccess) {
      final messenger = ScaffoldMessenger.of(context);
      Navigator.of(context).pop();
      messenger.showSnackBar(
        const SnackBar(
          content: Text(AppStrings.rateThanks, style: AppTextStyles.primary),
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.surface,
        ),
      );
      return;
    }
    final error = state.errorMessage;
    if (error != null) AppMessages.show(context, error);
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<RateMovieCubit>();
    return BlocConsumer<RateMovieCubit, RateMovieState>(
      listener: _onStateChanged,
      builder: (context, state) => SafeArea(
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
                movie.title,
                style: AppTextStyles.title,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xs),
              const Text(AppStrings.rateTitle, style: AppTextStyles.secondary),
              const SizedBox(height: AppSpacing.l),
              StarRatingBar(value: state.stars, onChanged: cubit.selectStars),
              const SizedBox(height: AppSpacing.xl),
              PrimaryButton(
                label: AppStrings.rateSubmit,
                loading: state.isSending,
                onPressed: cubit.submit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
