import 'package:flutter/material.dart';

import '../core/app_colors.dart';

class AppBottomBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const AppBottomBar({
    required this.currentIndex,
    required this.onTap,
    super.key,
  });

  static const items = [
    (Icons.home, 'Tổng quan'),
    (Icons.account_balance_wallet_outlined, 'Sổ giao dịch'),
    (Icons.pie_chart_outline, 'Ngân sách'),
    (Icons.person_outline, 'Tài khoản'),
  ];

  Widget item(int i) {
    return Expanded(
      child: NavItem(
        icon: items[i].$1,
        label: items[i].$2,
        selected: currentIndex == i,
        onTap: () => onTap(i),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: const Color(0xFF111111),
      surfaceTintColor: Colors.transparent,
      shape : const CircularNotchedRectangle(),
      notchMargin: 8,
      height: 68,
      padding: const EdgeInsets.all(0),
      child: Row(
        children: [
          item(0),
          item(1),
          const SizedBox(width: 64), // chỗ trống cho nút +
          item(2),
          item(3),
        ],
      ),
    );
  }
}


class NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const NavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.green : AppColors.grey;
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 26),
          const SizedBox(height: 2),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: color, fontSize: 11),
          ),
        ],
      ),
    );
  }
}