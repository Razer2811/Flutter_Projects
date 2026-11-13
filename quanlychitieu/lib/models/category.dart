import 'package:flutter/material.dart';

class Cat {
  final String id;
  final String name;
  final IconData icon;
  final bool income;

  const Cat(this.id, this.name, this.icon, {this.income = false});
}

const cats = [
  Cat('food', 'Ăn uống', Icons.restaurant_outlined),
  Cat('move', 'Di chuyển', Icons.directions_bus_outlined),
  Cat('shop', 'Mua sắm', Icons.shopping_bag_outlined),
  Cat('home', 'Nhà cửa', Icons.home_outlined),
  Cat('bill', 'Hóa đơn', Icons.receipt_long_outlined),
  Cat('health', 'Sức khỏe', Icons.favorite_border),
  Cat('study', 'Học tập', Icons.menu_book_outlined),
  Cat('fun', 'Giải trí', Icons.movie_outlined),
  Cat('other', 'Khác', Icons.more_horiz),
  Cat('salary', 'Lương', Icons.account_balance_wallet_outlined, income: true),
  Cat('bonus', 'Thưởng', Icons.card_giftcard_outlined, income: true),
  Cat('in_other', 'Thu khác', Icons.add_circle_outline, income: true),
];

Cat catOf(String id) {
  return cats.firstWhere((c) => c.id == id, orElse: () => cats[8]);
}
