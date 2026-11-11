import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registry_source/src/heroui/components/sidebar.dart';
import 'package:registry_source/src/heroui/theme/theme.dart';
import 'package:remix/remix.dart';

import '../helpers/heroui.dart';
import '../helpers/pixels.dart';

const _overviewIcon = IconData(0xe000, fontFamily: 'Ahem');
const _reportsIcon = IconData(0xe001, fontFamily: 'Ahem');
const _modes = ['light', 'dark'];

const _sections = <RemixSidebarSection<String>>[
  RemixSidebarSection(
    label: 'Workspace',
    destinations: [
      RemixSidebarDestination(
        value: 'overview',
        label: 'Overview',
        icon: _overviewIcon,
      ),
      RemixSidebarDestination(
        value: 'reports',
        label: 'Reports',
        icon: _reportsIcon,
      ),
    ],
  ),
];

Widget _sidebar({
  bool collapsed = false,
  ValueChanged<String>? onSelected,
  double width = 256,
}) => SizedBox(
  width: width,
  height: 400,
  child: HeroUiSidebar<String>(
    collapsed: collapsed,
    animationStyle: AnimationStyle.noAnimation,
    header: const Text('Acme'),
    sections: _sections,
    selectedValue: 'overview',
    onSelected: onSelected ?? (_) {},
    footer: const Text('Account'),
  ),
);

ToggleSpec _destination(WidgetTester tester, String label) =>
    tester.resolvedSpecOf<ToggleSpec>(find.text(label));

Color? _fill(ToggleSpec spec) =>
    (spec.container.spec.boxSpec.decoration as BoxDecoration?)?.color;

