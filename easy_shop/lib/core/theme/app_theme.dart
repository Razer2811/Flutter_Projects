import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart';

import '../constants/app_colors.dart';

class AppTheme {
  static ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.light,
    ),
    scaffoldBackgroundColor: AppColors.background,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.surface,
      foregroundColor: AppColors.textPrimary,
      elevation: 0,
    ),
    // cardTheme, elevatedButtonTheme, textTheme: bổ sung theo giáo trình
  );

  AppTheme._();
}
