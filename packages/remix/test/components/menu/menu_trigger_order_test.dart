import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/remix.dart';

import '../../helpers/test_helpers.dart';

void main() {
  testWidgets('menu trigger icon paints before label', (tester) async {
    await tester.pumpRemixApp(
      RemixMenu<String>(
        trigger: const RemixMenuTrigger(label: 'Actions', icon: Icons.menu),
        items: const [RemixMenuItem(value: 'a', label: 'A')],
      ),
    );
    await tester.pumpAndSettle();

    final iconFinder = find.byIcon(Icons.menu);
    final labelFinder = find.text('Actions');
    expect(iconFinder, findsOneWidget);
    expect(labelFinder, findsOneWidget);

    final iconOffset = tester.getTopLeft(iconFinder);
    final labelOffset = tester.getTopLeft(labelFinder);
    expect(
      iconOffset.dx,
      lessThan(labelOffset.dx),
      reason: 'icon should render to the left of the label',
    );
  });
}
