import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registry_source/fortal.dart';
import 'package:registry_source/src/fortal/recipes/composer_recipe.dart';
import '../helpers/test_helpers.dart';

void main() {
  group('composer', () {
    final recipe = fortalAgentComposerRecipe();

    testWidgets('the field draws no frame of its own, focused or not', (
      tester,
    ) async {
      for (final states in [
        <WidgetState>{},
        {WidgetState.focused},
        {WidgetState.disabled},
      ]) {
        final field = await resolveInFortalTheme(
          tester,
          (context) => recipe.fieldStyle.build(context).spec,
          states: states,
        );
        final effects = field.containerEffects;
        expect(
          effects?.overContent?.shadows ?? const [],
          isEmpty,
          reason: 'No inset stroke inside the card ($states).',
        );
        expect(
          effects?.behindContent?.gradients ?? const [],
          isEmpty,
          reason: 'No disabled well inside the card ($states).',
        );
        expect(
          effects?.outline.style ?? BorderStyle.none,
          BorderStyle.none,
          reason: 'No focus ring inside the card ($states).',
        );
      }
    });

    testWidgets('the card rings while the field has focus', (tester) async {
      final rest = await resolveInFortalTheme(
        tester,
        (context) => recipe.surfaceStyle.build(context).spec,
      );
      final focused = await resolveInFortalTheme(
        tester,
        (context) => recipe.surfaceStyle.build(context).spec,
        states: {WidgetState.focused},
      );
      final ring = await resolveInFortalTheme(
        tester,
        (context) => fortalFocusOutline().resolve(context),
      );

      expect(rest.containerEffects?.outline.style, isNot(BorderStyle.solid));
      expect(focused.containerEffects?.outline, ring.outline);
      expect(focused.containerEffects?.outlineOffset, ring.outlineOffset);
    });
  });
}
