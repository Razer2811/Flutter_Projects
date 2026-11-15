import 'package:flutter/material.dart';

import 'core/app_theme.dart';
import 'screens/main_shell.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: buildDarkTheme(),
      home: const MainShell(),
    );
  }
}
