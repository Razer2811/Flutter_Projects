🛒 ShopEasy - E-Commerce Mobile Application
Đồ án xuyên suốt Học phần: Lập trình Ứng dụng cho Thiết bị Di động (3 Tín chỉ) Khoa Công nghệ Thông tin — Trường Đại học Khoa học, Đại học Huế Giảng viên hướng dẫn: ThS. Nguyễn Dũng

📌 Giới thiệu dự án
ShopEasy là ứng dụng thương mại điện tử B2C đa nền tảng (Android & iOS) được xây dựng xuyên suốt các chương thực hành trong học phần. Sản phẩm áp dụng kiến trúc chuẩn (Feature-first với tầng Core dùng chung), giao diện Material Design 3 hiện đại, tối giản và tích hợp đầy đủ các tính năng thực tế từ giao diện, quản lý trạng thái, xử lý mạng REST API, cơ sở dữ liệu cục bộ cho đến dịch vụ đám mây Firebase.

🚀 Tính năng chính
📱 Khởi động & Giao diện (Splash & Theme):
Màn hình Splash Screen mượt mà với Animation (AnimationController, FadeTransition, SlideTransition).
Hệ thống Theme thống nhất (AppTheme), quản lý bảng màu (AppColors) và kích thước chuẩn (AppSizes).
🛍️ Trang chủ & Danh mục (Home & Product):
Danh sách sản phẩm hiển thị dạng Grid/List linh hoạt với ProductCard.
Phân loại theo danh mục, thanh tìm kiếm sản phẩm và hiển thị chi tiết sản phẩm.
🛒 Giỏ hàng & Yêu thích (Cart & Wishlist):
Thêm, xóa, điều chỉnh số lượng và tự động tính tổng tiền.
Quản lý trạng thái toàn cục bằng Provider.
🔄 Điều hướng nâng cao (Navigation):
Thanh điều hướng đáy (NavigationBar) kết hợp GoRouter và deep linking.
🌐 Kết nối REST API & Mạng (Networking):
Tải dữ liệu sản phẩm từ REST API (sử dụng http / Dio).
Hỗ trợ cuộn vô tận (Infinite Scroll), hiển thị trạng thái loading (cached_network_image) và xử lý lỗi mạng.
💾 Lưu trữ dữ liệu cục bộ (Local Storage):
Lưu giỏ hàng và lịch sử xem sản phẩm gần đây bằng SQLite (sqflite) và SharedPreferences.
🔥 Xác thực & Đồng bộ Firebase (Backend Services):
Đăng nhập/Đăng ký qua Email và tài khoản Google bằng Firebase Auth.
Đồng bộ giỏ hàng và đơn hàng theo thời gian thực với Cloud Firestore.
📲 Tính năng thiết bị & Trải nghiệm nâng cao:
Quét mã QR sản phẩm, hiệu ứng chuyển cảnh Hero, thông báo đẩy (Push Notification) và Skeleton Loading.
🧪 Kiểm thử & Đóng gói (Testing & Deployment):
Bộ kiểm thử đầy đủ (Unit Test, Widget Test), quy trình CI/CD và đóng gói phát hành ứng dụng.
🛠️ Công nghệ & Thư viện sử dụng
Framework: Flutter 3.24 (Stable channel)
Ngôn ngữ: Dart 3.4 (Null Safety)
Target SDK: Android SDK 34 (Android 14) / iOS 15+ (Xcode 15)
Thư viện/Packages chính:
provider (^6.1.2): Quản lý trạng thái ứng dụng.
go_router (^14.2.7): Khung điều hướng & routing.
http (^1.2.0) / dio (^5.4.3+1): Gọi REST API.
sqflite (^2.3.3+1) & shared_preferences (^2.3.1): Lưu trữ dữ liệu cục bộ.
cached_network_image (^3.3.1): Tải và cache ảnh từ mạng.
intl: Định dạng tiền tệ (VNĐ) và ngày tháng.
firebase_core, firebase_auth, cloud_firestore: Dịch vụ Firebase.
📂 Cấu trúc thư mục dự án
Dự án được tổ chức theo mô hình kết hợp (Feature-first với tầng Core dùng chung):

⚙️ Hướng dẫn cài đặt & Chạy ứng dụng
1. Yêu cầu môi trường
Đã cài đặt Flutter SDK 3.24 và Dart 3.4.
IDE: Visual Studio Code (đã cài extension Flutter) hoặc Android Studio.
Android Emulator (API 34) hoặc thiết bị Android/iOS thật đã bật USB Debugging.
2. Các bước khởi chạy
Clone kho lưu trữ về máy cá nhân
Cài đặt các gói thư viện phụ thuộc: flutter pub get
Kiểm tra thiết bị kết nối: flutter devices
Chạy ứng dụng: flutter run
📝 Nhật ký phát triển theo học phần
Chương	Nội dung & Tính năng đã hoàn thành
Chương 3	Khởi tạo dự án, cấu trúc thư mục core/ & features/, cấu hình AppTheme, Splash Screen animation.
Chương 4	Xây dựng Màn hình Trang chủ với ProductCard, Màn hình Chi tiết sản phẩm.
Chương 5	Bố cục responsive, lưới sản phẩm nhiều cột, thanh tìm kiếm.
Chương 6	Quản lý trạng thái Giỏ hàng & Danh sách yêu thích với Provider.
Chương 7	Thiết lập điều hướng đa màn hình với GoRouter & AppShell (NavigationBar).
Chương 8	Tải danh sách sản phẩm từ REST API, xử lý trạng thái loading & lỗi mạng.
Chương 9	Lưu trữ giỏ hàng & Lịch sử xem sản phẩm cục bộ với SQLite & SharedPreferences.
Chương 10	Đăng nhập Firebase Auth, đồng bộ dữ liệu giỏ hàng lên Cloud Firestore.
Chương 11	Tích hợp quét mã QR, hiệu ứng Hero, animation đơn hàng & Push Notification.
Chương 12	Viết bộ kiểm thử (Unit & Widget test), cấu hình CI/CD và đóng gói ứng dụng.
👤 Thông tin sinh viên
Họ và tên: Trần Lê Minh Khánh
Mã số sinh viên: 23T1080033
Lớp: KTPM K47 — Khoa CNTT, Trường Đại học Khoa học, Đại học Huế
Email: tranleminhkhanh5734@gmail.com
Cảm ơn ThS. Nguyễn Dũng đã hướng dẫn trong suốt học phần!
