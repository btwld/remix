import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registry_source/src/heroui/recipes/answer_recipe.dart';
import 'package:registry_source/src/heroui/recipes/composer_recipe.dart';
import 'package:registry_source/src/heroui/recipes/conversation_recipe.dart';
import 'package:registry_source/src/heroui/recipes/suggestions_recipe.dart';
import 'package:registry_source/src/heroui/recipes/tool_call_recipe.dart';
import 'package:registry_source/src/heroui/theme/theme.dart';
import 'package:remix/agent.dart';
import 'package:remix/remix.dart';

import '../helpers/heroui.dart';

void main() {
  for (final mode in ['light', 'dark']) {
    group(mode, () {
      testWidgets('the well and the approval card use HeroUI surfaces', (
        tester,
      ) async {
        final spec = await _resolve(
          tester,
          heroUiAgentToolCallRecipe().style,
          mode: mode,
        );

        expect(
          _fill(spec.output),
          heroUiToken(HeroUiTokens.surfaceSecondary, mode),
        );
        expect(_fill(spec.card), heroUiToken(HeroUiTokens.surface, mode));
        expect(
          _fill(spec.error),
          heroUiToken(HeroUiTokens.dangerSoft, mode),
          reason: 'only the failing lines are tinted',
        );
      });

      testWidgets('the card actions are HeroUI buttons', (tester) async {
        final recipe = heroUiAgentToolCallRecipe();

        final allow = await _resolve(tester, recipe.allowOnceStyle, mode: mode);
        final deny = await _resolve(tester, recipe.denyStyle, mode: mode);

        expect(
          _fill(allow.container.spec.box!),
          heroUiToken(HeroUiTokens.accent, mode),
        );
        expect(
          (deny.container.spec.box!.spec.decoration as BoxDecoration).border,
          isNotNull,
          reason: 'Deny is the outline button',
        );
      });

      testWidgets('the composer is a field surface with no fill on its text', (
        tester,
      ) async {
        final recipe = heroUiAgentComposerRecipe();

        final composer = await _resolve(tester, recipe.style, mode: mode);

        expect(
          _fill(composer.container),
          heroUiToken(HeroUiTokens.surfaceSecondary, mode),
        );
        expect(composer.fieldMaxHeight, 240);
      });
    });
  }

  testWidgets('the conversation is a 768 column with spaced turns', (
    tester,
  ) async {
    final spec = await _resolve(tester, heroUiAgentConversationRecipe().style);

    expect(spec.maxWidth, 768);
    expect(spec.turnSpacing, 48);
    expect(spec.blockSpacing, 24);
  });

  testWidgets('every recipe merges the caller style last', (tester) async {
    expect(
      (await _resolve(
        tester,
        heroUiAgentConversationRecipe(
          style: AgentConversationStyler(turnSpacing: 37),
        ).style,
      )).turnSpacing,
      37,
    );
    expect(
      (await _resolve(
        tester,
        heroUiAgentAnswerRecipe(
          style: AgentAnswerStyler(container: FlexBoxStyler().spacing(37)),
        ).style,
      )).container.spec.flex?.spec.spacing,
      37,
    );
    expect(
      (await _resolve(
        tester,
        heroUiAgentSuggestionsRecipe(
          style: AgentSuggestionsStyler(container: WrapBoxStyler().spacing(37)),
        ).style,
      )).container.spec.flow?.spec.spacing,
      37,
    );
    expect(
      (await _resolve(
        tester,
        heroUiAgentToolCallRecipe(
          style: AgentToolCallStyler(outputMaxHeight: 37),
        ).style,
      )).outputMaxHeight,
      37,
    );
  });
}

Future<S> _resolve<S extends Spec<S>>(
  WidgetTester tester,
  Style<S> style, {
  String mode = 'light',
}) async {
  late S result;
  await tester.pumpHeroUi(
    Builder(
      builder: (context) {
        result = style.build(context).spec;
        return const SizedBox.shrink();
      },
    ),
    mode: mode,
  );
  return result;
}

Color? _fill(Object slot) {
  final box = switch (slot) {
    StyleSpec<BoxSpec>() => slot.spec,
    BoxSpec() => slot,
    StyleSpec<FlexBoxSpec>() => slot.spec.box?.spec,
    _ => null,
  };
  return (box?.decoration as BoxDecoration?)?.color;
}
