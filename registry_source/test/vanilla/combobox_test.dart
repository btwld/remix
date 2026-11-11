import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registry_source/vanilla.dart';
import 'package:remix/remix.dart';

import 'support.dart';

void main() {
  testWidgets('combobox rows and panel bounds match Select', (tester) async {
    final theme = vanillaThemes.first.data;
    final combo = await resolveVanilla(
      tester,
      vanillaComboboxStyle(),
      theme: theme,
    );
    final select = await resolveVanilla(
      tester,
      vanillaSelectStyle(),
      theme: theme,
    );
    expect(
      combo.spec.option.spec.container.spec.constraints?.minHeight,
      select.spec.item.spec.container.spec.box!.spec.constraints?.minHeight,
    );
    expect(
      combo.spec.option.spec.container.spec.padding,
      select.spec.item.spec.container.spec.box!.spec.padding,
    );
    expect(
      combo.spec.panel.spec.container.spec.constraints,
      select.spec.content.spec.container.spec.constraints,
    );
    expect(
      combo.spec.panel.spec.containerEffects,
      select.spec.content.spec.containerEffects,
    );
    expect(
      combo.spec.panel.spec.container.spec.margin,
      const EdgeInsets.only(top: 8),
    );
  });

  testWidgets('combobox separates rounded rows by one pixel', (tester) async {
    final combo = await resolveVanilla(
      tester,
      vanillaComboboxStyle(),
      theme: vanillaThemes.first.data,
    );
    expect(
      combo.spec.option.spec.container.spec.margin,
      const EdgeInsets.only(bottom: 1),
    );
  });

  for (final theme in vanillaThemes) {
    group(theme.name, () {
      testWidgets('keyboard ring visibly distinguishes the lighter hover', (
        tester,
      ) async {
        final borders = <Border?>[];
        for (final states in <Set<WidgetState>>[
          {},
          {.hovered},
          {.focused},
          {.pressed},
        ]) {
          final combo = await resolveVanilla(
            tester,
            vanillaComboboxStyle(),
            theme: theme.data,
            states: states,
          );
          final decoration = decorationOf(combo.spec.option.spec.container)!;
          borders.add(decoration.border as Border?);
        }
        expect(borders[2]?.top.color, theme.data.ring);
        expect(borders[2]?.top.width, 1);
        expect(borders[1]?.top.color.a ?? 0, 0);
        expect(borders[2], isNot(borders[1]));
        expect(
          borders.map((border) => border?.dimensions).toSet(),
          hasLength(1),
          reason: 'changing interaction state cannot move text',
        );
      });
      testWidgets('combobox thumb stays subdued', (tester) async {
        final combo = await resolveVanilla(
          tester,
          vanillaComboboxStyle(),
          theme: theme.data,
        );
        expect(
          combo.spec.panel.spec.scrollbarColor,
          tint(theme.data.mutedForeground, 0.35),
        );
      });
      testWidgets('keyboard highlight preserves wrapped label metrics', (
        tester,
      ) async {
        final resting = await resolveVanilla(
          tester,
          vanillaComboboxStyle(),
          theme: theme.data,
        );
        for (final state in [
          WidgetState.focused,
          WidgetState.hovered,
          WidgetState.pressed,
        ]) {
          final highlighted = await resolveVanilla(
            tester,
            vanillaComboboxStyle(),
            theme: theme.data,
            states: {state},
          );
          expect(
            highlighted.spec.option.spec.label.spec.style?.fontWeight,
            resting.spec.option.spec.label.spec.style?.fontWeight,
            reason: '$state must not reflow wrapped labels',
          );
        }
      });
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
          final fills = <Color>[];
          for (final (state, expected) in [
            (WidgetState.hovered, tint(theme.data.accent, 0.85)),
            (WidgetState.focused, theme.data.accent),
            (
              WidgetState.pressed,
              tint(theme.data.primary, theme.name == 'dark' ? 0.2 : 0.18),
            ),
          ]) {
            final spec = await resolveVanilla(
              tester,
              vanillaComboboxStyle(),
              theme: theme.data,
              states: {state},
            );
            expect(
              decorationOf(spec.spec.option.spec.container)?.color,
              expected,
            );
            fills.add(decorationOf(spec.spec.option.spec.container)!.color!);
            expect(
              spec.spec.option.spec.label.spec.style?.color,
              theme.data.accentForeground,
            );
          }
          expect(fills.toSet(), hasLength(3));
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
