import 'package:equatable/equatable.dart';

/// Sự kiện duy nhất của tìm kiếm: chữ trong ô tìm thay đổi (hoặc bấm Thử lại).
class SearchQueryChanged extends Equatable {
  const SearchQueryChanged(this.query, {this.retry = false});

  final String query;

  /// true khi bấm "Thử lại": tìm ngay, kể cả khi chữ không đổi.
  final bool retry;

  @override
  List<Object?> get props => [query, retry];
}
