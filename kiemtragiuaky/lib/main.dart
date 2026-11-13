import 'package:flutter/material.dart';

import 'database/database_platform.dart';
import 'screens/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDatabase();
  runApp(const MoneyFlowApp());
}

class MoneyFlowApp extends StatelessWidget {
  const MoneyFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MoneyFlow',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF6F7F5),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF167C63),
          surface: const Color(0xFFF6F7F5),
        ),
        fontFamily: 'Roboto',
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF6F7F5),
          foregroundColor: Color(0xFF17211D),
          elevation: 0,
          centerTitle: false,
        ),
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: Colors.white,
          indicatorColor: const Color(0xFFDCEFE8),
          labelTextStyle: WidgetStateProperty.all(
            const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
