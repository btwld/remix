import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/remix.dart';
import 'package:registry_source/fortal.dart';

import '../../helpers/pixels.dart';
import '../../helpers/test_helpers.dart';

const _sections = <RemixSidebarSection<String>>[
  RemixSidebarSection(
    label: 'Workspace',
    destinations: [
      RemixSidebarDestination(
        value: 'overview',
        label: 'Overview',
        icon: Icons.space_dashboard_outlined,
      ),
      RemixSidebarDestination(
        value: 'customers',
        label: 'Customers',
        icon: Icons.people_outline,
      ),
    ],
  ),
];

void main() {
  test('Fortal recipe exposes the dashboard navigation metrics', () {
    final style = fortalSidebarStyle();

    expect(style, isA<SidebarStyler>());
    expect(style.$container, isNotNull);
    expect(style.$content, isNotNull);
    expect(style.$footer, isNotNull);
    expect(style.$sectionLabel, isNotNull);
    expect(style.$destinations, isNotNull);
    expect(style.$destination, isNotNull);

    // Width and header padding belong to the host, not to the recipe.
    expect(style.$header, isNull);
  });

  testWidgets('recipe paints the panel surface and the footer divider', (
    tester,
  ) async {
    const panelPadding = EdgeInsets.fromLTRB(1, 2, 3, 4);
    await tester.pumpRemixApp(
      SizedBox(
        height: 400,
        width: 256,
        child: FortalSidebar<String>(
          panelPadding: panelPadding,
          header: const Text('Acme'),
          sections: _sections,
          selectedValue: 'overview',
          onSelected: (_) {},
          footer: const Text('Account'),
        ),
      ),
    );

    final spec = tester.resolvedSpecOf<SidebarSpec>(find.text('Overview'));
    final panel = spec.container.spec.box?.spec.decoration as BoxDecoration?;
    expect(panel?.color, isNotNull);
    expect(panel?.border, isA<BorderDirectional>());
    expect((panel?.border as BorderDirectional?)?.end.width, greaterThan(0));
    expect(spec.container.spec.box?.spec.padding, panelPadding);

    final footer = spec.footer.spec.decoration as BoxDecoration?;
    expect((footer?.border as Border?)?.top.width, greaterThan(0));

    // The recipe pads the scrolling region rather than the panel.
    expect(spec.content.spec.box?.spec.padding, isNotNull);
  });

  testWidgets('generated wrapper preserves generic navigation inputs', (
    tester,
  ) async {
    String? selected;
    await tester.pumpRemixApp(
      FortalSidebar<String>(
        sections: _sections,
        selectedValue: 'overview',
        onSelected: (value) => selected = value,
        semanticLabel: 'Primary navigation',
      ),
    );

    expect(find.byType(RemixSidebar<String>), findsOneWidget);
    expect(find.text('WORKSPACE'), findsOneWidget);

    await tester.tap(find.text('Customers'));
    await tester.pump();
    expect(selected, 'customers');
  });

  testWidgets('recipe uses ghost size2 content in 48-high full-width rows', (
    tester,
  ) async {
    await tester.pumpRemixApp(
      FortalSidebar<String>(
        sections: _sections,
        selectedValue: 'overview',
        onSelected: (_) {},
      ),
    );

    final selected = tester.resolvedSpecOf<ToggleSpec>(find.text('Overview'));
    final idle = tester.resolvedSpecOf<ToggleSpec>(find.text('Customers'));
    final selectedBox = selected.container.spec.box?.spec;
    final selectedFlex = selected.container.spec.flex?.spec;

    // The wider leading inset keeps icons still when the panel collapses.
    expect(selectedBox?.padding, const EdgeInsets.fromLTRB(16, 8, 12, 8));
    expect(selectedBox?.constraints?.minHeight, 48);
    expect(selectedFlex?.spacing, 4);
    expect(selectedFlex?.mainAxisSize, MainAxisSize.max);
    expect(selectedFlex?.mainAxisAlignment, MainAxisAlignment.start);
    expect(
      selectedBox?.decoration,
      isA<BoxDecoration>().having(
        (decoration) => decoration.color,
        'selected color',
        isNot(
          equals(
            (idle.container.spec.box?.spec.decoration as BoxDecoration?)?.color,
          ),
        ),
      ),
    );
    expect(selected.label.spec.style?.fontSize, 14);
    expect(selected.icon.spec.size, 16);
  });

  testWidgets('destination rows meet mobile tap-target guidelines', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();

    await tester.pumpRemixApp(
      SizedBox(
        width: 256,
        child: FortalSidebar<String>(
          sections: _sections,
          selectedValue: 'overview',
          onSelected: (_) {},
        ),
      ),
    );

    expect(
      tester.getSize(find.bySemanticsLabel('Overview')).height,
      greaterThanOrEqualTo(48),
    );
    await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
    await expectLater(tester, meetsGuideline(iOSTapTargetGuideline));
    await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
    semantics.dispose();
  });

  group('keyboard focus on a destination', () {
    late FocusHighlightStrategy previousStrategy;

    setUp(() {
      previousStrategy = FocusManager.instance.highlightStrategy;
      FocusManager.instance.highlightStrategy =
          FocusHighlightStrategy.alwaysTraditional;
    });

    tearDown(() => FocusManager.instance.highlightStrategy = previousStrategy);

    // The sidebar is shorter than its destinations, so reaching the fifth one
    // scrolls it flush against the edge of the scroll region.
    const labels = [
      'Home',
      'Customers',
      'Orders',
      'Reports',
      'Billing',
      'Team',
      'Logs',
      'Settings',
    ];
    const target = 'Billing';

    for (final mode in [FortalThemeMode.light, FortalThemeMode.dark]) {
      for (final collapsed in [false, true]) {
        testWidgets(
          'rings the destination without moving its content in ${mode.name}, '
          '${collapsed ? 'collapsed' : 'expanded'}',
          (tester) async {
            final semantics = tester.ensureSemantics();
            final boundary = GlobalKey();
            await tester.pumpRemixApp(
              FortalTheme(
                mode: mode,
                child: RepaintBoundary(
                  key: boundary,
                  child: ColoredBox(
                    color: mode == .dark
                        ? const Color(0xFF000000)
                        : const Color(0xFFFFFFFF),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: SizedBox(
                        width: collapsed ? 72 : 256,
                        height: 220,
                        child: FortalSidebar<String>(
                          collapsed: collapsed,
                          animationStyle: AnimationStyle.noAnimation,
                          selectedValue: 'Home',
                          onSelected: (_) {},
                          sections: [
                            RemixSidebarSection(
                              destinations: [
                                for (final label in labels)
                                  RemixSidebarDestination(
                                    value: label,
                                    label: label,
                                    icon: label == target
                                        ? Icons.star_outline
                                        : Icons.circle_outlined,
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
            final idleSize = tester.getSize(find.bySemanticsLabel(target));

            for (var i = 0; i <= labels.indexOf(target); i++) {
              await tester.sendKeyEvent(LogicalKeyboardKey.tab);
            }
            await tester.pumpAndSettle();
            final scroll = tester.state<ScrollableState>(
              find.descendant(
                of: find.byType(FortalSidebar<String>),
                matching: find.byType(Scrollable),
              ),
            );
            expect(scroll.position.pixels, greaterThan(0));
            final destination = tester.getRect(find.bySemanticsLabel(target));
            final focusedIcon =
                tester.getTopLeft(find.byIcon(Icons.star_outline)) -
                destination.topLeft;
            final focused = await capturePixels(tester, boundary);
            final ring = MixScope.tokenOf(
              FortalTokens.focusA8,
              tester.element(find.bySemanticsLabel(target)),
            );

            FocusManager.instance.primaryFocus!.unfocus();
            await tester.pumpAndSettle();
            final idle = await capturePixels(tester, boundary);

            expect(tester.getRect(find.bySemanticsLabel(target)), destination);
            expect(destination.size, idleSize);
            expect(
              tester.getTopLeft(find.byIcon(Icons.star_outline)) -
                  destination.topLeft,
              focusedIcon,
            );

            // Each probe is the middle of an edge, `inside` logical pixels in
            // from it: the 2px ring covers 1, the destination past it starts at
            // 3, and -1 is outside the destination.
            final origin = tester.getTopLeft(find.byKey(boundary));
            Color pixel(Pixels pixels, Offset logical) {
              final device = (logical - origin) * pixelScale.toDouble();
              return pixels.at(device.dx.round(), device.dy.round());
            }

            for (final at in <Offset Function(double inside)>[
              (inside) =>
                  Offset(destination.center.dx, destination.top + inside),
              (inside) =>
                  Offset(destination.center.dx, destination.bottom - inside),
              (inside) =>
                  Offset(destination.left + inside, destination.center.dy),
              (inside) =>
                  Offset(destination.right - inside, destination.center.dy),
            ]) {
              expectNearColor(
                pixel(focused, at(1)),
                Color.alphaBlend(ring, pixel(idle, at(1))),
              );
              expectNearColor(pixel(focused, at(3)), pixel(idle, at(3)));
              expectNearColor(pixel(focused, at(-1)), pixel(idle, at(-1)));
            }
            semantics.dispose();
          },
        );
      }
    }
  });

  testWidgets('high contrast keeps selected content distinct', (tester) async {
    Future<Color?> selectedLabelColor(bool highContrast) async {
      await tester.pumpRemixApp(
        FortalSidebar<String>(
          sections: _sections,
          selectedValue: 'overview',
          onSelected: (_) {},
          highContrast: highContrast,
        ),
      );
      return tester
          .resolvedSpecOf<ToggleSpec>(find.text('Overview'))
          .label
          .spec
          .style
          ?.color;
    }

    final normal = await selectedLabelColor(false);
    final highContrast = await selectedLabelColor(true);

    expect(normal, isNotNull);
    expect(highContrast, isNotNull);
    expect(highContrast, isNot(normal));
  });
}
