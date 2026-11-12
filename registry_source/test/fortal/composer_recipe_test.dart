// Inspect the resolved parts that the renderer paints, not recipe declarations.
// ignore_for_file: invalid_use_of_internal_member

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registry_source/agent.dart';
import 'package:registry_source/fortal.dart';
import 'package:registry_source/src/fortal/recipes/composer_recipe.dart';
import 'package:remix/remix.dart';
import 'package:remix/src/rendering/remix_box_effects.dart';

import '../helpers/test_helpers.dart';

RemixBoxAdapter _part(WidgetTester tester, Type type) => tester
    .widgetList<RemixBoxAdapter>(
      find.descendant(
        of: find.byType(type),
        matching: find.byType(RemixBoxAdapter),
      ),
    )
    .first;

void main() {
  testWidgets('caller focus styling still overrides the composer recipe', (
    tester,
  ) async {
    const custom = Color(0xFFFF0000);
    final recipe = fortalAgentComposerRecipe(
      surfaceStyle: CardStyler().onFocused(
        .containerEffects(.outline(.style(.none))),
      ),
      fieldStyle: TextFieldStyler().onFocused(
        .containerEffects(.outline(.color(custom).width(5))),
      ),
    );
    await tester.pumpRemixApp(
      SizedBox(
        width: 420,
        child: AgentComposer(
          onSubmit: (_) {},
          style: recipe.style,
          surfaceStyle: recipe.surfaceStyle,
          fieldStyle: recipe.fieldStyle,
          submitStyle: recipe.submitStyle,
          stopStyle: recipe.stopStyle,
        ),
      ),
    );
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pumpAndSettle();
    expect(
      _part(tester, RemixTextArea).containerEffects!.outline.color,
      custom,
    );
    expect(_part(tester, RemixTextArea).containerEffects!.outline.width, 5);
    expect(
      _part(tester, RemixCard).containerEffects?.outline.style,
      BorderStyle.none,
    );
  });

  for (final mode in [FortalThemeMode.light, FortalThemeMode.dark]) {
    for (final enabled in [true, false]) {
      testWidgets(
        '${mode.name}, enabled=$enabled: only the composer owns its frame',
        (tester) async {
          final recipe = fortalAgentComposerRecipe();
          await tester.pumpRemixApp(
            SizedBox(
              width: 420,
              child: AgentComposer(
                enabled: enabled,
                onSubmit: (_) {},
                style: recipe.style,
                surfaceStyle: recipe.surfaceStyle,
                fieldStyle: recipe.fieldStyle,
                submitStyle: recipe.submitStyle,
                stopStyle: recipe.stopStyle,
              ),
            ),
            mode: mode,
          );
          await tester.pumpAndSettle();

          final field = _part(tester, RemixTextArea);
          expect(
            field.containerEffects?.overContent?.isEmpty ?? true,
            isTrue,
            reason: 'An inset stroke inside the card creates a second frame.',
          );
          expect(
            field.containerEffects?.outline.style ?? BorderStyle.none,
            BorderStyle.none,
          );
          final size = tester.getSize(find.byType(AgentComposer));

          if (enabled) {
            await tester.sendKeyEvent(LogicalKeyboardKey.tab);
            await tester.pumpAndSettle();
            expect(
              tester
                  .widget<EditableText>(find.byType(EditableText))
                  .focusNode
                  .hasFocus,
              isTrue,
            );
            final focusedField = _part(tester, RemixTextArea);
            expect(
              focusedField.containerEffects?.overContent?.isEmpty ?? true,
              isTrue,
            );
            expect(
              focusedField.containerEffects?.outline.style ?? BorderStyle.none,
              BorderStyle.none,
              reason: 'Focus belongs on the whole composer.',
            );
            final surface = _part(tester, RemixCard);
            expect(surface.containerEffects?.outline.style, BorderStyle.solid);
            expect(surface.containerEffects!.outline.width, greaterThan(0));
            expect(tester.getSize(find.byType(AgentComposer)), size);
          }
          expect(tester.takeException(), isNull);
        },
      );
    }
  }
}
