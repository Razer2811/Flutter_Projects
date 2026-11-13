// lib/core/theme/app_theme.dart
import 'package:easy_shop/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.light,
    ),
    scaffoldBackgroundColor: AppColors.background,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.surface,
      foregroundColor: AppColors.textPrimary,
      elevation: 0,
    ),
    // cardTheme, elevatedButtonTheme, textTheme: xem đầy đủ trong giáo trình
  );
  AppTheme._();
}
