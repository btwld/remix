import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registry_source/agent.dart';
import 'package:registry_source/src/default/recipes/execution_recipe.dart';
import 'package:registry_source/vanilla.dart';

import 'support.dart';

void main() {
  final recipe = vanillaAgentExecutionRecipe();

  Widget execution(AgentExecutionStatus status, {int lines = 4}) =>
      VanillaTheme(
        theme: const VanillaThemeData.light(),
        child: hostOf(
          Center(
            child: SizedBox(
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
            ),
          ),
        ),
      );

  testWidgets('long output scrolls inside a 220px well', (tester) async {
    await tester.pumpWidget(execution(AgentExecutionStatus.running, lines: 60));
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

  for (final (status, token) in [
    (AgentExecutionStatus.success, VanillaTokens.primary),
    (AgentExecutionStatus.error, VanillaTokens.destructive),
    (AgentExecutionStatus.cancelled, VanillaTokens.mutedForeground),
  ]) {
    testWidgets('the ${status.name} mark takes its outcome color', (
      tester,
    ) async {
      await tester.pumpWidget(execution(status));
      final colors = tester
          .widgetList<Icon>(
            find.descendant(
              of: find.byType(AgentExecution),
              matching: find.byType(Icon),
            ),
          )
          .map((icon) => icon.color);
      expect(colors, contains(tokenOf(const VanillaThemeData.light(), token)));
    });
  }
}
