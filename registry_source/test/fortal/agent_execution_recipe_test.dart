import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registry_source/agent.dart';
import 'package:registry_source/src/fortal/recipes/execution_recipe.dart';
import '../helpers/test_helpers.dart';

void main() {
  group('execution', () {
    final recipe = fortalAgentExecutionRecipe();

    Widget execution(AgentExecutionStatus status, {int lines = 4}) => SizedBox(
      width: 480,
      child: AgentExecution(
        tool: 'flutter test',
        title: 'Run tests',
        status: status,
        collapseOnComplete: false,
        style: recipe.style,
        surfaceStyle: recipe.surfaceStyle,
        disclosureStyle: recipe.disclosureStyle,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var line = 0; line < lines; line++)
              SizedBox(height: 20, child: Text('line $line')),
          ],
        ),
      ),
    );

    testWidgets('long output scrolls inside a 220px well', (tester) async {
      await tester.pumpRemixApp(
        execution(AgentExecutionStatus.running, lines: 60),
      );
      await tester.pump();

      final output = find.descendant(
        of: find.byType(AgentExecution),
        matching: find.byType(SingleChildScrollView),
      );
      expect(tester.getSize(output).height, 220);
      expect(
        tester.getRect(find.text('line 59')).bottom,
        lessThanOrEqualTo(tester.getRect(output).bottom + 0.5),
        reason: 'A running tool keeps its newest line in view.',
      );
    });
  });
}
