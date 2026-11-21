import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registry_source/fortal.dart';
import 'package:registry_source/heroui.dart';
import 'package:registry_source/vanilla.dart';
import 'package:remix/remix.dart';

void main() {
  final presets = [
    (
      type: VanillaSidebarLayout,
      layout: VanillaSidebarLayout.new,
      theme: (Widget child) => VanillaTheme(child: child),
      maybeOf: VanillaSidebarLayoutScope.maybeOf,
      open: (BuildContext context) =>
          VanillaSidebarLayoutScope.of(context).openCompact,
      close: (BuildContext context) =>
          VanillaSidebarLayoutScope.of(context).closeCompact,
    ),
    (
      type: FortalSidebarLayout,
      layout: FortalSidebarLayout.new,
      theme: (Widget child) => FortalTheme(child: child),
      maybeOf: FortalSidebarLayoutScope.maybeOf,
      open: (BuildContext context) =>
          FortalSidebarLayoutScope.of(context).openCompact,
      close: (BuildContext context) =>
          FortalSidebarLayoutScope.of(context).closeCompact,
    ),
    (
      type: HeroUiSidebarLayout,
      layout: HeroUiSidebarLayout.new,
      theme: (Widget child) => HeroUiTheme(child: child),
      maybeOf: HeroUiSidebarLayoutScope.maybeOf,
      open: (BuildContext context) =>
          HeroUiSidebarLayoutScope.of(context).openCompact,
      close: (BuildContext context) =>
          HeroUiSidebarLayoutScope.of(context).closeCompact,
    ),
  ];

  for (final preset in presets) {
    testWidgets('${preset.type}: scope lookup ignores a nested raw layout', (
      tester,
    ) async {
      final outer = <bool>[];
      final inner = <bool>[];
      const header = Text('Outer header');
      const body = Text('Inner body');
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: preset.layout(
            sidebar: const SizedBox(),
            header: header,
            compactBreakpoint: 1000,
            compactOpen: false,
            onCompactOpenChanged: outer.add,
            body: RemixSidebarLayout(
              sidebar: const SizedBox(),
              body: body,
              compactBreakpoint: 1000,
              inlineWidth: 120,
              compactPanelBuilder: (context, child) => child,
              compactOpen: false,
              onCompactOpenChanged: inner.add,
            ),
          ),
        ),
      );

      preset.open(tester.element(find.byWidget(body)))();
      expect(outer, [true]);
      expect(inner, isEmpty);

      final context = tester.element(find.byWidget(header));
      expect(preset.maybeOf(context), isNotNull);
      for (final other in presets.where((other) => other.type != preset.type)) {
        expect(other.maybeOf(context), isNull);
        expect(
          () => other.open(context)(),
          throwsA(
            isA<FlutterError>().having(
              (error) => error.toString(),
              'message',
              '${other.type}Scope.of requires a ${other.type} ancestor.',
            ),
          ),
        );
      }
    });

    testWidgets('${preset.type}: controlled close is delivered while wide', (
      tester,
    ) async {
      final changes = <bool>[];
      const sidebar = Text('Inline sidebar');
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: preset.layout(
            sidebar: sidebar,
            body: const SizedBox(),
            compactBreakpoint: 400,
            compactOpen: true,
            onCompactOpenChanged: changes.add,
          ),
        ),
      );

      preset.close(tester.element(find.byWidget(sidebar)))();
      expect(changes, [false]);
    });

    const sidebar = Text('Navigation links');
    const compact = Size(480, 600);
    const wide = Size(1000, 600);
    Future<void> pumpWindow(
      WidgetTester tester,
      Size size,
      ValueChanged<bool> onChanged, {
      bool? compactOpen,
    }) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = size;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(
        WidgetsApp(
          color: const Color(0xFFFFFFFF),
          pageRouteBuilder: <T>(settings, builder) => PageRouteBuilder<T>(
            settings: settings,
            pageBuilder: (context, _, _) => builder(context),
          ),
          builder: (context, child) => preset.theme(child!),
          home: preset.layout(
            sidebar: sidebar,
            body: const SizedBox(),
            compactOpen: compactOpen,
            onCompactOpenChanged: onChanged,
          ),
        ),
      );
      await tester.pumpAndSettle();
    }

    testWidgets('${preset.type}: saved compact close after resizing to wide', (
      tester,
    ) async {
      final changes = <bool>[];
      await pumpWindow(tester, compact, changes.add, compactOpen: true);
      final close = preset.close(tester.element(find.byWidget(sidebar)));

      tester.view.physicalSize = wide;
      await tester.pumpAndSettle();
      changes.clear();
      close();
      expect(changes, [false]);
    });

    testWidgets(
      '${preset.type}: saved wide controls after resizing to compact',
      (tester) async {
        final changes = <bool>[];
        await pumpWindow(tester, wide, changes.add);
        final context = tester.element(find.byWidget(sidebar));
        final open = preset.open(context);
        final close = preset.close(context);

        tester.view.physicalSize = compact;
        await tester.pumpAndSettle();
        expect(find.byWidget(sidebar), findsNothing);
        open();
        await tester.pumpAndSettle();
        expect(find.byWidget(sidebar), findsOneWidget);
        close();
        await tester.pumpAndSettle();
        expect(find.byWidget(sidebar), findsNothing);
        expect(changes, [true, false]);
      },
    );
  }
}
