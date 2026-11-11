import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registry_source/src/default/recipes/composer_recipe.dart';
import 'package:registry_source/vanilla.dart';
import 'package:remix/remix.dart';

import 'support.dart';

void main() {
  final recipe = vanillaAgentComposerRecipe();

  for (final theme in vanillaThemes) {
    group(theme.name, () {
      testWidgets('the field draws no frame of its own, focused or not', (
        tester,
      ) async {
        for (final states in [
          <WidgetState>{},
          {WidgetState.focused},
        ]) {
          final field = await resolveVanilla(
            tester,
            recipe.fieldStyle,
            theme: theme.data,
            states: states,
          );
          final effects = field.spec.containerEffects;
          expect(
            effects?.behindContent?.shadows ?? const [],
            isEmpty,
            reason: 'No shadow under the field inside the card ($states).',
          );
          expect(
            effects?.outline.style ?? BorderStyle.none,
            BorderStyle.none,
            reason: 'No focus ring inside the card ($states).',
          );
        }
      });

      testWidgets('the card takes the focus border and ring', (tester) async {
        final focused = await resolveVanilla(
          tester,
          recipe.surfaceStyle,
          theme: theme.data,
          states: {WidgetState.focused},
        );
        final ring = await resolveVanilla(
          tester,
          CardStyler().containerEffects(vanillaFocusRing()),
          theme: theme.data,
        );
        final ringColor = tokenOf(theme.data, VanillaTokens.ring);

        expect(
          focused.spec.containerEffects?.outline,
          ring.spec.containerEffects?.outline,
        );
        final border = focused.spec.container.spec.decoration;
        expect(border, isA<BoxDecoration>());
        expect((border! as BoxDecoration).border?.top.color, ringColor);
      });
    });
  }
}
