import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/remix.dart';

import '../../helpers/test_helpers.dart';

const _badge = Key('badge');

Widget _control({TextDirection direction = TextDirection.ltr}) =>
    RemixSegmentedControl<String>(
      selectedValue: 'inbox',
      onChanged: (_) {},
      style: SegmentedControlStyler().item(
        SegmentedControlItemStyler().spacing(6),
      ),
      items: const [
        RemixSegmentedControlItem(
          value: 'inbox',
          label: 'Inbox',
          semanticLabel: 'Inbox, 3 unread',
          trailing: SizedBox(key: _badge, width: 10, height: 10),
        ),
        RemixSegmentedControlItem(value: 'sent', label: 'Sent'),
      ],
    );

void main() {
  testWidgets('trailing content follows the label with the item spacing', (
    tester,
  ) async {
    await tester.pumpRemixApp(_control());
    final label = tester.getRect(find.text('Inbox'));
    final badge = tester.getRect(find.byKey(_badge));
    expect(badge.left - label.right, closeTo(6, .01));
  });

  testWidgets('trailing content mirrors in right-to-left text', (tester) async {
    await tester.pumpRemixApp(_control(), textDirection: TextDirection.rtl);
    final label = tester.getRect(find.text('Inbox'));
    final badge = tester.getRect(find.byKey(_badge));
    expect(label.left - badge.right, closeTo(6, .01));
  });

  testWidgets('the segment keeps one accessible name', (tester) async {
    final handle = tester.ensureSemantics();
    await tester.pumpRemixApp(_control());
    expect(find.bySemanticsLabel('Inbox, 3 unread'), findsOneWidget);
    handle.dispose();
  });
}
