import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registry_source/agent.dart';
import 'package:registry_source/src/fortal/recipes/permission_recipe.dart';
import 'package:remix/remix.dart';
import '../helpers/test_helpers.dart';

void main() {
  testWidgets('permission decisions end at the trailing edge', (tester) async {
    final recipe = fortalAgentPermissionRecipe();
    await tester.pumpRemixApp(
      SizedBox(
        width: 560,
        child: AgentPermission(
          tool: 'release.publish',
          onAllowOnce: () {},
          onAlwaysAllow: () {},
          onDeny: () {},
          style: recipe.style,
          surfaceStyle: recipe.surfaceStyle,
          allowOnceStyle: recipe.allowOnceStyle,
          alwaysAllowStyle: recipe.alwaysAllowStyle,
          denyStyle: recipe.denyStyle,
        ),
      ),
    );

    final card = tester.getRect(find.byType(RemixCard));
    final allow = tester.getRect(find.text('Allow once'));
    final deny = tester.getRect(find.text('Deny'));
    final inset = card.right - allow.right;
    expect(deny.left, lessThan(allow.left));
    expect(
      inset,
      lessThan(card.width / 8),
      reason: 'Allow once is the last action, at the card end ($inset px).',
    );
  });
}
