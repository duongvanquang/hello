import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import 'package:hello/services/avatar_storage.dart';

void main() {
  late Directory base;
  late AvatarStorage storage;
  late File photo;

  setUp(() async {
    base = await Directory.systemTemp.createTemp('avatar_test');
    storage = AvatarStorage(baseDirectory: () async => base);
    photo = await File('${base.path}/picked.jpg').writeAsBytes([1, 2, 3]);
  });

  tearDown(() => base.delete(recursive: true));

  test('Chưa có ảnh thì trả về null', () async {
    expect(await storage.load('user-1'), isNull);
  });

  test('Lưu ảnh rồi đọc lại đúng ảnh đó', () async {
    final saved = await storage.save('user-1', photo.path);
    expect(await storage.load('user-1'), saved);
    expect(await File(saved).readAsBytes(), [1, 2, 3]);
  });

  test('Đổi ảnh thì xóa ảnh cũ và đặt tên file mới', () async {
    final first = await storage.save('user-1', photo.path);
    final second = await storage.save('user-1', photo.path);
    expect(second, isNot(first));
    expect(File(first).existsSync(), isFalse);
    expect(await storage.load('user-1'), second);
  });

  test(
    'Ảnh của mỗi người dùng tách riêng; xóa ảnh không ảnh hưởng người khác',
    () async {
      await storage.save('user-1', photo.path);
      final other = await storage.save('user-2', photo.path);
      await storage.delete('user-1');
      expect(await storage.load('user-1'), isNull);
      expect(await storage.load('user-2'), other);
    },
  );
}
