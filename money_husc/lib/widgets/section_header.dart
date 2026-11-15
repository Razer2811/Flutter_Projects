import 'package:flutter/material.dart';

import '../core/app_colors.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final String action;
  final VoidCallback onAction;

  const SectionHeader({
    required this.title,
    required this.action,
    required this.onAction,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(color: AppColors.grey, fontSize: 18),
        ),
        const Spacer(),
        TextButton(
          onPressed: onAction,
          style: TextButton.styleFrom(foregroundColor: AppColors.green),
          child: Text(
            action,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}
