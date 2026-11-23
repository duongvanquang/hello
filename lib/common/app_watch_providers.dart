import '../models/watch_provider.dart';
import '../models/watch_provider_kind.dart';

/// Các nơi xem phim hợp pháp hiện trong bảng "Xem phim ở đâu".
/// Thêm / bớt dịch vụ: sửa danh sách này. Đã kiểm tra các link tìm kiếm.
class AppWatchProviders {
  AppWatchProviders._();

  static const List<WatchProvider> all = [
    WatchProvider(
      name: 'Moveek',
      kind: WatchProviderKind.cinema,
      searchUrl: 'https://moveek.com/tim-kiem/?s={query}',
    ),
    WatchProvider(
      name: 'Netflix',
      kind: WatchProviderKind.streaming,
      searchUrl: 'https://www.netflix.com/search?q={query}',
    ),
    WatchProvider(
      name: 'Galaxy Play',
      kind: WatchProviderKind.streaming,
      searchUrl: 'https://galaxyplay.vn/search?keyword={query}',
    ),
    WatchProvider(
      name: 'FPT Play',
      kind: WatchProviderKind.streaming,
      searchUrl: 'https://fptplay.vn/tim-kiem?keyword={query}',
    ),
    WatchProvider(
      name: 'VieON',
      kind: WatchProviderKind.streaming,
      searchUrl: 'https://vieon.vn/tim-kiem/?q={query}',
    ),
    WatchProvider(
      name: 'TV360',
      kind: WatchProviderKind.streaming,
      searchUrl: 'https://tv360.vn/search?keyword={query}',
    ),
  ];
}
