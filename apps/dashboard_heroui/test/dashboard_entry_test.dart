import 'package:dashboard_heroui/main.dart';
import 'package:dashboard_heroui/ui/ui.dart';
import 'package:flutter/material.dart' show MaterialApp;
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix_chart/mix_chart.dart';
import 'package:remix_ui_fonts/remix_ui_fonts.dart';

void main() {
  testWidgets('the app mounts the HeroUI dashboard demo under WidgetsApp', (
    tester,
  ) async {
    _size(tester, const Size(1440, 1000));

    await tester.pumpWidget(const DashboardHeroUiApp());
    await tester.pump();

    expect(find.byType(WidgetsApp), findsOneWidget);
    expect(find.byType(MaterialApp), findsNothing);
    expect(find.byType(UiDashboardDemo), findsOneWidget);
    expect(find.text('Revenue trend'), findsOneWidget);
    expect(find.text('Recent orders'), findsOneWidget);
    expect(find.text('ORD-1048'), findsOneWidget);
    expect(find.text('Northstar workspace'), findsOneWidget);
    expect(find.byType(LineChart), findsOneWidget);
    expect(find.byType(BarChart), findsOneWidget);
    expect(find.byType(PieChart), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('every destination opens from the sidebar', (tester) async {
    _size(tester, const Size(1440, 1000));
    await tester.pumpWidget(const DashboardHeroUiApp());
    await tester.pump();

    for (final (destination, text) in const [
      ('Chat', 'Agent chat'),
      ('Customers', 'Search customers…'),
      ('Orders', 'Refunded'),
      ('Settings', 'Danger zone'),
      ('Overview', 'Revenue trend'),
    ]) {
      await tester.tap(find.text(destination).first);
      await tester.pump(const Duration(milliseconds: 400));
      expect(find.text(text), findsWidgets, reason: destination);
    }
    expect(tester.takeException(), isNull);
  });

  testWidgets('the appearance toggle switches to the dark theme', (
    tester,
  ) async {
    _size(tester, const Size(1440, 1000));
    await tester.pumpWidget(const DashboardHeroUiApp());
    await tester.pump();

    UiThemeData theme() =>
        UiTheme.of(tester.element(find.text('Revenue trend')));
    expect(theme().brightness, Brightness.light);
    expect(theme().fontFamily, lightTheme.fontFamily);

    await tester.tap(
      find.byKey(const ValueKey('dashboard-appearance-toggle')).first,
    );
    await tester.pump();
    expect(theme().brightness, Brightness.dark);
    expect(theme().fontFamily, darkTheme.fontFamily);
    expect(find.bySemanticsLabel('Use light appearance'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('a phone width opens the navigation sheet', (tester) async {
    _size(tester, const Size(390, 844));
    await tester.pumpWidget(const DashboardHeroUiApp());
    await tester.pump();

    expect(find.byKey(const ValueKey('dashboard-menu')), findsWidgets);
    await tester.tap(find.byKey(const ValueKey('dashboard-menu')).first);
    for (var frame = 0; frame < 5; frame++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
    expect(find.byKey(const ValueKey('dashboard-sidebar')), findsWidgets);
    expect(tester.takeException(), isNull);
  });

  testWidgets('the Agent chat runs its local scenario', (tester) async {
    _size(tester, const Size(1440, 1000));
    await tester.pumpWidget(const DashboardHeroUiApp());
    await tester.pump();

    await tester.tap(find.text('Chat').first);
    await tester.pump();
    await tester.tap(find.text('Review checkout'));
    for (var frame = 0; frame < 40; frame++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
    expect(find.textContaining('ready for review'), findsWidgets);
    expect(find.byType(UiAnswer), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  test('the theme is the stock HeroUI template with the Geist face', () {
    // The app declares no theme edit: tool/check_consumer_apps.dart holds
    // the installed theme to the template, and only the family is chosen.
    expect(lightTheme.brightness, Brightness.light);
    expect(darkTheme.brightness, Brightness.dark);
    expect(lightTheme.fontFamily, RemixFonts.geist);
    expect(darkTheme.fontFamily, RemixFonts.geist);
    for (final (themed, stock) in const [
      (lightTheme, UiThemeData.light()),
      (darkTheme, UiThemeData.dark()),
    ]) {
      expect(themed.radius, stock.radius);
      for (final token in [UiTokens.accent, UiTokens.background]) {
        expect(themed.tokens[token], stock.tokens[token], reason: token.name);
      }
    }
  });
}

void _size(WidgetTester tester, Size size) {
  tester.view
    ..physicalSize = size
    ..devicePixelRatio = 1;
  addTearDown(tester.view.reset);
}
