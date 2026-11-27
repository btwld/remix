import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/remix.dart';

import '../../helpers/test_helpers.dart';

final _seen = <RemixMenuItemTransitionInfo>[];

Widget _record(
  BuildContext context,
  RemixMenuItemTransitionInfo info,
  Widget entry,
) {
  _seen.add(info);
  return KeyedSubtree(key: ValueKey('entry-${info.index}'), child: entry);
}

Widget _plain(
  BuildContext context,
  RemixPanelTransitionInfo info,
  Widget panel,
) => panel;

const _items = <RemixMenuItemData<String>>[
  RemixMenuItem(value: 'copy', label: 'Copy'),
  RemixMenuDivider(),
  RemixMenuSubmenu(
    label: 'More',
    items: [RemixMenuItem(value: 'deep', label: 'Deep')],
  ),
  RemixMenuItem(value: 'paste', label: 'Paste'),
];

RemixMenu<String> _menu({bool withItemTransition = true, bool panel = false}) {
  var style = MenuStyler();
  if (withItemTransition) {
    style = style.itemTransition(
      const RemixMenuItemTransition(builder: _record),
    );
  }
  if (panel) {
    style = style.panelTransition(
      const RemixPanelTransition(
        duration: Duration(milliseconds: 200),
        builder: _plain,
      ),
    );
  }
  return RemixMenu<String>(
    trigger: const RemixMenuTrigger(label: 'Options'),
    items: _items,
    style: style,
  );
}

void main() {
  setUp(_seen.clear);

  testWidgets('entries are unwrapped without an item transition', (
    tester,
  ) async {
    await tester.pumpRemixApp(_menu(withItemTransition: false));
    await tester.tap(find.text('Options'));
    await tester.pumpAndSettle();
    expect(find.text('Copy'), findsOneWidget);
    expect(_seen, isEmpty);
    expect(find.byKey(const ValueKey('entry-0')), findsNothing);
  });

  testWidgets('each root entry gets its index and the entry count', (
    tester,
  ) async {
    await tester.pumpRemixApp(_menu());
    await tester.tap(find.text('Options'));
    await tester.pumpAndSettle();

    final last = _seen.sublist(_seen.length - 4);
    expect(last.map((info) => info.index), [0, 1, 2, 3]);
    expect(last.map((info) => info.count).toSet(), {4});
    expect(
      find.descendant(
        of: find.byKey(const ValueKey('entry-3')),
        matching: find.text('Paste'),
      ),
      findsOneWidget,
    );
  });

  testWidgets('without a panel transition the animation is complete', (
    tester,
  ) async {
    await tester.pumpRemixApp(_menu());
    await tester.tap(find.text('Options'));
    await tester.pumpAndSettle();
    expect(_seen.last.animation.value, 1);
  });

  testWidgets('entries share the panel transition animation', (tester) async {
    await tester.pumpRemixApp(_menu(panel: true));
    await tester.tap(find.text('Options'));
    await tester.pump();
    await tester.pump();
    final animation = _seen.last.animation;
    await tester.pump(const Duration(milliseconds: 100));
    expect(animation.value, closeTo(.5, .01));
    await tester.pumpAndSettle();
    expect(animation.value, 1);
  });

  testWidgets('submenu entries are not wrapped', (tester) async {
    await tester.pumpRemixApp(_menu());
    await tester.tap(find.text('Options'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('More'));
    await tester.pumpAndSettle();
    expect(find.text('Deep'), findsOneWidget);
    expect(_seen.map((info) => info.count).toSet(), {4});
  });
}
