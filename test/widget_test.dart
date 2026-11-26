import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:athar/app.dart';

void main() {
  testWidgets('AtharApp loads selector buttons smoke test',
      (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      const ProviderScope(
        child: AtharApp(),
      ),
    );

    // Verify that the teacher dashboard shell renders.
    expect(find.byType(Scaffold), findsWidgets);
    expect(find.byType(BottomNavigationBar), findsOneWidget);
  });
}
