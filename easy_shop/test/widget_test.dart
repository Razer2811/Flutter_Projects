// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:easy_shop/main.dart';

void main() {
  testWidgets('displays the shop home screen', (WidgetTester tester) async {
    await tester.pumpWidget(const EasyShopApp());

    expect(find.text('ShopEasy'), findsOneWidget);
    expect(find.text('Tìm sản phẩm...'), findsOneWidget);
    expect(find.text('Tất cả'), findsOneWidget);
    expect(find.text('Điện thoại'), findsOneWidget);
    expect(find.text('Laptop'), findsOneWidget);
  });
}
