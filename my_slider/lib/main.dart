import 'package:flutter/material.dart';

import 'indicator.dart';
import 'MySlider1.dart';
import 'MySlider2.dart';
import 'MySlider3.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Slider',
      theme: ThemeData(colorSchemeSeed: Colors.blue, useMaterial3: true),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void _open(BuildContext context, Widget page) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Slider - 3 phương án')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () => _open(context, const MySlider1()),
              child: const Text('Phương án 1: SingleChildScrollView'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => _open(context, const MySlider2()),
              child: const Text('Phương án 2: ListView (horizontal)'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => _open(context, const MySlider3()),
              child: const Text('Phương án 3: PageView (hay dùng nhất)'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => _open(context, const MyIndicator()),
              child: const Text('Phương án 4: test indicator'),
            ),
          ],
        ),
      ),
    );
  }
}
