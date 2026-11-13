import 'dart:ui' show FontFeature;

import 'package:flutter/material.dart';

// ----- Bảng màu -----
const bg = Color(0xFFF9FAFB); // nền app
const ink = Color(0xFF111111); // chữ chính
const muted = Color(0xFF5F6368); // chữ phụ
const line = Color(0xFFE8E8E8); // viền mỏng
const chip = Color(0xFFF0F0F0); // nền vòng tròn icon
const accent = Color(0xFF2F6B5A); // màu nhấn duy nhất
const pos = Color(0xFF247B50); // số dương (thu nhập)
const neg = Color(0xFFC4242A); // số âm / xóa

// ----- Kiểu chữ rút gọn -----
TextStyle ts(double size, {FontWeight w = FontWeight.w400, Color c = ink}) {
  return TextStyle(
    fontSize: size,
    fontWeight: w,
    color: c,
    height: 1.3,
    fontFeatures: const [FontFeature.tabularFigures()],
  );
}

// ----- Theme cho cả app -----
ThemeData buildTheme() {
  return ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: bg,
    splashFactory: NoSplash.splashFactory,
  );
}
