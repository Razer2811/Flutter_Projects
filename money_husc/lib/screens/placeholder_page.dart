import 'package:flutter/material.dart';

import '../core/app_colors.dart';

class PlaceholderPage extends StatelessWidget {
  final String title;

  const PlaceholderPage(this.title, {super.key});

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
