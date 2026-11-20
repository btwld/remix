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
    testWidgets(
      '${preset.name}: a queued keyed sheet update followed by resize',
      (tester) async {
        final rebuilt = ValueNotifier(false);
        final width = ValueNotifier(500.0);
        addTearDown(rebuilt.dispose);
        addTearDown(width.dispose);
        final sidebarKey = GlobalKey();
        const body = Text('Body');
        await tester.pumpWidget(
          _app(
            theme: preset.theme,
            home: Align(
              alignment: Alignment.topLeft,
              child: ValueListenableBuilder(
                valueListenable: width,
                child: ValueListenableBuilder(
                  valueListenable: rebuilt,
                  builder: (context, value, _) => preset.layout(
                    compactBreakpoint: 650,
                    sidebar: value
                        ? Text('Updated sidebar', key: sidebarKey)
                        : const Text('Original sidebar'),
                    body: body,
                  ),
                ),
                builder: (context, value, child) =>
                    SizedBox(width: value, height: 500, child: child),
              ),
            ),
          ),
        );
        preset.open(tester.element(find.byWidget(body)));
        await tester.pumpAndSettle();

        rebuilt.value = true;
        await tester.pump();
        expect(find.text('Original sidebar'), findsOneWidget);
        width.value = 750;
        await tester.pump();
        expect(tester.takeException(), isNull);
        await tester.pumpAndSettle();
        final updated = find.byKey(sidebarKey);
        expect(updated, findsOneWidget);
        expect(
          ModalRoute.of(tester.element(updated)),
          same(ModalRoute.of(tester.element(find.byWidget(body)))),
        );
      },
    );

    testWidgets(
      '${preset.name}: rapid reopen with a shared key waits for the exit',
      (tester) async {
        final rebuilt = ValueNotifier(false);
        addTearDown(rebuilt.dispose);
        final sidebarKey = GlobalKey();
        const body = Text('Body');
        await tester.pumpWidget(
          _app(
            theme: preset.theme,
            home: ValueListenableBuilder(
              valueListenable: rebuilt,
              builder: (context, value, _) => preset.layout(
                compactBreakpoint: 1000,
                sidebar: Center(
                  child: Text(value ? 'Updated' : 'Original', key: sidebarKey),
                ),
                body: body,
              ),
            ),
          ),
        );
        final bodyContext = tester.element(find.byWidget(body));
        preset.open(bodyContext);
        await tester.pumpAndSettle();
        final sidebar = find.byKey(sidebarKey, skipOffstage: false);
        final exitingRoute = ModalRoute.of(tester.element(sidebar))!;
        exitingRoute.navigator!.pop();
        await tester.pump();
        preset.open(bodyContext);
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 50));
        expect(tester.takeException(), isNull);
        expect(ModalRoute.of(tester.element(sidebar)), same(exitingRoute));

        rebuilt.value = true;
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 50));
        expect(tester.takeException(), isNull);
        expect(tester.widget<Text>(sidebar).data, 'Original');

        await tester.pumpAndSettle();
        expect(
          ModalRoute.of(tester.element(sidebar)),
          isNot(same(exitingRoute)),
        );
        expect(tester.widget<Text>(sidebar).data, 'Updated');
      },
    );

    for (final popBeforePublish in [true, false]) {
      testWidgets(
        '${preset.name}: a same-frame pop freezes the exiting sheet (before publish: $popBeforePublish)',
        (tester) async {
          final rebuilt = ValueNotifier(false);
          addTearDown(rebuilt.dispose);
          final sidebarKey = GlobalKey();
          const body = Text('Body');
          ModalRoute<dynamic>? exitingRoute;
          void popAfterFrame() {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              exitingRoute!.navigator!.pop();
            });
          }

          await tester.pumpWidget(
            _app(
              theme: preset.theme,
              home: ValueListenableBuilder(
                valueListenable: rebuilt,
                builder: (context, value, _) => preset.layout(
                  compactBreakpoint: 1000,
                  sidebar: value
                      ? Text('Updated sidebar', key: sidebarKey)
                      : const Text('Original sidebar'),
                  body: Builder(
                    builder: (context) {
                      if (value && !popBeforePublish) popAfterFrame();
                      return body;
                    },
                  ),
                ),
              ),
            ),
          );
          final bodyContext = tester.element(find.byWidget(body));
          preset.open(bodyContext);
          await tester.pumpAndSettle();

          final original = find.text('Original sidebar', skipOffstage: false);
          exitingRoute = ModalRoute.of(tester.element(original))!;
          if (popBeforePublish) popAfterFrame();
          rebuilt.value = true;
          await tester.pump();
          expect(exitingRoute.isActive, isFalse);

          preset.open(bodyContext);
          await tester.pump();
          await tester.pump(const Duration(milliseconds: 50));
          expect(tester.takeException(), isNull);
          expect(ModalRoute.of(tester.element(original)), same(exitingRoute));
          final updated = find.byKey(sidebarKey, skipOffstage: false);
          expect(updated, findsNothing);
          await tester.pumpAndSettle();
          expect(original, findsNothing);
          expect(
            ModalRoute.of(tester.element(updated)),
            isNot(same(exitingRoute)),
          );
        },
      );
    }

    testWidgets('${preset.name}: open sheet updates without losing focus', (
      tester,
    ) async {
      final host = ValueNotifier(false);
      addTearDown(host.dispose);
      const itemKey = ValueKey('destination');

      await tester.pumpWidget(
        _app(
          theme: preset.theme,
          home: ValueListenableBuilder(
            valueListenable: host,
            builder: (context, selected, _) => preset.layout(
              compactBreakpoint: 1000,
              compactOpen: true,
              sidebar: Focus(
                child: Semantics(
                  key: itemKey,
                  selected: selected,
                  child: Text(selected ? 'All orders' : 'Orders'),
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

      host.value = true;
      await tester.pumpAndSettle();
      expect(find.text('Orders'), findsNothing);
      expect(find.text('All orders'), findsOneWidget);
      expect(selected(), Tristate.isTrue);
      expect(ModalRoute.of(tester.element(item)), same(route));
      expect(FocusManager.instance.primaryFocus, same(focus));
    });

    testWidgets(
      '${preset.name}: open sheet uses the latest width and pop policy',
      (tester) async {
        final controlled = ValueNotifier(false);
        addTearDown(controlled.dispose);
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
        expect(
          (tester.getSize(sheet).width, route.popDisposition),
          (320, RoutePopDisposition.doNotPop),
        );
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
