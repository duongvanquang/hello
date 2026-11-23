import 'app_limits.dart';

/// Tất cả chữ hiển thị trong app. Muốn đổi chữ nào thì sửa ở đây.
/// Chữ có chứa giá trị thay đổi (tên phim, số phút...) là hàm ở cuối file.
class AppStrings {
  AppStrings._();

  static const String appName = 'PhimHay';

  // ===== Từ dùng chung (dùng lại ở nhiều chỗ) =====
  static const String login = 'Đăng nhập';
  static const String register = 'Đăng ký';
  static const String logout = 'Đăng xuất';
  static const String genre = 'Thể loại';
  static const String myList = 'Danh sách';
  static const String myListFull = 'Danh sách của tôi';
  static const String retry = 'Thử lại';
  static const String email = 'Email';
  static const String password = 'Mật khẩu';
  static const String fullName = 'Họ tên';
  static const String orDivider = 'hoặc';
  static const String metaSeparator = '  •  ';
  static const String adultBadge = '18+';

  // ===== Thanh điều hướng dưới =====
  static const String tabHome = 'Trang chủ';
  static const String tabSearch = 'Tìm kiếm';
  static const String tabComingSoon = 'Sắp chiếu';

  // ===== Chip lọc trên trang chủ =====
  static const String tvSeries = 'Phim bộ';
  static const String singleMovies = 'Phim lẻ';

  // ===== Đăng nhập / Đăng ký =====
  static const String loginSubtitle = 'Chào mừng bạn quay lại!';
  static const String registerTitle = 'Tạo tài khoản';
  static const String registerSubtitle = 'Đăng ký để lưu phim yêu thích';
  static const String forgotTitle = 'Quên mật khẩu';
  static const String forgotPasswordLink = '$forgotTitle?';
  static const String forgotSubtitle =
      'Nhập email đã đăng ký, chúng tôi sẽ gửi link đặt lại mật khẩu.';
  static const String confirmPassword = 'Nhập lại mật khẩu';
  static const String sendResetLink = 'Gửi link đặt lại';
  static const String resetLinkSent =
      'Đã gửi link đặt lại mật khẩu. Hãy kiểm tra hộp thư email.';
  static const String continueWithGoogle = 'Tiếp tục với Google';
  static const String googleLogoLetter = 'G';
  static const String noAccount = 'Chưa có tài khoản?';
  static const String haveAccount = 'Đã có tài khoản?';
  static const String backToLogin = 'Quay lại đăng nhập';
  static const String guestName = 'Người dùng';

  // ===== Kiểm tra dữ liệu nhập =====
  static const String nameRequired = 'Vui lòng nhập họ tên';
  static const String nameTooShort = 'Họ tên quá ngắn';
  static const String emailRequired = 'Vui lòng nhập email';
  static const String emailInvalid = 'Email không hợp lệ';
  static const String passwordRequired = 'Vui lòng nhập mật khẩu';
  static const String confirmPasswordRequired = 'Vui lòng nhập lại mật khẩu';
  static const String passwordMismatch = 'Mật khẩu nhập lại không khớp';

  // ===== Lỗi đăng nhập (Firebase) =====
  static const String accountDisabled = 'Tài khoản này đã bị khóa.';
  static const String wrongCredentials = 'Email hoặc mật khẩu không đúng.';
  static const String emailInUse =
      'Email này đã được dùng cho một tài khoản khác.';
  static const String accountExistsOtherMethod =
      'Email này đã đăng ký bằng cách khác. Hãy đăng nhập bằng email và mật khẩu.';
  static const String tooManyAttempts =
      'Bạn thử quá nhiều lần. Vui lòng đợi một lát rồi thử lại.';
  static const String signInMethodDisabled =
      'Cách đăng nhập này chưa được bật trong Firebase.';
  static const String firebaseNotConfigured =
      'Chưa kết nối Firebase. Hãy chạy flutterfire configure rồi mở lại app.';
  static const String googleNotEnabled =
      'Chưa bật đăng nhập Google trong Firebase '
      '(Authentication → Sign-in method → Google).';
  static const String googleSignInFailed =
      'Đăng nhập Google thất bại. Vui lòng thử lại.';

  // ===== Ảnh đại diện =====
  static const String changeAvatar = 'Đổi ảnh đại diện';
  static const String takePhoto = 'Chụp ảnh';
  static const String chooseFromLibrary = 'Chọn từ thư viện';
  static const String removePhoto = 'Xóa ảnh đại diện';
  static const String cameraUnavailable =
      'Không mở được camera hoặc thư viện ảnh. Hãy kiểm tra quyền truy cập trong Cài đặt.';
  static const String avatarSaveFailed =
      'Không lưu được ảnh. Vui lòng thử lại.';

