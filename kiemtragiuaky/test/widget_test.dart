import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:kiemtragiuaky/main.dart';

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  testWidgets('shows the MoneyFlow dashboard', (WidgetTester tester) async {
    await tester.pumpWidget(const MoneyFlowApp());

    expect(find.text('MoneyFlow'), findsOneWidget);
    expect(find.text('Tổng số dư'), findsOneWidget);
    expect(find.text('Giao dịch gần đây'), findsOneWidget);
  });
}
