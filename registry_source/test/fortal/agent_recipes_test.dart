import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registry_source/src/fortal/recipes/answer_recipe.dart';
import 'package:registry_source/src/fortal/recipes/composer_recipe.dart';
import 'package:registry_source/src/fortal/recipes/conversation_recipe.dart';
import 'package:registry_source/src/fortal/recipes/steps_recipe.dart';
import 'package:registry_source/src/fortal/recipes/tool_call_recipe.dart';
import 'package:registry_source/src/fortal/theme/theme.dart';
import 'package:remix/remix.dart';

// The measurements of the approved mock (shots 01-06) on Fortal tokens.

void main() {
  testWidgets('the conversation is a 768 column with 48 and 24 spacing', (
    tester,
  ) async {
    final spec = await _resolve(tester, fortalAgentConversationRecipe().style);

    expect(spec.maxWidth, 768);
    expect(spec.turnSpacing, 48);
    expect(spec.blockSpacing, 24);
  });

  testWidgets('steps sit 4 apart and the row paints 32 tall', (tester) async {
    final steps = await _resolve(tester, fortalAgentStepsRecipe().style);
    final call = await _resolve(tester, fortalAgentToolCallRecipe().style);

    expect(steps.rail.spec.flex?.spec.spacing, 4);
    expect(call.row.spec.box?.spec.constraints?.minHeight, 32);
  });

  testWidgets('the approval card is a flat panel without a shadow', (
    tester,
  ) async {
    final call = await _resolve(tester, fortalAgentToolCallRecipe().style);

    final decoration = call.card.spec.decoration as BoxDecoration;
    expect(decoration.color, isNotNull);
    expect(decoration.border, isNotNull);
    expect(decoration.boxShadow, isNull);
  });

  testWidgets('the well is gray2 with a gray5 edge and scrolls past 200', (
    tester,
  ) async {
    final call = await _resolve(tester, fortalAgentToolCallRecipe().style);

    final decoration = call.output.spec.decoration as BoxDecoration;
    expect(decoration.color, _color(FortalTokens.gray2));
    expect(call.outputMaxHeight, 200);
    expect(
      (call.error.spec.decoration as BoxDecoration).color,
      _color(FortalTokens.error3),
      reason: 'only the failing lines are tinted',
    );
  });

  testWidgets('the composer is gray2 with the control border and no shadow', (
    tester,
  ) async {
    final composer = await _resolve(tester, fortalAgentComposerRecipe().style);

    final decoration = composer.container.spec.decoration as BoxDecoration;
    expect(decoration.color, _color(FortalTokens.gray2));
    expect(decoration.boxShadow, isNull);
    expect(composer.fieldMaxHeight, 240);
  });

  testWidgets('the composer field draws no frame of its own', (tester) async {
    final field = await _resolve(
      tester,
      fortalAgentComposerRecipe().fieldStyle,
    );

    expect(field.containerEffects?.overContent?.isEmpty, isTrue);
    expect(field.containerEffects?.behindContent?.isEmpty, isTrue);
  });

  testWidgets('the answer is plain text with 12 between its parts', (
    tester,
  ) async {
    final answer = await _resolve(tester, fortalAgentAnswerRecipe().style);

    expect(answer.container.spec.flex?.spec.spacing, 12);
    expect(answer.container.spec.box?.spec.decoration, isNull);
  });
}

Future<S> _resolve<S extends Spec<S>>(
  WidgetTester tester,
  Style<S> style,
) async {
  late S result;
  await tester.pumpWidget(
    WidgetsApp(
      color: const Color(0xFFFFFFFF),
      builder: (context, _) => FortalTheme(
        child: Builder(
          builder: (context) {
            _context = context;
            result = style.build(context).spec;
            return const SizedBox.shrink();
          },
        ),
      ),
    ),
  );
  return result;
}

late BuildContext _context;

Color _color(ColorToken token) => token.resolve(_context);
