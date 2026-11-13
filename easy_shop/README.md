# 🛒 ShopEasy - E-Commerce Mobile Application

Ứng dụng thương mại điện tử đa nền tảng Android & iOS được phát triển xuyên suốt học phần **Lập trình Ứng dụng cho Thiết bị Di động (3 tín chỉ)** tại Khoa Công nghệ Thông tin, Trường Đại học Khoa học, Đại học Huế.

Dự án sử dụng Flutter và Dart, áp dụng kiến trúc Feature-first kết hợp Core dùng chung, giao diện Material Design 3 và tích hợp các công nghệ quản lý trạng thái, REST API, lưu trữ cục bộ và Firebase.

---

## 📑 Mục lục

- [Giới thiệu dự án](#-giới-thiệu-dự-án)
- [Tính năng chính](#-tính-năng-chính)
- [Công nghệ sử dụng](#️-công-nghệ-sử-dụng)
- [Cấu trúc dự án](#-cấu-trúc-dự-án)
- [Yêu cầu môi trường](#-yêu-cầu-môi-trường)
- [Cài đặt và chạy ứng dụng](#-cài-đặt-và-chạy-ứng-dụng)
- [Lộ trình phát triển](#-lộ-trình-phát-triển)
- [Thông tin sinh viên](#-thông-tin-sinh-viên)
- [Lời cảm ơn](#-lời-cảm-ơn)

---

## 📌 Giới thiệu dự án

**ShopEasy** là ứng dụng thương mại điện tử theo mô hình B2C (Business-to-Consumer), hướng đến trải nghiệm mua sắm trực tuyến hiện đại, thuận tiện và thân thiện với người dùng trên các thiết bị di động.

Dự án được xây dựng xuyên suốt các chương thực hành của học phần, từ thiết kế giao diện, xây dựng các chức năng cốt lõi, quản lý trạng thái, kết nối API, lưu trữ dữ liệu đến tích hợp dịch vụ Firebase.

Các mục tiêu chính:

- Xây dựng ứng dụng di động đa nền tảng bằng Flutter.
- Áp dụng kiến trúc Feature-first kết hợp tầng Core dùng chung.
- Thiết kế giao diện hiện đại theo Material Design 3.
- Quản lý trạng thái ứng dụng bằng Provider.
- Kết nối REST API và xử lý dữ liệu bất đồng bộ.
- Lưu trữ dữ liệu cục bộ bằng SQLite và SharedPreferences.
- Tích hợp Firebase Authentication và Cloud Firestore.
- Thực hành kiểm thử, CI/CD và đóng gói ứng dụng.

## 🚀 Tính năng chính

### 📱 1. Khởi động và giao diện

- Splash Screen với hiệu ứng chuyển động.
- Sử dụng `AnimationController`, `FadeTransition` và `SlideTransition`.
- Quản lý giao diện thống nhất với `AppTheme`, `AppColors` và `AppSizes`.
- Thiết kế theo Material Design 3.

### 🛍️ 2. Trang chủ và sản phẩm

- Hiển thị danh sách sản phẩm dưới dạng Grid hoặc List.
- Tái sử dụng giao diện sản phẩm thông qua `ProductCard`.
- Phân loại sản phẩm theo danh mục.
- Tìm kiếm sản phẩm.
- Xem thông tin chi tiết sản phẩm.

### 🛒 3. Giỏ hàng và danh sách yêu thích

- Thêm và xóa sản phẩm khỏi giỏ hàng.
- Tăng hoặc giảm số lượng sản phẩm.
- Tự động tính tổng tiền.
- Quản lý danh sách yêu thích.
- Sử dụng Provider để quản lý trạng thái toàn cục.

### 🧭 4. Điều hướng ứng dụng

- Điều hướng giữa các màn hình bằng GoRouter.
- Thanh điều hướng dưới với Material `NavigationBar`.
- Tổ chức giao diện dùng chung thông qua `AppShell`.
- Hỗ trợ deep linking.

### 🌐 5. Kết nối REST API

- Tải danh sách sản phẩm từ REST API.
- Sử dụng HTTP hoặc Dio để gửi yêu cầu mạng.
- Hỗ trợ Infinite Scroll.
- Hiển thị trạng thái tải dữ liệu.
- Cache hình ảnh bằng `cached_network_image`.
- Xử lý lỗi mạng và các trạng thái dữ liệu.

### 💾 6. Lưu trữ dữ liệu cục bộ

- Sử dụng SQLite thông qua `sqflite`.
- Lưu trữ giỏ hàng và lịch sử sản phẩm đã xem.
- Sử dụng SharedPreferences cho các dữ liệu và tùy chọn phù hợp.
- Hỗ trợ lưu trữ dữ liệu trên thiết bị.

### 🔥 7. Xác thực và đồng bộ Firebase

- Đăng ký và đăng nhập bằng email.
- Hỗ trợ đăng nhập bằng tài khoản Google.
- Xác thực người dùng với Firebase Authentication.
- Đồng bộ giỏ hàng và đơn hàng với Cloud Firestore.
- Hỗ trợ cập nhật dữ liệu theo thời gian thực khi được cấu hình.

### 📲 8. Tính năng nâng cao

- Quét mã QR sản phẩm.
- Hiệu ứng chuyển cảnh Hero.
- Thông báo đẩy (Push Notification).
- Skeleton Loading nâng cao trải nghiệm người dùng.

### 🧪 9. Kiểm thử và triển khai

- Unit Test cho logic xử lý dữ liệu.
- Widget Test cho giao diện.
- Cấu hình CI/CD.
- Đóng gói ứng dụng để phát hành.

## 🛠️ Công nghệ sử dụng

| Công nghệ | Mục đích |
|---|---|
| Flutter 3.24 | Phát triển ứng dụng đa nền tảng |
| Dart 3.4 | Ngôn ngữ lập trình |
| Material Design 3 | Thiết kế giao diện |
| Provider `^6.1.2` | Quản lý trạng thái |
| GoRouter `^14.2.7` | Điều hướng và routing |
| HTTP `^1.2.0` | Gửi yêu cầu REST API |
| Dio `^5.4.3+1` | Xử lý yêu cầu HTTP |
| sqflite `^2.3.3+1` | Cơ sở dữ liệu SQLite |
| SharedPreferences `^2.3.1` | Lưu trữ tùy chọn cục bộ |
| cached_network_image `^3.3.1` | Tải và cache hình ảnh |
| intl | Định dạng tiền tệ và ngày tháng |
| Firebase Core | Khởi tạo Firebase |
| Firebase Authentication | Xác thực người dùng |
| Cloud Firestore | Lưu trữ và đồng bộ dữ liệu |

**Nền tảng mục tiêu:**

- Android: Android 14 / API 34.
- iOS: iOS 15 trở lên, yêu cầu môi trường Xcode tương thích.

## 📂 Cấu trúc dự án

Dự án được tổ chức theo kiến trúc Feature-first, kết hợp tầng Core để tái sử dụng các thành phần chung giữa các tính năng.

Cấu trúc tham khảo:

```text
lib/
├── core/
│   ├── constants/
│   ├── theme/
│   ├── router/
│   ├── services/
│   ├── utils/
│   └── widgets/
│
├── features/
│   ├── splash/
│   ├── home/
│   ├── product/
│   ├── cart/
│   ├── wishlist/
│   ├── auth/
│   ├── order/
│   └── profile/
│
├── app.dart
└── main.dart

test/
├── unit/
└── widget/

pubspec.yaml
README.md
```

*Cấu trúc trên là cấu trúc tham khảo; hãy điều chỉnh cho khớp với các thư mục thực tế trong repository.*

## ⚙️ Yêu cầu môi trường

Trước khi chạy dự án, cần chuẩn bị:

- Flutter SDK 3.24 stable.
- Dart SDK 3.4.
- Visual Studio Code với Flutter Extension hoặc Android Studio.
- Android Emulator API 34 hoặc thiết bị Android thật đã bật USB Debugging.
- Với iOS: máy macOS và phiên bản Xcode tương thích.
- Kết nối Internet để tải package và truy cập REST API.
- Cấu hình Firebase nếu sử dụng các tính năng xác thực và đồng bộ dữ liệu.

## ▶️ Cài đặt và chạy ứng dụng

### Bước 1: Clone repository

```bash
git clone <REPOSITORY_URL>
cd <PROJECT_FOLDER>
```

Thay `<REPOSITORY_URL>` bằng URL GitHub của dự án và `<PROJECT_FOLDER>` bằng tên thư mục thực tế.

### Bước 2: Cài đặt dependencies

```bash
flutter pub get
```

### Bước 3: Kiểm tra môi trường Flutter

```bash
flutter doctor
```

### Bước 4: Kiểm tra thiết bị

```bash
flutter devices
```

### Bước 5: Chạy ứng dụng

```bash
flutter run
```

### Bước 6: Cấu hình Firebase

Nếu dự án sử dụng Firebase Authentication hoặc Cloud Firestore, hãy cấu hình Firebase cho ứng dụng Android/iOS theo hướng dẫn chính thức của Firebase và FlutterFire.

Không đưa API key nhạy cảm, mật khẩu, service account private key hoặc thông tin xác thực vào repository công khai.

## 📚 Lộ trình phát triển theo học phần

| Chương | Nội dung |
|---|---|
| Chương 3 | Khởi tạo dự án, tổ chức thư mục `core/` và `features/`, cấu hình AppTheme, xây dựng Splash Screen animation. |
| Chương 4 | Xây dựng màn hình Trang chủ, ProductCard và Chi tiết sản phẩm. |
| Chương 5 | Thiết kế giao diện responsive, lưới sản phẩm nhiều cột và thanh tìm kiếm. |
| Chương 6 | Quản lý trạng thái giỏ hàng và danh sách yêu thích bằng Provider. |
| Chương 7 | Xây dựng điều hướng đa màn hình bằng GoRouter và AppShell. |
| Chương 8 | Kết nối REST API, tải sản phẩm và xử lý trạng thái loading/lỗi mạng. |
| Chương 9 | Lưu trữ giỏ hàng và lịch sử xem sản phẩm bằng SQLite, SharedPreferences. |
| Chương 10 | Tích hợp Firebase Authentication và đồng bộ giỏ hàng với Cloud Firestore. |
| Chương 11 | Tích hợp quét QR, hiệu ứng Hero, animation đơn hàng và Push Notification. |
| Chương 12 | Xây dựng Unit Test, Widget Test, cấu hình CI/CD và đóng gói ứng dụng. |

## 👨‍🎓 Thông tin sinh viên

- **Họ và tên:** Trần Lê Minh Khánh
- **Mã số sinh viên:** 23T1080033
- **Lớp:** KTPM K47
- **Khoa:** Công nghệ Thông tin
- **Trường:** Trường Đại học Khoa học, Đại học Huế
- **Email:** [tranleminhkhanh5734@gmail.com](mailto:tranleminhkhanh5734@gmail.com)

**Học phần:** Lập trình Ứng dụng cho Thiết bị Di động — 3 tín chỉ  
**Giảng viên hướng dẫn:** ThS. Nguyễn Dũng

## 🙏 Lời cảm ơn

Em xin chân thành cảm ơn **ThS. Nguyễn Dũng** đã hướng dẫn, hỗ trợ và truyền đạt kiến thức trong suốt quá trình học tập và thực hiện dự án ShopEasy.

Dự án là cơ hội để em củng cố kiến thức lập trình Flutter, thực hành xây dựng ứng dụng di động và tiếp cận các công nghệ được sử dụng trong phát triển phần mềm thực tế.

---

<p align="center">
  <b>ShopEasy — Making Online Shopping Easier 🛒</b>
</p>
