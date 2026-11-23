import 'watch_provider_kind.dart';

/// Một nơi xem phim hợp pháp (rạp hoặc dịch vụ online).
/// [searchUrl] là trang tìm kiếm của dịch vụ, chỗ `{query}` được thay bằng tên phim.
class WatchProvider {
  const WatchProvider({
    required this.name,
    required this.kind,
    required this.searchUrl,
  });

  static const String queryPlaceholder = '{query}';

  final String name;
  final WatchProviderKind kind;
  final String searchUrl;

  /// Link tìm [title] trên dịch vụ này.
  Uri searchUriFor(String title) => Uri.parse(
    searchUrl.replaceFirst(queryPlaceholder, Uri.encodeQueryComponent(title)),
  );
}
