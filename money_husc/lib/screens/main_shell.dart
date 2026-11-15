import 'package:flutter/material.dart';

import '../core/app_colors.dart';
import '../widgets/app_bottom_bar.dart';
import 'overview/overview_page.dart';
import 'placeholder_page.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;

  static const _pages = <Widget>[
    OverviewPage(),
    PlaceholderPage('Sổ giao dịch'),
    PlaceholderPage('Ngân sách'),
    PlaceholderPage('Tài khoản'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _index, children: _pages),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {}, // sau này mở form thêm giao dịch
        backgroundColor: AppColors.green,
        foregroundColor: Colors.white,
        elevation: 0,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, size: 32),
      ),
      bottomNavigationBar: AppBottomBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
      ),
    );
  }
}