void main() {
  for (final mode in _modes) {
    for (final width in [1024, 375]) {
      testWidgets('the panel and its rows use the theme in $mode at $width', (
        tester,
      ) async {
        await tester.pumpHeroUi(_sidebar(), mode: mode, width: width * 1.0);
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);

        final spec = tester.resolvedSpecOf<SidebarSpec>(find.text('Overview'));
        final panel = spec.container.spec.boxSpec.decoration! as BoxDecoration;
        // `background` with a 1px `separator` end edge.
        expect(panel.color, heroUiToken(HeroUiTokens.background, mode));
        final edge = (panel.border! as BorderDirectional).end;
        expect(edge.color, heroUiToken(HeroUiTokens.separator, mode));
        expect(edge.width, 1);
        final footer = spec.footer.spec.decoration! as BoxDecoration;
        expect(
          (footer.border! as Border).top.color,
          heroUiToken(HeroUiTokens.separator, mode),
        );
        expect(spec.content.spec.box!.spec.padding, const EdgeInsets.all(12));

        // Section label: `text-xs` medium in `muted`.
        final label = spec.sectionLabel.spec.style!;
        expect(label.fontSize, 12);
        expect(label.fontWeight, FontWeight.w500);
        expect(label.color, heroUiToken(HeroUiTokens.muted, mode));

        // The rows are the `sm` toggle button: 32 high from 768px, 36 below.
        final rowHeight = width >= 768 ? 32.0 : 36.0;
        expect(
          tester.getSize(find.bySemanticsLabel('Reports')).height,
          rowHeight,
        );
        // Full width: 256, less the 1px edge and the 12px insets.
        expect(tester.getSize(find.bySemanticsLabel('Reports')).width, 231);

        // Selected: the selected toggle button's `accent-soft` pair.
        final selected = _destination(tester, 'Overview');
        expect(_fill(selected), heroUiToken(HeroUiTokens.accentSoft, mode));
        expect(
          selected.label.spec.style!.color,
          heroUiToken(HeroUiTokens.accentSoftForeground, mode),
        );
        expect(
          selected.icon.spec.color,
          heroUiToken(HeroUiTokens.accentSoftForeground, mode),
        );

        // Rest: the ghost toggle, transparent in `default-foreground`.
        final rest = _destination(tester, 'Reports');
        expect(_fill(rest), anyOf(isNull, HeroUiTokens.transparent));
        expect(
          rest.label.spec.style!.color,
          heroUiToken(HeroUiTokens.defaultForeground, mode),
        );
        expect(rest.label.spec.style!.fontSize, 14);
        expect(rest.icon.spec.size, 16);
        final flex = rest.container.spec.flex!.spec;
        expect(flex.mainAxisSize, MainAxisSize.max);
        expect(flex.mainAxisAlignment, MainAxisAlignment.start);
      });
    }
  }

  testWidgets('a hovered row takes the ghost toggle hover fill', (
    tester,
  ) async {
    await tester.pumpHeroUi(_sidebar());
    await tester.hoverCenter(find.bySemanticsLabel('Reports'));
    expect(
      _fill(_destination(tester, 'Reports')),
      heroUiToken(HeroUiTokens.defaultColor),
    );
  }, variant: desktopOnly);

  testWidgets('a row reports its value through the generic wrapper', (
    tester,
  ) async {
    String? selected;
    await tester.pumpHeroUi(_sidebar(onSelected: (value) => selected = value));
    await tester.tap(find.text('Reports'));
    await tester.pump();
    expect(selected, 'reports');
    expect(find.byType(RemixSidebar<String>), findsOneWidget);
  });

  group('keyboard focus on a destination', () {
    late FocusHighlightStrategy previous;
    setUp(() {
      previous = FocusManager.instance.highlightStrategy;
      FocusManager.instance.highlightStrategy =
          FocusHighlightStrategy.alwaysTraditional;
    });
    tearDown(() => FocusManager.instance.highlightStrategy = previous);

    for (final mode in _modes) {
      for (final collapsed in [false, true]) {
        testWidgets('rings inside the row without moving it in $mode, '
            '${collapsed ? 'collapsed' : 'expanded'}', (tester) async {
          await tester.pumpHeroUi(
            _sidebar(collapsed: collapsed, width: collapsed ? 72 : 256),
            mode: mode,
          );
          await tester.pumpAndSettle();
          final row = find.bySemanticsLabel('Reports');
          final idle = tester.getRect(row);
          final icon = tester.getRect(find.byIcon(_reportsIcon));

          await tester.sendKeyEvent(LogicalKeyboardKey.tab);
          await tester.sendKeyEvent(LogicalKeyboardKey.tab);
          await tester.pumpAndSettle();
          final effects = tester
              .resolvedSpecOf<ToggleSpec>(find.byIcon(_reportsIcon))
              .containerEffects;

          // `ring-inset`: the 2px focus ring inside the edge, no gap layer.
          expect(effects, isNotNull);
          expect(effects!.outline.width, HeroUiTokens.focusWidth);
          expect(effects.outlineOffset, -HeroUiTokens.focusWidth);
          expect(effects.outline.color, heroUiToken(HeroUiTokens.focus, mode));
          expect(effects.overContent?.shadows ?? const [], isEmpty);
          expect(tester.getRect(row), idle);
          expect(tester.getRect(find.byIcon(_reportsIcon)), icon);
        });
      }
    }
  });

  testWidgets('a collapsed rail labels destinations in the tooltip recipe', (
    tester,
  ) async {
    await tester.pumpHeroUi(_sidebar(collapsed: true, width: 72));
    await tester.pumpAndSettle();
    final spec = tester.resolvedSpecOf<SidebarSpec>(find.byIcon(_reportsIcon));
    final tooltip =
        spec.tooltip.spec.container.spec.decoration as BoxDecoration?;
    expect(tooltip?.color, heroUiToken(HeroUiTokens.overlay));
    expect(spec.tooltip.spec.label.spec.style?.fontSize, 12);
    expect(tester.takeException(), isNull);
  });

  testWidgets('AnimationStyle.noAnimation collapses in a single frame', (
    tester,
  ) async {
    var collapsed = false;
    late StateSetter update;
    await tester.pumpHeroUi(
      Align(
        alignment: Alignment.topLeft,
        child: StatefulBuilder(
          builder: (context, setState) {
            update = setState;
            return HeroUiSidebar<String>(
              collapsed: collapsed,
              expandedWidth: 256,
              collapsedWidth: 72,
              animationStyle: AnimationStyle.noAnimation,
              sections: const [],
              selectedValue: null,
            );
          },
        ),
      ),
    );
    await tester.pumpAndSettle();
    final sidebar = find.byType(HeroUiSidebar<String>);
    expect(tester.getSize(sidebar).width, 256);
    update(() => collapsed = true);
    await tester.pump();
    expect(tester.getSize(sidebar).width, 72);
    expect(tester.binding.hasScheduledFrame, isFalse);
    update(() => collapsed = false);
    await tester.pump();
    expect(tester.getSize(sidebar).width, 256);
  });

  for (final mode in _modes) {
    testWidgets(
      'hovering a collapsed destination shows its tooltip in $mode',
      (tester) async {
        final semantics = tester.ensureSemantics();
        await tester.pumpHeroUi(
          _sidebar(collapsed: true, width: 72),
          mode: mode,
        );
        await tester.pumpAndSettle();
        expect(find.text('Overview'), findsNothing);

        // The rail destination is named by its label once, selected, and
        // carries no tooltip text that a screen reader would repeat.
        final node = tester.getSemantics(find.bySemanticsLabel('Overview'));
        expect(node.getSemanticsData().tooltip, isEmpty);
        expect(
          node.getSemanticsData().flagsCollection.isSelected,
          ui.Tristate.isTrue,
        );

        final gesture = await tester.createGesture(
          kind: ui.PointerDeviceKind.mouse,
        );
        await gesture.addPointer(location: const Offset(900, 700));
        addTearDown(gesture.removePointer);
        await gesture.moveTo(tester.getCenter(find.byIcon(_overviewIcon)));
        await tester.pump(const Duration(milliseconds: 201));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 200));

        final label = find.text('Overview');
        expect(label, findsOneWidget);
        expect(
          DefaultTextStyle.of(tester.element(label)).style.color,
          heroUiToken(HeroUiTokens.foreground, mode),
        );
        final panel = tester
            .widgetList<Container>(
              find.ancestor(of: label, matching: find.byType(Container)),
            )
            .map((container) => container.decoration)
            .whereType<BoxDecoration>()
            .firstWhere((decoration) => decoration.color != null);
        expect(panel.color, heroUiToken(HeroUiTokens.overlay, mode));
        // The visible tooltip adds no second node announcing the label.
        expect(find.bySemanticsLabel('Overview'), findsOneWidget);
        expect(
          tester
              .getSemantics(find.bySemanticsLabel('Overview'))
              .getSemanticsData()
              .flagsCollection
              .isSelected,
          ui.Tristate.isTrue,
        );

        await gesture.moveTo(const Offset(900, 700));
        await tester.pump(const Duration(milliseconds: 300));
        await tester.pumpAndSettle();
        semantics.dispose();
        expect(tester.takeException(), isNull);
      },
      variant: desktopOnly,
    );
  }

  group('keyboard focus on a clipped destination', () {
    late FocusHighlightStrategy previous;
    setUp(() {
      previous = FocusManager.instance.highlightStrategy;
      FocusManager.instance.highlightStrategy =
          FocusHighlightStrategy.alwaysTraditional;
    });
    tearDown(() => FocusManager.instance.highlightStrategy = previous);

    // The sidebar is shorter than its destinations, so reaching the fifth one
    // scrolls the destination region.
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
    const targetIcon = IconData(0xe002, fontFamily: 'Ahem');
    const otherIcon = IconData(0xe003, fontFamily: 'Ahem');

    for (final mode in _modes) {
      for (final collapsed in [false, true]) {
        testWidgets('scrolls it into view and paints its ring in $mode, '
            '${collapsed ? 'collapsed' : 'expanded'}', (tester) async {
          final boundary = GlobalKey();
          await tester.pumpHeroUi(
            RepaintBoundary(
              key: boundary,
              child: SizedBox(
                width: collapsed ? 72 : 256,
                height: 160,
                child: HeroUiSidebar<String>(
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
                            icon: label == target ? targetIcon : otherIcon,
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            mode: mode,
          );
          await tester.pumpAndSettle();
          final scrollable = find.descendant(
            of: find.byType(HeroUiSidebar<String>),
            matching: find.byType(Scrollable),
          );
          final viewport = tester.getRect(scrollable);
          expect(
            viewport.contains(
              tester.getBottomLeft(find.bySemanticsLabel(target)),
            ),
            isFalse,
            reason: 'the target starts clipped',
          );

          for (var i = 0; i <= labels.indexOf(target); i++) {
            await tester.sendKeyEvent(LogicalKeyboardKey.tab);
          }
          await tester.pumpAndSettle();

          final scroll = tester.state<ScrollableState>(scrollable);
          expect(scroll.position.pixels, greaterThan(0));
          final destination = tester.getRect(find.bySemanticsLabel(target));
          expect(destination.top, greaterThanOrEqualTo(viewport.top - .001));
          expect(destination.bottom, lessThanOrEqualTo(viewport.bottom + .001));

          // The inset ring paints inside the destination's edge, so scrolling
          // the destination flush against the region keeps all of it visible.
          final focused = await capturePixels(tester, boundary);
          final origin = tester.getTopLeft(find.byKey(boundary));
          Color pixel(Offset logical) {
            final device = (logical - origin) * pixelScale.toDouble();
            return focused.at(device.dx.round(), device.dy.round());
          }

          final ring = heroUiToken(HeroUiTokens.focus, mode);
          const inside = HeroUiTokens.focusWidth / 2;
          for (final at in [
            Offset(destination.center.dx, destination.top + inside),
            Offset(destination.center.dx, destination.bottom - inside),
          ]) {
            expectNearColor(pixel(at), ring);
          }
          expect(tester.takeException(), isNull);
        });
      }
    }
  });

  test('the recipe leaves width and header padding to the host', () {
    final style = heroUiSidebarStyle();
    expect(style.$header, isNull);
    expect(
      File('lib/src/heroui/components/sidebar.dart').readAsStringSync(),
      isNot(contains('package:flutter/material.dart')),
    );
  });
}
