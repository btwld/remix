import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registry_source/src/heroui/components/sidebar.dart';
import 'package:registry_source/src/heroui/theme/theme.dart';
import 'package:remix/remix.dart';

import '../helpers/heroui.dart';

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

  test('the recipe leaves width and header padding to the host', () {
    final style = heroUiSidebarStyle();
    expect(style.$header, isNull);
    expect(
      File('lib/src/heroui/components/sidebar.dart').readAsStringSync(),
      isNot(contains('package:flutter/material.dart')),
    );
  });
}
