import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registry_source/agent.dart';
import 'package:registry_source/src/fortal/recipes/answer_recipe.dart';
import 'package:remix/remix.dart';
import '../helpers/test_helpers.dart';

void main() {
  testWidgets('answer feedback sits on the centre line of its actions', (
    tester,
  ) async {
    final recipe = fortalAgentAnswerRecipe();
    await tester.pumpRemixApp(
      SizedBox(
        width: 480,
        child: AgentAnswer(
          status: AgentAnswerStatus.complete,
          style: recipe.style,
          surfaceStyle: recipe.surfaceStyle,
          copyStyle: recipe.copyStyle,
          retryStyle: recipe.retryStyle,
          onCopy: () {},
          onRetry: () {},
          feedback: const Text('Copied'),
          child: const Text('Published.'),
        ),
      ),
    );

    final copy = find.byWidgetPredicate(
      (widget) =>
          widget is RemixIconButton && widget.semanticLabel == 'Copy answer',
    );
    expect(
      tester.getCenter(find.text('Copied')).dy,
      closeTo(tester.getCenter(copy).dy, 0.5),
    );
  });
}
