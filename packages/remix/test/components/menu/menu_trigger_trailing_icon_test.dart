import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/remix.dart';

import '../../helpers/test_helpers.dart';

RemixMenu<String> _menu(RemixMenuTrigger trigger, {MenuStyler? style}) =>
    RemixMenu<String>(
      trigger: trigger,
      items: const [RemixMenuItem(value: 'copy', label: 'Copy')],
      style: style ?? const MenuStyler.create(),
    );

void main() {
  testWidgets('the default trigger shows no trailing icon', (tester) async {
    await tester.pumpRemixApp(
      _menu(const RemixMenuTrigger(label: 'Options', icon: Icons.add)),
    );
    expect(find.byType(Icon), findsOneWidget);
  });

  testWidgets('trailingIcon follows the label with its own style', (
    tester,
  ) async {
    await tester.pumpRemixApp(
      _menu(
        const RemixMenuTrigger(
          label: 'Options',
          icon: Icons.add,
          trailingIcon: Icons.expand_more,
        ),
        style: MenuStyler().trigger(
          MenuTriggerStyler()
              .icon(IconStyler().size(12))
              .trailingIcon(IconStyler().size(20)),
        ),
      ),
    );
    final label = tester.getRect(find.text('Options'));
    final chevron = tester.getRect(find.byIcon(Icons.expand_more));
    expect(chevron.left, greaterThanOrEqualTo(label.right));
    expect(tester.widget<Icon>(find.byIcon(Icons.expand_more)).size, 20);
    expect(tester.widget<Icon>(find.byIcon(Icons.add)).size, 12);
  });

  testWidgets('a style can supply the trailing glyph', (tester) async {
    await tester.pumpRemixApp(
      _menu(
        const RemixMenuTrigger(label: 'Options'),
        style: MenuStyler().trigger(
          MenuTriggerStyler().trailingIcon(
            IconStyler().icon(Icons.expand_more),
          ),
        ),
      ),
    );
    expect(find.byIcon(Icons.expand_more), findsOneWidget);
  });

  testWidgets('a builder trigger gets the trailing icon in its child', (
    tester,
  ) async {
    await tester.pumpRemixApp(
      _menu(
        RemixMenuTrigger.builder(
          label: 'Options',
          trailingIcon: Icons.expand_more,
          builder: (context, state, child) => child!,
        ),
      ),
    );
    expect(find.byIcon(Icons.expand_more), findsOneWidget);
  });
}
