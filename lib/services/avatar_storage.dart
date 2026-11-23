import 'dart:io';

import 'package:path_provider/path_provider.dart';

/// Lưu ảnh đại diện của từng người dùng trong bộ nhớ máy (thư mục của app).
/// Mỗi lần đổi ảnh dùng tên file mới để giao diện không hiện ảnh cũ còn lưu tạm.
class AvatarStorage {
  AvatarStorage({Future<Directory> Function()? baseDirectory})
    : _baseDirectory = baseDirectory ?? getApplicationDocumentsDirectory;

  final Future<Directory> Function() _baseDirectory;

  static const String _folder = 'avatars';
  static const String _extension = '.jpg';

  Future<Directory> _directory() async {
    final base = await _baseDirectory();
    final directory = Directory('${base.path}/$_folder');
    if (!directory.existsSync()) await directory.create(recursive: true);
    return directory;
  }

  Future<List<File>> _filesOf(String userId) async {
    final directory = await _directory();
    return directory
        .listSync()
        .whereType<File>()
        .where((f) => f.uri.pathSegments.last.startsWith('$userId-'))
        .toList();
  }

  /// Đường dẫn ảnh hiện tại của người dùng, null nếu chưa có.
  Future<String?> load(String userId) async {
    final files = await _filesOf(userId);
    return files.isEmpty ? null : files.last.path;
  }

  /// Chép ảnh vừa chọn vào thư mục của app, xóa ảnh cũ. Trả về đường dẫn mới.
  Future<String> save(String userId, String sourcePath) async {
    await delete(userId);
    final directory = await _directory();
    final stamp = DateTime.now().microsecondsSinceEpoch;
    final saved = await File(sourcePath)
        .copy('${directory.path}/$userId-$stamp$_extension');
    return saved.path;
  }

  Future<void> delete(String userId) async {
    for (final file in await _filesOf(userId)) {
      await file.delete();
    }
  }
}
