import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';

import '../blocs/genres/genres_cubit.dart';
import '../blocs/genres/genres_state.dart';
import '../common/app_colors.dart';
import '../common/app_radius.dart';
import '../common/app_sizes.dart';
import '../common/app_spacing.dart';
import '../common/app_strings.dart';
import '../common/app_text_styles.dart';
import '../models/genre.dart';
import 'error_view.dart';
import 'loading_view.dart';

/// Bảng chọn thể loại trượt từ dưới lên, danh sách lấy bằng [GenresCubit].
/// Trả về thể loại được chọn, hoặc null nếu đóng bảng.
class GenrePickerSheet extends StatelessWidget {
  const GenrePickerSheet({super.key, this.selected});

  final Genre? selected;

  static Future<Genre?> show(BuildContext context, {Genre? selected}) {
    return showModalBottomSheet<Genre>(
      context: context,
      backgroundColor: AppColors.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppRadius.sheet),
        ),
      ),
      builder: (_) => BlocProvider(
        create: (ctx) => GenresCubit(ctx.read())..load(),
        child: GenrePickerSheet(selected: selected),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        height: MediaQuery.sizeOf(context).height * AppSizes.sheetHeightRatio,
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(
                AppSpacing.xl,
                AppSpacing.xl,
                AppSpacing.xl,
                AppSpacing.sm,
              ),
              child: Text(AppStrings.chooseGenre, style: AppTextStyles.title),
            ),
            Expanded(
              child: BlocBuilder<GenresCubit, GenresState>(
                builder: (context, state) {
                  if (state.status.isLoading) return const LoadingView();
                  if (state.status.isFailure) {
                    return ErrorView(
                      message: state.errorMessage ?? '',
                      onRetry: context.read<GenresCubit>().load,
                    );
                  }
                  return ListView.builder(
                    itemCount: state.genres.length,
                    itemBuilder: (context, i) =>
                        _genreTile(context, state.genres[i]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _genreTile(BuildContext context, Genre genre) {
    final isSelected = genre.id == selected?.id;
    return ListTile(
      title: Text(
        genre.name,
        style: isSelected ? AppTextStyles.link : AppTextStyles.primary,
      ),
      trailing: isSelected
          ? const Icon(Icons.check, color: AppColors.primary)
          : null,
      onTap: () => Navigator.of(context).pop(genre),
    );
  }
}
