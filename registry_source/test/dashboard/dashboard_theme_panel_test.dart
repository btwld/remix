import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registry_source/src/fortal/recipes/dashboard/dashboard_demo_theme.dart';
import 'package:registry_source/src/fortal/recipes/dashboard/dashboard_demo_theme_panel.dart';
import 'package:registry_source/src/fortal/theme/theme.dart';
import 'package:remix/remix.dart';

import '../helpers/contrast.dart';
import '../helpers/test_helpers.dart';

void main() {
  // Every accent swatch is the palette's mark fill; its selected tick takes
  // the mark ink, measured here on the rendered swatch in each state. The
  // focus-coloured ring also shows the selection, so the tick is one cue.
  for (final dark in [false, true]) {
    for (final state in [null, WidgetState.hovered, WidgetState.pressed]) {
      testWidgets('${dark ? 'dark' : 'light'} ${state?.name ?? 'idle'} '
          'selected swatch ticks keep 3:1 on their fill', (tester) async {
        await tester.binding.setSurfaceSize(const Size(480, 1200));
        addTearDown(() => tester.binding.setSurfaceSize(null));
        await tester.pumpRemixApp(
          FortalDashboardThemeScope(
            settings: const FortalThemeSettings(),
            onChanged: (_) {},
            child: WidgetStateStyleOverride(
              states: {WidgetState.selected, ?state},
              child: const SingleChildScrollView(child: FortalThemePanel()),
            ),
          ),
          mode: dark ? .dark : .light,
        );
        for (final accent in FortalAccentColor.values) {
          final swatch = find.byKey(ValueKey('accent-${accent.name}'));
          final tick = tester.widget<Icon>(
            find.descendant(of: swatch, matching: find.byType(Icon)),
          );
          final fill = tester
              .widgetList<DecoratedBox>(
                find.descendant(
                  of: swatch,
                  matching: find.byType(DecoratedBox),
                ),
              )
              .map((box) => box.decoration)
              .whereType<BoxDecoration>()
              .map((decoration) => decoration.color)
              .firstWhere((color) => color != null)!;
          final tokens = resolveFortalTokens(
            FortalThemeConfig(
              accent: accent,
              brightness: dark ? .dark : .light,
            ),
          );
          final reason = '${accent.name}/${state?.name ?? 'idle'}';
          expect(
            fill,
            state == null
                ? tokens.accent.indicator
                : tokens.accent.scale.step(10),
            reason: reason,
          );
          expect(tick.color, tokens.accentIndicatorContrast, reason: reason);
          expect(
            contrastRatio(tick.color!, fill),
            greaterThanOrEqualTo(3),
            reason: reason,
          );
        }
      });
    }
  }
}
