import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/remix.dart';

import '../../helpers/test_helpers.dart';

void main() {
  for (final width in [200.0, 800.0]) {
    for (final intrinsicWidth in [true, false]) {
      final name = intrinsicWidth ? 'IntrinsicWidth' : 'IntrinsicHeight';
      testWidgets('default action supports $name at width $width', (
        tester,
      ) async {
        var actions = 0;
        final toast = RemixToast(
          title: 'Draft saved',
          description: 'Stored on this device.',
          action: RemixToastAction(label: 'Undo', onPressed: () => actions++),
        );
        await tester.pumpRemixApp(
          SizedBox(
            width: width,
            child: Align(
              alignment: Alignment.topLeft,
              child: intrinsicWidth
                  ? IntrinsicWidth(child: toast)
                  : IntrinsicHeight(child: toast),
            ),
          ),
        );

        expect(tester.takeException(), isNull);
        final bounds = tester.getRect(find.byType(RemixToast));
        final action = tester.getRect(find.byType(RemixButton));
        expect(bounds.width, lessThanOrEqualTo(width));
        expect(bounds.height, greaterThan(0));
        expect(bounds.contains(action.center), isTrue);
        await tester.tap(find.text('Undo'));
        expect(actions, 1);
      });
    }
  }
}
