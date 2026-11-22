import 'package:material_ui/material_ui.dart';

import '../common/app_colors.dart';
import '../common/app_strings.dart';
import '../models/genre.dart';
import '../repositories/movie_repository.dart';
import 'error_view.dart';
import 'loading_view.dart';
import '../common/app_text_styles.dart';
import '../common/app_spacing.dart';
import '../common/app_radius.dart';
import '../common/app_sizes.dart';

/// Bảng chọn thể loại trượt từ dưới lên. Danh sách thể loại lấy từ TMDB.
/// Trả về thể loại được chọn, hoặc null nếu đóng bảng.
class GenrePickerSheet extends StatefulWidget {
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
      builder: (_) => GenrePickerSheet(selected: selected),
    );
  }

  @override
  State<GenrePickerSheet> createState() => _GenrePickerSheetState();
}

class _GenrePickerSheetState extends State<GenrePickerSheet> {
  late Future<List<Genre>> _genres = MovieRepository.instance.loadGenres();

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
              child: FutureBuilder<List<Genre>>(
                future: _genres,
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return const LoadingView();
                  }
                  if (snapshot.hasError) {
                    return ErrorView(
                      message: '${snapshot.error}',
                      onRetry: () => setState(
                        () => _genres = MovieRepository.instance.loadGenres(),
                      ),
                    );
                  }
                  final genres = snapshot.requireData;
                  return ListView.builder(
                    itemCount: genres.length,
                    itemBuilder: (context, i) {
                      final genre = genres[i];
                      final selected = genre.id == widget.selected?.id;
                      return ListTile(
                        title: Text(
                          genre.name,
                          style: AppTextStyles.primary.copyWith(
                            color: selected
                                ? AppColors.primary
                                : AppColors.textPrimary,
                            fontWeight: selected
                                ? FontWeight.w700
                                : FontWeight.w400,
                          ),
                        ),
                        trailing: selected
                            ? const Icon(Icons.check, color: AppColors.primary)
                            : null,
                        onTap: () => Navigator.of(context).pop(genre),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
