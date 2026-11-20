import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show LogicalKeyboardKey;
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/remix.dart';

import '../helpers/motion_harness.dart';
import '../helpers/test_helpers.dart';

void main() {
  testWidgets('control menu resolves item style only inside its overlay', (
    tester,
  ) async {
    var itemBuilds = 0;
    await tester.pumpRemixApp(
      RemixMenu<String>(
        trigger: RemixMenuTrigger.control(
          builder: (context, menu) => TextButton(
            focusNode: menu.focusNode,
            onPressed: menu.toggle,
            child: const Text('Options'),
          ),
        ),
        items: const [RemixMenuItem(value: 'copy', label: 'Copy')],
        style: MenuStyler().item(
          MenuItemStyler().onBuilder((context) {
            itemBuilds++;
            final placement = OverlayPlacement.maybeOf(context)!;
            return MenuItemStyler().label(
              TextStyler().color(
                placement.side == OverlaySide.bottom ? Colors.blue : Colors.red,
              ),
            );
          }),
        ),
      ),
    );

    expect(itemBuilds, 0);
    await tester.tap(find.text('Options'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(itemBuilds, greaterThan(0));
    expect(find.text('Copy'), findsOneWidget);

    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pump();
    expect(find.text('Copy'), findsNothing);
  });

  testWidgets('raw SelectSpec bypasses fluent style and uses default motion', (
    tester,
  ) async {
    var fluentBuilds = 0;
    await tester.pumpRemixApp(
      RemixSelect<String>(
        trigger: const RemixSelectTrigger(placeholder: 'Choose'),
        items: const [RemixSelectItem(value: 'a', label: 'Alpha')],
        onChanged: (_) {},
        styleSpec: const SelectSpec(),
        style: SelectStyler().onBuilder((context) {
          fluentBuilds++;
          return SelectStyler();
        }),
      ),
    );

    await tester.tap(find.text('Choose'));
    await tester.pump();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 75));
    expect(
      effectiveOpacity(tester, find.text('Alpha')),
      inExclusiveRange(0, 1),
    );
    await tester.pump(const Duration(milliseconds: 76));
    expect(effectiveOpacity(tester, find.text('Alpha')), 1);
    expect(fluentBuilds, 0);
  });

  testWidgets('unstyled popover still shows and hides without animation', (
    tester,
  ) async {
    await tester.pumpRemixApp(
      RemixPopover(
        popoverChild: const Text('Content'),
        child: const Text('Open'),
      ),
    );

    await tester.tap(find.text('Open'));
    await tester.pump();
    expect(effectiveOpacity(tester, find.text('Content')), 1);
    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pump();
    expect(find.text('Content'), findsNothing);
  });
}
