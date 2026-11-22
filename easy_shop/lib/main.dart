import 'package:material_ui/material_ui.dart';

import 'core/theme/app_theme.dart';
import 'features/splash/screens/splash_screen.dart';

void main() {
  // Đảm bảo Flutter engine khởi tạo trước khi chạy code platform-specific
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ShopEasyApp());
}

class ShopEasyApp extends StatelessWidget {
  const ShopEasyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'ShopEasy',
    debugShowCheckedModeBanner: false, // Ẩn banner DEBUG
    theme: AppTheme.lightTheme,
    home: const SplashScreen(), // Chương 7 sẽ thay bằng GoRouter
  );
}
