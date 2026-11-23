import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../common/app_limits.dart';
import '../../common/app_sizes.dart';
import '../../common/app_strings.dart';
import '../../models/avatar_action.dart';
import '../../services/avatar_storage.dart';
import '../auth/auth_cubit.dart';
import '../auth/auth_state.dart';
import '../load_status.dart';
import 'avatar_state.dart';

/// Đổi ảnh đại diện: chụp bằng camera, chọn từ thư viện hoặc xóa.
/// Tự tải ảnh của người dùng mỗi khi đăng nhập / đổi tài khoản.
class AvatarCubit extends Cubit<AvatarState> {
  AvatarCubit(this._storage, this._picker, this._authCubit)
    : super(const AvatarState()) {
    _subscription = _authCubit.stream.listen(_onAuthChanged);
    _onAuthChanged(_authCubit.state);
  }

  final AvatarStorage _storage;
  final ImagePicker _picker;
  final AuthCubit _authCubit;
  late final StreamSubscription<AuthState> _subscription;

  String? get _userId => _authCubit.state.user?.uid;

  Future<void> _onAuthChanged(AuthState auth) async {
    final userId = auth.user?.uid;
    if (userId == null) {
      emit(const AvatarState());
      return;
    }
    final path = await _storage.load(userId);
    if (!isClosed && userId == _userId) {
      emit(AvatarState(localPath: path, status: LoadStatus.success));
    }
  }

  Future<void> handle(AvatarAction action) => switch (action) {
    AvatarAction.camera => _pick(ImageSource.camera),
    AvatarAction.gallery => _pick(ImageSource.gallery),
    AvatarAction.remove => _remove(),
  };

  Future<void> _pick(ImageSource source) async {
    final userId = _userId;
    if (userId == null || state.isSaving) return;
    final XFile? image;
    try {
      image = await _picker.pickImage(
        source: source,
        maxWidth: AppSizes.avatarImageMax,
        maxHeight: AppSizes.avatarImageMax,
        imageQuality: AppLimits.avatarQuality,
        preferredCameraDevice: CameraDevice.front,
      );
    } on PlatformException {
      _fail(AppStrings.cameraUnavailable);
      return;
    }
    if (image == null) return; // Người dùng bấm Hủy.

    emit(AvatarState(localPath: state.localPath, status: LoadStatus.loading));
    try {
      final path = await _storage.save(userId, image.path);
      emit(AvatarState(localPath: path, status: LoadStatus.success));
    } on FileSystemException {
      _fail(AppStrings.avatarSaveFailed);
    }
  }

  Future<void> _remove() async {
    final userId = _userId;
    if (userId == null) return;
    await _storage.delete(userId);
    emit(const AvatarState(status: LoadStatus.success));
  }

  void _fail(String message) => emit(
    AvatarState(
      localPath: state.localPath,
      status: LoadStatus.failure,
      errorMessage: message,
    ),
  );

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }
}
