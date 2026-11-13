import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:kientragiuaky/main.dart';

void main() {
  testWidgets('renders the expense dashboard', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: DashboardScreen(loadFromDatabase: false)),
    );

    expect(find.text('Số dư hiện tại'), findsOneWidget);
    expect(find.byIcon(Icons.add), findsOneWidget);
  });
}
