import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registry_source/src/fortal/recipes/activity_recipe.dart';
import 'package:registry_source/src/fortal/recipes/answer_recipe.dart';
import 'package:registry_source/src/fortal/recipes/execution_recipe.dart';
import 'package:registry_source/src/fortal/recipes/message_recipe.dart';
import 'package:registry_source/src/fortal/recipes/permission_recipe.dart';
import 'package:registry_source/src/fortal/recipes/plan_recipe.dart';
import 'package:remix/remix.dart';
import '../helpers/test_helpers.dart';

// Each kind of item in a turn is told apart by its surface, not by another
// identical bordered card: the reader's message is a filled bubble, the
// agent's working steps one quiet line, a tool call a framed row, a permission
// request the one accent-framed card, and the answer plain prose.

Future<BoxDecoration?> _cardAsync(WidgetTester tester, CardStyler style) =>
    resolveInFortalTheme(
      tester,
      (context) =>
          style.build(context).spec.container.spec.decoration as BoxDecoration?,
    );

bool _visible(Color? color) => color != null && color.a > 0;

Color? _edge(BoxDecoration? decoration) {
  final border = decoration?.border;
  return border is Border && border.top.style != BorderStyle.none
      ? border.top.color
      : null;
}

void main() {
  testWidgets('the message is a filled bubble without a frame', (tester) async {
    final bubble = await _cardAsync(
      tester,
      fortalAgentMessageRecipe().surfaceStyle,
    );
    expect(_visible(bubble?.color), isTrue);
    expect(_edge(bubble), isNull);
  });

  testWidgets('the answer sits on the page: no fill, frame or inset', (
    tester,
  ) async {
    final style = fortalAgentAnswerRecipe().surfaceStyle;
    final answer = await _cardAsync(tester, style);
    expect(_visible(answer?.color), isFalse);
    expect(_edge(answer), isNull);
    final padding = await resolveInFortalTheme(
      tester,
      (context) => style.build(context).spec.container.spec.padding,
    );
    expect(padding?.horizontal ?? 0, 0);
  });

  testWidgets('a tool call keeps a hairline frame', (tester) async {
    final execution = await _cardAsync(
      tester,
      fortalAgentExecutionRecipe().surfaceStyle,
    );
    expect(_edge(execution), isNotNull);
  });

  testWidgets('a permission request is framed apart from a tool call', (
    tester,
  ) async {
    final permission = await _cardAsync(
      tester,
      fortalAgentPermissionRecipe().surfaceStyle,
    );
    final execution = await _cardAsync(
      tester,
      fortalAgentExecutionRecipe().surfaceStyle,
    );
    expect(_edge(permission), isNotNull);
    expect(_edge(permission), isNot(_edge(execution)));
  });

  for (final (name, style) in [
    ('plan', fortalAgentPlanRecipe().disclosureStyle),
    ('activity', fortalAgentActivityRecipe().disclosureStyle),
  ]) {
    testWidgets('the $name is one quiet line, without a fill or frame', (
      tester,
    ) async {
      final container = await resolveInFortalTheme(
        tester,
        (context) => style.build(context).spec.container.spec,
      );
      final fill = container.decoration as BoxDecoration?;
      final frame = container.foregroundDecoration as BoxDecoration?;
      expect(_visible(fill?.color), isFalse);
      expect(_edge(frame), isNull);
    });
  }
}
