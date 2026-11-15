import 'package:flutter/material.dart';

import '../core/app_colors.dart';

class PlaceholderPage extends StatelessWidget {
  final String title;

  const PlaceholderPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        title,
        style: const TextStyle(color: AppColors.grey, fontSize: 18),
      ),
    );
  }
}
