# Kết nối Firebase (đăng nhập email + Google)

Code đăng nhập đã có sẵn. Chỉ cần tạo project Firebase và tải file cấu hình về.

## 1. Tạo project Firebase
1. Vào https://console.firebase.google.com → **Add project** → đặt tên (ví dụ `flutter-2026`) → tạo.
2. Menu trái **Build → Authentication** → **Get started** → tab **Sign-in method**:
   - Bật **Email/Password**.
   - Bật **Google** (chọn email hỗ trợ) → **Save**.

## 2. Cài công cụ (chạy một lần trên máy)
```bash
curl -sL https://firebase.tools | bash
```
```bash
firebase login
```
```bash
dart pub global activate flutterfire_cli
```

## 3. Nối project Flutter với Firebase
```bash
cd ~/Desktop/"Flutter 2026" && flutterfire configure
```
- Chọn project vừa tạo, chọn nền tảng **ios** và **android**.
- Lệnh này tạo `ios/Runner/GoogleService-Info.plist`, `android/app/google-services.json`
  và `lib/firebase_options.dart`.

## 4. Bật Google Sign-In trên iOS
Mở `ios/Runner/GoogleService-Info.plist`, copy giá trị `REVERSED_CLIENT_ID`
(dạng `com.googleusercontent.apps.xxxx`) và thêm vào `ios/Runner/Info.plist`:

```xml
<key>CFBundleURLTypes</key>
<array>
  <dict>
    <key>CFBundleURLSchemes</key>
    <array>
      <string>com.googleusercontent.apps.xxxx</string>
    </array>
  </dict>
</array>
```

## 5. Chạy lại app
Tắt app hẳn rồi bấm F5. Khung vàng "Chưa kết nối Firebase" sẽ biến mất.

## Ghi chú
- Bundle ID hiện là `com.example.hello`. Nếu muốn đổi (ví dụ `com.quang.flutter2026`),
  hãy đổi **trước** bước 3, vì Firebase gắn theo Bundle ID.
- Code liên quan: `lib/services/auth_service.dart` (mọi thao tác đăng nhập),
  `lib/pages/auth_gate.dart` (chọn trang Đăng nhập hay Trang chủ).
