import 'package:flutter/material.dart';

import '../core/theme.dart';
import '../models/category.dart';
import 'cat_disc.dart';

class CategoryPicker extends StatelessWidget {
  final bool income;
  final String selected;
  final ValueChanged<String> onSelect;

  const CategoryPicker({
    required this.income,
    required this.selected,
    required this.onSelect,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final list = cats.where((c) => c.income == income).toList();

    return GridView.count(
      crossAxisCount: 4,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      childAspectRatio: 0.95,
      children: [
        for (final c in list)
          InkWell(
            onTap: () => onSelect(c.id),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CatDisc(c, size: 48, selected: selected == c.id),
                const SizedBox(height: 6),
                Text(
                  c.name,
                  style: ts(
                    12,
                    w: selected == c.id ? FontWeight.w600 : FontWeight.w400,
                    c: selected == c.id ? ink : muted,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
