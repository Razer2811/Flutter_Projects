import 'package:flutter/material.dart';

import '../core/theme.dart';
import '../models/category.dart';

class CatDisc extends StatelessWidget {
  final Cat cat;
  final double size;
  final bool selected;

  const CatDisc(this.cat, {this.size = 36, this.selected = false, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: selected ? ink : chip,
        shape: BoxShape.circle,
      ),
      child: Icon(
        cat.icon,
        size: size * 0.5,
        color: selected ? Colors.white : muted,
      ),
    );
  }
}
