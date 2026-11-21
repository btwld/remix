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
      maybeOf: VanillaSidebarLayoutScope.maybeOf,
      open: (BuildContext context) =>
          VanillaSidebarLayoutScope.of(context).openCompact(),
      close: (BuildContext context) =>
          VanillaSidebarLayoutScope.of(context).closeCompact(),
    ),
    (
      type: FortalSidebarLayout,
      layout: FortalSidebarLayout.new,
      maybeOf: FortalSidebarLayoutScope.maybeOf,
      open: (BuildContext context) =>
          FortalSidebarLayoutScope.of(context).openCompact(),
      close: (BuildContext context) =>
          FortalSidebarLayoutScope.of(context).closeCompact(),
    ),
    (
      type: HeroUiSidebarLayout,
      layout: HeroUiSidebarLayout.new,
      maybeOf: HeroUiSidebarLayoutScope.maybeOf,
      open: (BuildContext context) =>
          HeroUiSidebarLayoutScope.of(context).openCompact(),
      close: (BuildContext context) =>
          HeroUiSidebarLayoutScope.of(context).closeCompact(),
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

      preset.open(tester.element(find.byWidget(body)));
      expect(outer, [true]);
      expect(inner, isEmpty);

      final context = tester.element(find.byWidget(header));
      expect(preset.maybeOf(context), isNotNull);
      for (final other in presets.where((other) => other.type != preset.type)) {
        expect(other.maybeOf(context), isNull);
        expect(
          () => other.open(context),
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

      preset.close(tester.element(find.byWidget(sidebar)));
      expect(changes, [false]);
    });
  }
}
