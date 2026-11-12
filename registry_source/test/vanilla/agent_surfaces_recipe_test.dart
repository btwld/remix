import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registry_source/src/default/recipes/answer_recipe.dart';
import 'package:registry_source/src/default/recipes/execution_recipe.dart';
import 'package:registry_source/src/default/recipes/message_recipe.dart';
import 'package:registry_source/src/default/recipes/permission_recipe.dart';
import 'package:registry_source/vanilla.dart';
import 'package:remix/remix.dart';

import 'support.dart';

// Each kind of item in a turn is told apart by its surface, not by another
// identical shadowed card: the reader's message is a muted bubble, a tool
// call a flat framed row, a permission request the one raised card, and the
// answer plain prose.

Future<BoxDecoration?> _surface(WidgetTester tester, CardStyler style) async {
  late BoxDecoration? decoration;
  await tester.pumpWidget(
    VanillaTheme(
      theme: const VanillaThemeData.light(),
      child: hostOf(
        Builder(
          builder: (context) {
            decoration =
                style.build(context).spec.container.spec.decoration
                    as BoxDecoration?;
            return const SizedBox.shrink();
          },
        ),
      ),
    ),
  );
  return decoration;
}

bool _visible(Color? color) => color != null && color.a > 0;

bool _framed(BoxDecoration? decoration) {
  final border = decoration?.border;
  return border is Border && border.top.style != BorderStyle.none;
}

bool _raised(BoxDecoration? decoration) =>
    decoration?.boxShadow?.isNotEmpty ?? false;

void main() {
  testWidgets('the message is a muted bubble, unframed and flat', (
    tester,
  ) async {
    final bubble = await _surface(
      tester,
      vanillaAgentMessageRecipe().surfaceStyle,
    );
    expect(_visible(bubble?.color), isTrue);
    expect(_framed(bubble), isFalse);
    expect(_raised(bubble), isFalse);
  });

  testWidgets('the answer sits on the page: no fill, frame or shadow', (
    tester,
  ) async {
    final answer = await _surface(
      tester,
      vanillaAgentAnswerRecipe().surfaceStyle,
    );
    expect(_visible(answer?.color), isFalse);
    expect(_framed(answer), isFalse);
    expect(_raised(answer), isFalse);
  });

  testWidgets('a tool call is framed and flat', (tester) async {
    final execution = await _surface(
      tester,
      vanillaAgentExecutionRecipe().surfaceStyle,
    );
    expect(_framed(execution), isTrue);
    expect(_raised(execution), isFalse);
  });

  testWidgets('a permission request is the raised card', (tester) async {
    final permission = await _surface(
      tester,
      vanillaAgentPermissionRecipe().surfaceStyle,
    );
    expect(_framed(permission), isTrue);
    expect(_raised(permission), isTrue);
  });
}
