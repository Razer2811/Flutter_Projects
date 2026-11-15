import 'package:flutter/material.dart';

import '../../../core/app_colors.dart';

class BalanceHeader extends StatelessWidget {
  final String balance;
  final bool hidden;
  final VoidCallback onToggle;

  const BalanceHeader({
    required this.balance,
    required this.hidden,
    required this.onToggle,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    hidden ? '••••••' : balance,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 34,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: onToggle,
                    child: Icon(
                      hidden
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              const Row(
                children: [
                  Text(
                    'Tổng số dư',
                    style: TextStyle(color: AppColors.grey, fontSize: 16),
                  ),
                  SizedBox(width: 6),
                  Icon(Icons.help, color: AppColors.grey, size: 18),
                ],
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.search, color: Colors.white, size: 28),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.notifications_none,
            color: Colors.white,
            size: 28,
          ),
        ),
      ],
    );
  }
}
