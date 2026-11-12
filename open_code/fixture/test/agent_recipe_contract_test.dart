import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:open_code_fixture/ui/ui.dart';
import 'package:remix/agent.dart';
import 'package:remix/remix.dart';

void main() {
  testWidgets('answer actions resolve their own hover override', (
    tester,
  ) async {
    const idle = Color(0xFF123456);
    const hovered = Color(0xFFABCDEF);
    final recipe = acmeAgentAnswerRecipe(
      actionStyle: IconButtonStyler()
          .color(idle)
          .onHovered(IconButtonStyler().color(hovered)),
    );
    await tester.pumpWidget(
      WidgetsApp(
        color: const Color(0xFFFFFFFF),
        builder: (_, _) => AcmeTheme(
          mode: AcmeThemeMode.light,
          child: AgentGlyphs(
            builder: acmeAgentGlyph,
            child: AgentAnswer(
              style: recipe.style,
              actionStyle: recipe.actionStyle,
              onCopy: () {},
              child: const Text('Local answer'),
            ),
          ),
        ),
      ),
    );
    final copy = find.byKey(const ValueKey('agent-answer-copy'));
    Iterable<Color?> colors() => tester
        .widgetList<DecoratedBox>(
          find.descendant(of: copy, matching: find.byType(DecoratedBox)),
        )
        .map(
          (box) => box.decoration is BoxDecoration
              ? (box.decoration as BoxDecoration).color
              : null,
        );
    expect(colors(), contains(idle));
    final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
    addTearDown(mouse.removePointer);
    await mouse.addPointer(location: Offset.zero);
    await mouse.moveTo(tester.getCenter(copy));
    await tester.pumpAndSettle();
    expect(colors(), contains(hovered));
    expect(colors(), isNot(contains(idle)));
  });
}
