// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:naked_ui_example/main.dart';
import 'package:flutter/material.dart' show MaterialApp;
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('App loads and shows title', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the app title is shown.
    expect(find.text('Naked Kitchen Sink'), findsOneWidget);

    // Verify that the app loads without crashing, on a neutral host.
    // MaterialApp builds a WidgetsApp of its own, so finding one proves
    // nothing on its own; the absence of MaterialApp is the real assertion.
    expect(find.byType(WidgetsApp), findsOneWidget);
    expect(find.byType(MaterialApp), findsNothing);
  });
}
