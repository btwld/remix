import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registry_source/vanilla.dart';
import 'package:remix/remix.dart';

import 'support.dart';

void main() {
  for (final theme in vanillaThemes) {
    group(theme.name, () {
      testWidgets('combobox reuses the field recipe in every field state', (
        tester,
      ) async {
        for (final states in <Set<WidgetState>>[
          {},
          {.focused},
          {.disabled},
          {.focused, .disabled},
          {.error},
        ]) {
          final combo = await resolveVanilla(
            tester,
            vanillaComboboxStyle(),
            theme: theme.data,
            states: states,
          );
          final field = await resolveVanilla(
            tester,
            vanillaTextFieldStyle(),
            theme: theme.data,
            states: states,
          );
          expect(
            combo.spec.field,
            field,
            reason: '$states should match TextField',
          );
        }
      });
      testWidgets(
        'suggestion states keep readable labels and caller overrides win',
        (tester) async {
          for (final state in [
            WidgetState.hovered,
            WidgetState.focused,
            WidgetState.pressed,
          ]) {
            final spec = await resolveVanilla(
              tester,
              vanillaComboboxStyle(),
              theme: theme.data,
              states: {state},
            );
            expect(
              decorationOf(spec.spec.option.spec.container)?.color,
              theme.data.accent,
            );
            expect(
              spec.spec.option.spec.label.spec.style?.color,
              theme.data.accentForeground,
            );
          }
          final custom = await resolveVanilla(
            tester,
            vanillaComboboxStyle(
              style: ComboboxStyler().option(
                ComboboxOptionStyler().onHovered(
                  .color(
                    VanillaTokens.primary(),
                  ).label(.color(VanillaTokens.primaryForeground())),
                ),
              ),
            ),
            theme: theme.data,
            states: {WidgetState.hovered},
          );
          expect(
            decorationOf(custom.spec.option.spec.container)?.color,
            theme.data.primary,
          );
          expect(
            custom.spec.option.spec.label.spec.style?.color,
            theme.data.primaryForeground,
          );
        },
      );
    });
  }
}
