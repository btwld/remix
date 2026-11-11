import 'dart:ui' show PointerDeviceKind;

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registry_source/agent.dart';
import 'package:registry_source/src/default/recipes/transcript_recipe.dart';
import 'package:registry_source/vanilla.dart';

import 'support.dart';

void main() {
  for (final theme in vanillaThemes) {
    testWidgets('${theme.name}: scroll-to-latest is a round, opaque outline', (
      tester,
    ) async {
      final recipe = vanillaAgentTranscriptRecipe();
      await tester.pumpWidget(
        VanillaTheme(
          theme: theme.data,
          child: hostOf(
            Center(
              child: SizedBox(
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
            ),
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
      final fill = decorations.map((d) => d.color).whereType<Color>().single;
      expect(fill, tokenOf(theme.data, VanillaTokens.background));
      expect(fill.a, 1, reason: 'Output must not show through the button.');
      final size = tester.getSize(latest);
      final radius = decorations
          .map((d) => d.borderRadius)
          .whereType<BorderRadius>()
          .first;
      expect(radius.topLeft.x, greaterThanOrEqualTo(size.shortestSide / 2));

      final transcript = tester.getRect(find.byType(AgentTranscript));
      expect(tester.getCenter(latest).dx, closeTo(transcript.center.dx, 0.5));
      expect(transcript.bottom - tester.getRect(latest).bottom, 16);
    });
  }
}