  // ===== Hàng phim trên trang chủ =====
  static const String rowTrending = 'Thịnh hành tuần này';
  static const String rowMovieTrending = 'Phim lẻ thịnh hành';
  static const String rowNowPlaying = 'Đang chiếu rạp';
  static const String rowPopular = 'Phổ biến';
  static const String rowTopRated = 'Đánh giá cao';
  static const String rowTvTrending = 'Phim bộ thịnh hành';
  static const String rowTvAiringToday = 'Phim bộ chiếu hôm nay';
  static const String rowTvPopular = 'Phim bộ phổ biến';
  static const String rowTvTopRated = 'Phim bộ đánh giá cao';

  // ===== Lọc / tìm kiếm / danh sách =====
  static const String chooseGenre = 'Chọn thể loại';
  static const String searchHint = 'Tìm phim lẻ, phim bộ...';
  static const String searchStart = 'Nhập tên phim để tìm.';
  static const String searchNoResult = 'Không tìm thấy phim nào.';
  static const String myListEmpty =
      'Chưa có phim nào. Bấm "$myList" trên phim để lưu vào đây.';

  // ===== Tải dữ liệu / lỗi API =====
  static const String loading = 'Đang tải phim...';
  static const String noMovies = 'Chưa có phim nào.';
  static const String noDescription = 'Phim chưa có mô tả.';
  static const String missingApiKey =
      'Chưa có khóa TMDB. Tạo file .env.json (xem .env.example.json) '
      'rồi chạy lại bằng F5.';
  static const String invalidApiKey = 'Khóa TMDB không hợp lệ hoặc đã hết hạn.';
  static const String noNetwork = 'Không có kết nối mạng.';
  static const String networkTimeout = 'Mạng chậm, tải quá lâu.';
  static const String serverError = 'Máy chủ đang lỗi';
  static const String unauthorized = 'Không có quyền truy cập.';
  static const String notFound = 'Không tìm thấy dữ liệu.';
  static const String requestFailed = 'Yêu cầu không thành công';
  static const String invalidResponse = 'Dữ liệu trả về không hợp lệ.';

  // ===== Nút trên phim =====
  static const String addedToList = 'Đã thêm';
  static const String info = 'Thông tin';
  static const String rate = 'Đánh giá';
  static const String share = 'Chia sẻ';

  // ===== Xem phim =====
  static const String watchTrailer = 'Xem trailer';
  static const String watchMovie = 'Xem phim';
  static const String whereToWatch = 'Xem phim ở đâu';
  static const String whereToWatchNote =
      'Mở trang tìm kiếm của dịch vụ hợp pháp. Phim có thể chưa có ở đó; '
      'phim mới ra thường chỉ chiếu ở rạp.';
  static const String cinemaShowtimes = 'Lịch chiếu rạp & đặt vé';
  static const String streamingService = 'Xem online (cần tài khoản / gói)';
  static const String cannotOpenLink = 'Không mở được trang. Vui lòng thử lại.';

  // ===== Đánh giá / chia sẻ =====
  static const String rateTitle = 'Bạn chấm phim này mấy sao?';
  static const String rateSubmit = 'Gửi đánh giá';
  static const String rateThanks = 'Cảm ơn bạn đã đánh giá!';
  static const String rateChooseStars = 'Chọn số sao trước khi gửi.';

  // ===== Tiêu đề / thông báo =====
  static const String similar = 'Phim tương tự';
  static const String featuredLabel = 'PHIM NỔI BẬT';
  static const String noTrailer = 'Phim này chưa có trailer.';

  // ===== Chữ có giá trị thay đổi =====

  /// "Mật khẩu cần ít nhất 6 ký tự"
  static String passwordTooShort(int minLength) =>
      'Mật khẩu cần ít nhất $minLength ký tự';

  /// "Có lỗi xảy ra (mã-lỗi). Vui lòng thử lại."
  static String unknownError(String code) =>
      'Có lỗi xảy ra ($code). Vui lòng thử lại.';

  /// "Máy chủ đang lỗi (500)"
  static String withStatus(String message, int statusCode) =>
      '$message ($statusCode)';

  /// "Khởi chiếu 12/12/2026"
  static String releaseOn(DateTime date) =>
      'Khởi chiếu ${date.day.toString().padLeft(2, '0')}/'
      '${date.month.toString().padLeft(2, '0')}/${date.year}';

  /// Điểm đánh giá: "7.8"
  static String rating(double value) =>
      value.toStringAsFixed(AppLimits.ratingDecimals);

  /// Nhãn nút sau khi đã chấm: "Đã chấm ★4"
  static String rated(int stars) => 'Đã chấm ★$stars';

  /// Nội dung khi chia sẻ phim.
  static String shareMovie(String title, int? year, String url) =>
      '🎬 $title${year == null ? '' : ' ($year)'}\nXem thông tin phim: $url';

  /// "Thể loại: Hành động, Phiêu lưu"
  static String genreLine(String genres) => '$genre: $genres';

  /// "2g 08p" hoặc "45p"
  static String duration(int hours, int minutes) => hours == 0
      ? '${minutes}p'
      : '${hours}g ${minutes.toString().padLeft(2, '0')}p';
}
