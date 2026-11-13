import 'package:flutter/material.dart';

import 'product_list_screen.dart';

void main() => runApp(const ShopApp());

class ShopApp extends StatelessWidget {
  const ShopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cửa hàng',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.blue),
      home: const ProductListScreen(),
    );
  }
}
