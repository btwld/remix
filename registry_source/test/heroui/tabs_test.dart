import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registry_source/heroui.dart';
import 'package:remix/remix.dart';

import '../helpers/heroui.dart';

Widget _tabs(
  HeroUiTabsVariant variant, {
  TabStyler style = const TabStyler.create(),
  bool secondEnabled = true,
}) => RemixTabs(
  selectedTabId: 'one',
  onChanged: (_) {},
  child: Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      HeroUiTabBar(
        variant: variant,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            HeroUiTab(
              variant: variant,
              tabId: 'one',
              label: 'One',
              style: style,
            ),
            HeroUiTab(
              variant: variant,
              tabId: 'two',
              label: 'Two',
              enabled: secondEnabled,
            ),
          ],
        ),
      ),
      const HeroUiTabView(tabId: 'one', child: Text('Panel')),
    ],
  ),
);

BoxDecoration _box(FlexBoxSpec spec) =>
    spec.boxSpec.decoration! as BoxDecoration;

/// `tabs__tab` hover: `opacity-70` on unselected tabs.
const _hoverOpacity = .7;

void main() {
  test('variants follow HeroUI', () {
    expect(HeroUiTabsVariant.values, [
      HeroUiTabsVariant.primary,
      HeroUiTabsVariant.secondary,
    ]);
  });

  for (final mode in ['light', 'dark']) {
    testWidgets('primary list and tabs match upstream in $mode', (
      tester,
    ) async {
      await tester.pumpHeroUi(_tabs(.primary), mode: mode);
      await tester.pumpAndSettle();
      final selectedCase = heroUiCase(
        'tabs-primary-rest-tabs-tab:One',
        mode: mode,
      );
      final idleCase = heroUiCase('tabs-primary-rest-tabs-tab:Two', mode: mode);
      final container = heroUiCase(
        'tabs-primary-rest-tabs-list-container',
        mode: mode,
      );
      final indicator = heroUiCase(
        'tabs-primary-rest-tabs-indicator',
        mode: mode,
      );

      expect(
        tester.getSize(find.byType(HeroUiTab).first).height,
        selectedCase.size.height,
      );
      expect(
        tester.getSize(find.byType(HeroUiTabBar)).height,
        container.size.height,
      );

      final bar = _box(
        tester.resolvedSpecOf<TabBarSpec>(find.text('One')).container.spec,
      );
      expectCssColor(bar.color!, container.styles['backgroundColor']!);
      expect(
        bar.borderRadius,
        BorderRadius.circular(container.px('borderRadius')),
      );

      final selected = tester.resolvedSpecOf<TabSpec>(find.text('One'));
      final pill = _box(selected.container.spec);
      expectCssColor(pill.color!, indicator.styles['backgroundColor']!);
      expect(
        pill.borderRadius,
        BorderRadius.circular(selectedCase.px('borderRadius')),
      );
      expectCssColor(
        selected.label.spec.style!.color!,
        selectedCase.styles['color']!,
      );
      expect(selected.label.spec.style!.fontSize, selectedCase.px('fontSize'));
      expect(selected.label.spec.style!.fontWeight, FontWeight.w500);

      final idle = tester.resolvedSpecOf<TabSpec>(find.text('Two'));
      expectCssColor(idle.label.spec.style!.color!, idleCase.styles['color']!);
      expect(_box(idle.container.spec).color, isNull);
    });

    testWidgets('secondary underlines the selected tab with accent in $mode', (
      tester,
    ) async {
      await tester.pumpHeroUi(_tabs(.secondary), mode: mode);
      await tester.pumpAndSettle();
      final indicator = heroUiCase(
        'tabs-secondary-rest-tabs-indicator',
        mode: mode,
      );
      final selectedCase = heroUiCase(
        'tabs-secondary-rest-tabs-tab:One',
        mode: mode,
      );
      final idleCase = heroUiCase(
        'tabs-secondary-rest-tabs-tab:Two',
        mode: mode,
      );
      final container = heroUiCase(
        'tabs-secondary-rest-tabs-list-container',
        mode: mode,
      );

      // The list is a tab high plus its 1px bottom rule.
      expect(
        tester.getSize(find.byType(HeroUiTabBar)).height,
        container.size.height,
      );
      final bar = _box(
        tester.resolvedSpecOf<TabBarSpec>(find.text('One')).container.spec,
      );
      expect(
        (bar.border! as Border).bottom.color,
        heroUiToken(HeroUiTokens.border, mode),
      );

      final selected = tester.resolvedSpecOf<TabSpec>(find.text('One'));
      final border = _box(selected.container.spec).border! as Border;
      expectCssColor(border.bottom.color, indicator.styles['backgroundColor']!);
      expect(border.bottom.width, indicator.size.height);
      expectCssColor(
        selected.label.spec.style!.color!,
        selectedCase.styles['color']!,
      );
      final idle = tester.resolvedSpecOf<TabSpec>(find.text('Two'));
      expectCssColor(idle.label.spec.style!.color!, idleCase.styles['color']!);
    });

    testWidgets('keyboard focus draws the measured ring without resizing in '
        '$mode', (tester) async {
      for (final variant in HeroUiTabsVariant.values) {
        await tester.pumpHeroUi(_tabs(variant), mode: mode);
        await tester.pumpAndSettle();
        final before = tester.getSize(find.byType(HeroUiTab).first);
        final label = tester.getRect(find.text('One'));
        expect(
          tester
                  .resolvedSpecOf<TabSpec>(find.text('One'))
                  .containerEffects
                  ?.outline
                  .width ??
              0,
          0,
          reason: variant.name,
        );

        await tester.focusWithTab();
        final spec = tester.resolvedSpecOf<TabSpec>(find.text('One'));
        expectFocusRing(
          spec.containerEffects,
          heroUiCase('tabs-primary-keyboard-three-tabs-tab:Three', mode: mode),
        );
        expect(
          tester.getSize(find.byType(HeroUiTab).first),
          before,
          reason: variant.name,
        );
        expect(tester.getRect(find.text('One')), label, reason: variant.name);
      }
    });

    testWidgets('only the secondary tab reserves its indicator edge, and the '
        'label stays centered, in $mode', (tester) async {
      final indicator = heroUiCase(
        'tabs-secondary-rest-tabs-indicator',
        mode: mode,
      );
      for (final variant in HeroUiTabsVariant.values) {
        await tester.pumpHeroUi(_tabs(variant), mode: mode);
        await tester.pumpAndSettle();
        final border = _box(
          tester.resolvedSpecOf<TabSpec>(find.text('Two')).container.spec,
        ).border;
        if (variant == .primary) {
          expect(border, isNull);
        } else {
          expect((border! as Border).bottom.width, indicator.size.height);
          expect((border as Border).bottom.color.a, 0);
          expect(border.top, BorderSide.none);
        }
        expect(
          tester.getCenter(find.text('Two')).dy,
          tester.getCenter(find.byType(HeroUiTab).last).dy,
          reason: variant.name,
        );
      }
    });

    testWidgets(
      'hover dims unselected tabs only; disabled dims to half in $mode',
      (tester) async {
        await tester.pumpHeroUi(_tabs(.primary), mode: mode);
        await tester.pumpAndSettle();
        final mouse = await tester.hoverCenter(find.text('Two'));
        expect(tester.opacityAbove(find.text('Two')), _hoverOpacity);
        await mouse.moveTo(tester.getCenter(find.text('One')));
        await tester.pumpAndSettle();
        expect(tester.opacityAbove(find.text('One')), 1);

        await tester.pumpHeroUi(
          _tabs(.primary, secondEnabled: false),
          mode: mode,
        );
        await tester.pumpAndSettle();
        expect(
          tester.opacityAbove(find.text('Two')),
          HeroUiTokens.disabledOpacity,
        );
      },
      variant: desktopOnly,
    );
  }

  for (final mode in ['light', 'dark']) {
    testWidgets('only the selected pill carries the upstream surface shadow '
        'in $mode', (tester) async {
      await tester.pumpHeroUi(_tabs(.primary), mode: mode);
      await tester.pumpAndSettle();
      final selected = tester.resolvedSpecOf<TabSpec>(find.text('One'));
      final idle = tester.resolvedSpecOf<TabSpec>(find.text('Two'));

      // `--surface-shadow` is a token: the light layers, and none in dark.
      expect(
        behindShadows(selected.containerEffects),
        upstreamSurfaceShadow(mode),
      );
      expect(behindShadows(idle.containerEffects), isEmpty);
      expect(_box(selected.container.spec).boxShadow, isNull);
    });

    testWidgets('a focused selected pill keeps its shadow and gains the ring '
        'in $mode', (tester) async {
      await tester.pumpHeroUi(_tabs(.primary), mode: mode);
      await tester.pumpAndSettle();
      await tester.focusWithTab();

      final effects = tester
          .resolvedSpecOf<TabSpec>(find.text('One'))
          .containerEffects;
      expectFocusRing(
        effects,
        heroUiCase('tabs-primary-keyboard-three-tabs-tab:Three', mode: mode),
      );
      expect(behindShadows(effects), upstreamSurfaceShadow(mode));
    });
  }

  testWidgets('the panel pads its content like upstream', (tester) async {
    await tester.pumpHeroUi(_tabs(.primary));
    await tester.pumpAndSettle();
    final panel = heroUiCase('tabs-primary-rest-tabs-panel');
    final spec = tester.resolvedSpecOf<TabViewSpec>(find.text('Panel'));
    expect(spec.container.spec.padding, const EdgeInsets.all(8));
    expect(
      tester.getSize(find.byType(HeroUiTabView)).height,
      panel.size.height,
    );
  });

  testWidgets('a caller style wins over the recipe', (tester) async {
    await tester.pumpHeroUi(_tabs(.primary, style: TabStyler().height(40)));
    await tester.pumpAndSettle();
    expect(tester.getSize(find.byType(HeroUiTab).first).height, 40);
  });
}
