import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'features/splash/screens/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ShopEasyApp());
}

class ShopEasyApp extends StatelessWidget {
  const ShopEasyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'ShopEasy',
    debugShowCheckedModeBanner: false,
    theme: AppTheme.lightTheme,
    home: const SplashScreen(),
  );
}
