import 'dart:ui' show PointerDeviceKind;

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registry_source/agent.dart';
import 'package:registry_source/fortal.dart';
import 'package:registry_source/src/fortal/recipes/transcript_recipe.dart';
import '../helpers/test_helpers.dart';

void main() {
  testWidgets('the scroll-to-latest button is a round, opaque surface', (
    tester,
  ) async {
    final recipe = fortalAgentTranscriptRecipe();
    await tester.pumpRemixApp(
      SizedBox(
        width: 400,
        height: 240,
        child: AgentTranscript(
          style: recipe.style,
          latestStyle: recipe.latestStyle,
          children: [
            for (var line = 0; line < 30; line++)
              SizedBox(height: 32, child: Text('line $line')),
          ],
        ),
      ),
    );
    await tester.pump();
    final mouse = TestPointer(1, PointerDeviceKind.mouse);
    mouse.hover(tester.getCenter(find.byType(AgentTranscript)));
    await tester.sendEventToBinding(mouse.scroll(const Offset(0, -300)));
    await tester.pump();

    final latest = find.byKey(const ValueKey('agent-transcript-latest'));
    expect(latest, findsOneWidget);
    final decorations = tester
        .widgetList<DecoratedBox>(
          find.descendant(of: latest, matching: find.byType(DecoratedBox)),
        )
        .map((box) => box.decoration)
        .whereType<BoxDecoration>()
        .toList();
    final context = tester.element(latest);
    final fill = decorations.map((d) => d.color).whereType<Color>().single;
    expect(fill, FortalTokens.colorPanelSolid.resolve(context));
    expect(fill.a, 1, reason: 'Output must not show through the button.');
    expect(
      decorations.expand((d) => d.boxShadow ?? const []),
      isEmpty,
      reason: 'Fortal reserves shadows for floating layers.',
    );
    final transcript = tester.getRect(find.byType(AgentTranscript));
    expect(tester.getCenter(latest).dx, closeTo(transcript.center.dx, 0.5));
    expect(tester.getRect(latest).bottom, lessThan(transcript.bottom));
  });
}
