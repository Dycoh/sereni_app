// test/widget_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sereni_app/app/app.dart';

void main() {
  testWidgets('Initial app test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const SereniApp());

    // Add your widget tests here
    // For example:
    expect(find.byType(MaterialApp), findsOneWidget);
    // You can add more specific tests for your splash screen
    expect(find.text('Sereni'), findsOneWidget);
  });
}