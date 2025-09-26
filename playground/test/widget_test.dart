import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:playground/routes/playground_home.dart';

void main() {
  testWidgets('PlaygroundHome displays component list', (WidgetTester tester) async {
    // Build the PlaygroundHome widget
    await tester.pumpWidget(const MaterialApp(home: PlaygroundHome()));

    // Verify app bar is displayed
    expect(find.text('Remix Playground'), findsOneWidget);
    expect(find.byType(AppBar), findsOneWidget);

    // Verify component list is displayed
    expect(find.byType(ListView), findsOneWidget);
    expect(find.byType(ListTile), findsWidgets);

    // Verify some key components are in the list
    expect(find.text('avatar'), findsOneWidget);
    expect(find.text('button'), findsOneWidget);
    expect(find.text('card'), findsOneWidget);

    // Verify chevron icons are present for navigation
    expect(find.byIcon(Icons.chevron_right), findsWidgets);
  });

  testWidgets('PlaygroundHome list tiles are tappable', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: PlaygroundHome()));

    // Find a list tile and verify it can be tapped
    final listTiles = find.byType(ListTile);
    expect(listTiles, findsWidgets);

    // Verify list tiles have onTap callbacks
    final firstTile = tester.widget<ListTile>(listTiles.first);
    expect(firstTile.onTap, isNotNull);
  });
}
