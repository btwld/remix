import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registry_source/src/heroui/components/sidebar_layout.dart';
import 'package:registry_source/src/heroui/theme/theme.dart';

import '../helpers/heroui.dart';

const _sidebarKey = ValueKey('sidebar');
const _bodyKey = ValueKey('body');
const _headerKey = ValueKey('header');

/// Pumps [layout] at [width] in a `WidgetsApp` whose builder installs
/// [HeroUiTheme] above the Navigator, so the compact sheet's route keeps the
/// theme and the given direction.
Future<void> _pump(
  WidgetTester tester,
  Widget layout, {
  required double width,
  String mode = 'light',
  TextDirection textDirection = TextDirection.ltr,
}) async {
  tester.view
    ..physicalSize = Size(width, 600)
    ..devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    WidgetsApp(
      color: const Color(0xFFFFFFFF),
      pageRouteBuilder: <T>(settings, builder) => PageRouteBuilder<T>(
        settings: settings,
        pageBuilder: (context, _, _) => builder(context),
      ),
      builder: (context, navigator) => Directionality(
        textDirection: textDirection,
        child: HeroUiTheme(
          mode: HeroUiThemeMode.values.byName(mode),
          child: navigator!,
        ),
      ),
      home: Align(
        alignment: Alignment.topLeft,
        child: SizedBox(width: width, height: 600, child: layout),
      ),
    ),
  );
}

Widget _layout({bool collapsed = false, bool? compactOpen}) =>
    HeroUiSidebarLayout(
      collapsed: collapsed,
      compactOpen: compactOpen,
      header: const SizedBox(key: _headerKey, height: 64),
      sidebar: const SizedBox(key: _sidebarKey, child: Text('Sidebar')),
      body: const SizedBox(key: _bodyKey, child: Text('Body')),
    );

void main() {
  testWidgets('the sidebar is inline at 720 and wider, a sheet below', (
    tester,
  ) async {
    await _pump(tester, _layout(), width: 900);
    expect(find.byKey(_sidebarKey), findsOneWidget);
    expect(find.byKey(_headerKey), findsOneWidget);

    await _pump(tester, _layout(), width: 375);
    expect(find.byKey(_sidebarKey), findsNothing);
    expect(find.byKey(_bodyKey), findsOneWidget);
    expect(find.byKey(_headerKey), findsOneWidget);
  });

  testWidgets('collapsed narrows the inline panel to the 72px rail', (
    tester,
  ) async {
    await _pump(tester, _layout(), width: 900);
    expect(tester.getSize(find.byKey(_sidebarKey)).width, 256);
    await _pump(tester, _layout(collapsed: true), width: 900);
    await tester.pumpAndSettle();
    expect(tester.getSize(find.byKey(_sidebarKey)).width, 72);
  });

  for (final mode in ['light', 'dark']) {
    testWidgets('the compact sheet uses background, separator and backdrop '
        'in $mode', (tester) async {
      await _pump(tester, _layout(compactOpen: true), width: 375, mode: mode);
      await tester.pumpAndSettle();

      final sidebar = find.byKey(_sidebarKey);
      expect(sidebar, findsOneWidget);
      // The edge paints over the panel, so the sidebar keeps 256.
      expect(tester.getSize(sidebar).width, 256);
      expect(tester.getTopLeft(sidebar).dx, 0);

      final route = ModalRoute.of(tester.element(sidebar))!;
      expect(route.barrierColor, heroUiToken(HeroUiTokens.backdrop, mode));

      final panel = tester
          .widgetList<Container>(
            find.ancestor(of: sidebar, matching: find.byType(Container)),
          )
          .map((container) => container.decoration)
          .whereType<BoxDecoration>()
          .firstWhere((decoration) => decoration.color != null);
      expect(panel.color, heroUiToken(HeroUiTokens.background, mode));
      final edge = tester
          .widgetList<Container>(
            find.ancestor(of: sidebar, matching: find.byType(Container)),
          )
          .map((container) => container.foregroundDecoration)
          .whereType<BoxDecoration>()
          .single;
      final border = edge.border! as BorderDirectional;
      expect(border.end.color, heroUiToken(HeroUiTokens.separator, mode));
      expect(border.end.width, 1);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('the scope opens the sheet; Escape and the scrim close it', (
    tester,
  ) async {
    await _pump(tester, _layout(), width: 375);
    HeroUiSidebarLayoutScope.of(
      tester.element(find.byKey(_bodyKey)),
    ).openCompact();
    await tester.pumpAndSettle();
    expect(find.byKey(_sidebarKey), findsOneWidget);
    expect(
      HeroUiSidebarLayoutScope.of(
        tester.element(find.byKey(_sidebarKey)),
      ).isCompactOpen,
      isTrue,
    );

    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pumpAndSettle();
    expect(find.byKey(_sidebarKey), findsNothing);

    HeroUiSidebarLayoutScope.of(
      tester.element(find.byKey(_bodyKey)),
    ).openCompact();
    await tester.pumpAndSettle();
    await tester.tapAt(const Offset(360, 300));
    await tester.pumpAndSettle();
    expect(find.byKey(_sidebarKey), findsNothing);
  });

  testWidgets('the compact sheet sits at the start edge in RTL', (
    tester,
  ) async {
    await _pump(
      tester,
      _layout(compactOpen: true),
      width: 375,
      textDirection: TextDirection.rtl,
    );
    await tester.pumpAndSettle();
    expect(tester.getTopRight(find.byKey(_sidebarKey)).dx, 375);
  });

  test('ships no Material import', () {
    expect(
      File('lib/src/heroui/components/sidebar_layout.dart').readAsStringSync(),
      isNot(contains('package:flutter/material.dart')),
    );
  });
}
