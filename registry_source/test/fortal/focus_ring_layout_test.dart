import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registry_source/fortal.dart';
import 'package:remix/remix.dart';
// `RemixFlexBoxAdapter` and `RemixBoxAdapter` are `@internal` to `remix`, but
// this sibling package's tests need them to find the box a ring is drawn
// around. Suppressed per use below.
import 'package:remix/src/rendering/remix_box_effects.dart';

import '../helpers/pixels.dart';
import '../helpers/test_helpers.dart';

/// A part whose focus ring is a CSS-style outline: it paints over the part's
/// box and takes no layout space. [box] is the box the ring is drawn around.
typedef _Part = ({
  String name,
  Widget Function() build,
  Finder root,
  Finder box,
});

final _parts = <_Part>[
  (
    name: 'ghost toggle',
    build: () =>
        FortalToggle.ghost(selected: false, onChanged: (_) {}, label: 'Bold'),
    root: find.byType(FortalToggle),
    // ignore: invalid_use_of_internal_member
    box: find.byType(RemixFlexBoxAdapter),
  ),
  (
    name: 'outline toggle',
    build: () =>
        FortalToggle.outline(selected: false, onChanged: (_) {}, label: 'Bold'),
    root: find.byType(FortalToggle),
    // ignore: invalid_use_of_internal_member
    box: find.byType(RemixFlexBoxAdapter),
  ),
  (
    name: 'toggle group end item',
    build: () => FortalToggleGroup<String>(
      selectedValue: 'list',
      onChanged: (_) {},
      items: const [
        RemixToggleGroupItem(value: 'list', label: 'List'),
        RemixToggleGroupItem(value: 'grid', label: 'Grid'),
      ],
    ),
    root: find.byType(FortalToggleGroup<String>),
    // ignore: invalid_use_of_internal_member
    box: find.byType(RemixFlexBoxAdapter).first,
  ),
  (
    name: 'tab',
    build: () => RemixTabs(
      selectedTabId: 'b',
      onChanged: (_) {},
      child: const FortalTabBar(
        child: Row(
          children: [FortalTab(tabId: 'a', label: 'Account')],
        ),
      ),
    ),
    root: find.byType(FortalTab),
    // ignore: invalid_use_of_internal_member
    box: find.byType(RemixFlexBoxAdapter),
  ),
  (
    name: 'disclosure trigger',
    build: () => const FortalDisclosure(
      defaultExpanded: true,
      trigger: Text('Details'),
      content: Text('Panel content'),
    ),
    root: find.byType(FortalDisclosure),
    box: find.descendant(
      // ignore: invalid_use_of_internal_member
      of: find.byType(RemixBoxAdapter).first,
      // ignore: invalid_use_of_internal_member
      matching: find.byType(RemixBoxAdapter),
    ),
  ),
  (
    name: 'accordion trigger',
    build: () => RemixAccordionGroup<String>(
      controller: RemixAccordionController<String>(),
      initialExpandedValues: const ['a'],
      child: const FortalAccordion<String>(
        value: 'a',
        title: 'Details',
        child: Text('Panel content'),
      ),
    ),
    root: find.byType(FortalAccordion<String>),
    // ignore: invalid_use_of_internal_member
    box: find.byType(RemixFlexBoxAdapter),
  ),
];

void main() {
  late FocusHighlightStrategy previousStrategy;

  setUp(() {
    previousStrategy = FocusManager.instance.highlightStrategy;
    FocusManager.instance.highlightStrategy =
        FocusHighlightStrategy.alwaysTraditional;
  });

  tearDown(() => FocusManager.instance.highlightStrategy = previousStrategy);

  Future<void> pumpPart(
    WidgetTester tester,
    _Part part, {
    GlobalKey? boundary,
    FortalThemeMode mode = .light,
    Map<SpaceToken, double>? ringTokens,
  }) async {
    await tester.pumpRemixApp(
      FortalTheme(
        mode: mode,
        child: MixScope.inherit(
          spaces: ringTokens,
          child: RepaintBoundary(
            key: boundary,
            child: ColoredBox(
              color: mode == .dark
                  ? const Color(0xFF000000)
                  : const Color(0xFFFFFFFF),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: part.build(),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<void> focusWithKeyboard(WidgetTester tester) async {
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pumpAndSettle();
  }

  for (final part in _parts) {
    for (final (width, ringTokens) in [
      (2.0, null),
      (3.5, {FortalTokens.focusRingWidth: 3.5}),
    ]) {
      testWidgets(
        '${part.name} keeps its size when it takes focus at ring width $width',
        (tester) async {
          await pumpPart(tester, part, ringTokens: ringTokens);
          final idleRoot = tester.getSize(part.root);
          final idleBox = tester.getSize(part.box);

          await focusWithKeyboard(tester);

          expect(tester.getSize(part.root), idleRoot);
          expect(tester.getSize(part.box), idleBox);
        },
      );
    }

    for (final mode in [FortalThemeMode.light, FortalThemeMode.dark]) {
      testWidgets(
        '${part.name} paints its ring outside its box in ${mode.name}',
        (tester) async {
          final boundary = GlobalKey();
          await pumpPart(tester, part, boundary: boundary, mode: mode);
          final idle = await capturePixels(tester, boundary);
          final box = tester.getRect(part.box);

          await focusWithKeyboard(tester);
          final focused = await capturePixels(tester, boundary);
          final ring = MixScope.tokenOf(
            FortalTokens.focus8,
            tester.element(part.box),
          );

          // The common token ring sits 2px outside the box and is 2px wide.
          final origin = tester.getTopLeft(find.byKey(boundary));
          final edges = <Offset Function(double inside)>[
            (inside) => Offset(box.center.dx, box.top + inside),
            (inside) => Offset(box.center.dx, box.bottom - inside),
            (inside) => Offset(box.left + inside, box.center.dy),
            (inside) => Offset(box.right - inside, box.center.dy),
          ];
          Color pixel(Pixels pixels, Offset logical) {
            final device = (logical - origin) * pixelScale.toDouble();
            return pixels.at(device.dx.round(), device.dy.round());
          }

          for (final at in edges) {
            expectNearColor(pixel(focused, at(-3)), ring);
            expectNearColor(pixel(focused, at(1)), pixel(idle, at(1)));
            expectNearColor(pixel(focused, at(-1)), pixel(idle, at(-1)));
          }
        },
      );
    }
  }
}
