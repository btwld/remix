import 'dart:ui' show Tristate;

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registry_source/fortal.dart';
import 'package:registry_source/heroui.dart';
import 'package:registry_source/vanilla.dart';

void main() {
  final presets = [
    (
      name: 'Vanilla',
      layout: VanillaSidebarLayout.new,
      theme: (Widget child) => VanillaTheme(child: child),
      open: (BuildContext context) =>
          VanillaSidebarLayoutScope.of(context).openCompact(),
    ),
    (
      name: 'Fortal',
      layout: FortalSidebarLayout.new,
      theme: (Widget child) => FortalTheme(child: child),
      open: (BuildContext context) =>
          FortalSidebarLayoutScope.of(context).openCompact(),
    ),
    (
      name: 'HeroUI',
      layout: HeroUiSidebarLayout.new,
      theme: (Widget child) => HeroUiTheme(child: child),
      open: (BuildContext context) =>
          HeroUiSidebarLayoutScope.of(context).openCompact(),
    ),
  ];

  for (final preset in presets) {
    testWidgets('${preset.name}: open sheet updates without losing focus', (
      tester,
    ) async {
      final host = ValueNotifier((label: 'Orders', selected: false));
      addTearDown(host.dispose);
      const itemKey = ValueKey('destination');

      await tester.pumpWidget(
        _app(
          theme: preset.theme,
          home: ValueListenableBuilder(
            valueListenable: host,
            builder: (context, state, _) => preset.layout(
              compactBreakpoint: 1000,
              compactOpen: true,
              sidebar: Focus(
                child: Semantics(
                  key: itemKey,
                  selected: state.selected,
                  child: Text(state.label),
                ),
              ),
              body: const Text('Body'),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final item = find.byKey(itemKey);
      final itemContext = tester.element(item);
      final focus = Focus.of(itemContext);
      final route = ModalRoute.of(itemContext);
      focus.requestFocus();
      await tester.pumpAndSettle();

      Tristate selected() => tester
          .getSemantics(item)
          .getSemanticsData()
          .flagsCollection
          .isSelected;

      expect(find.text('Orders'), findsOneWidget);
      expect(selected(), Tristate.isFalse);
      expect(FocusManager.instance.primaryFocus, same(focus));

      host.value = (label: 'All orders', selected: false);
      await tester.pumpAndSettle();
      expect(find.text('Orders'), findsNothing);
      expect(find.text('All orders'), findsOneWidget);
      expect(FocusManager.instance.primaryFocus, same(focus));

      host.value = (label: 'All orders', selected: true);
      await tester.pumpAndSettle();
      expect(selected(), Tristate.isTrue);
      expect(ModalRoute.of(tester.element(item)), same(route));
      expect(FocusManager.instance.primaryFocus, same(focus));
    });

    testWidgets(
      '${preset.name}: open sheet uses the latest width and pop policy',
      (tester) async {
        final controlled = ValueNotifier(false);
        addTearDown(controlled.dispose);
        final requests = <bool>[];
        const sidebar = SizedBox.expand(child: Text('Sidebar'));
        const body = Text('Body');

        await tester.pumpWidget(
          _app(
            theme: preset.theme,
            home: ValueListenableBuilder(
              valueListenable: controlled,
              builder: (context, value, _) => preset.layout(
                compactBreakpoint: 1000,
                compactOpen: value ? true : null,
                sidebarWidth: value ? 320 : 256,
                onCompactOpenChanged: requests.add,
                sidebar: sidebar,
                body: body,
              ),
            ),
          ),
        );
        preset.open(tester.element(find.byWidget(body)));
        await tester.pumpAndSettle();

        final sheet = find.byWidget(sidebar);
        expect(tester.getSize(sheet).width, 256);
        final route = ModalRoute.of(tester.element(sheet))!;
        expect(route.popDisposition, RoutePopDisposition.pop);

        controlled.value = true;
        await tester.pumpAndSettle();
        expect(ModalRoute.of(tester.element(sheet)), same(route));
        expect(
          (tester.getSize(sheet).width, route.popDisposition),
          (320, RoutePopDisposition.doNotPop),
        );
        expect(requests, [true]);

        await route.navigator!.maybePop();
        await tester.pumpAndSettle();
        expect(sheet, findsOneWidget);
        expect(requests, [true, false]);
      },
    );
  }
}

Widget _app({required Widget Function(Widget) theme, required Widget home}) =>
    WidgetsApp(
      color: const Color(0xFFFFFFFF),
      pageRouteBuilder: <T>(settings, builder) => PageRouteBuilder<T>(
        settings: settings,
        pageBuilder: (context, _, _) => builder(context),
      ),
      builder: (context, child) => theme(child!),
      home: home,
    );
