import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/remix.dart';
import 'package:remix/src/utilities/remix_path_icon.dart';

import '../../helpers/test_helpers.dart';

enum _Side { left, right }

Widget _table({
  required AlignmentGeometry alignment,
  RemixDataTableSortIconPlacement? placement,
  TextDirection direction = TextDirection.ltr,
}) {
  final style = DataTableStyler().sortIconSpacing(4);

  return Directionality(
    textDirection: direction,
    child: SizedBox(
      width: 400,
      child: RemixDataTable<int>(
        rows: const [1],
        columns: [
          RemixDataTableColumn<int>(
            id: 'amount',
            label: 'Amount',
            sortable: true,
            alignment: alignment,
            cellBuilder: (context, row) => Text('$row'),
          ),
        ],
        onSortChanged: (_) {},
        style: placement == null ? style : style.sortIconPlacement(placement),
      ),
    ),
  );
}

/// Physical side of the label that the sort indicator is painted on.
_Side _indicatorSide(WidgetTester tester) {
  final icon = tester.getRect(find.byType(RemixPathIcon));
  final label = tester.getRect(find.text('Amount'));

  return icon.center.dx < label.center.dx ? _Side.left : _Side.right;
}

void main() {
  group('DataTableSpec.sortIconPlacement', () {
    testWidgets('defaults to after the label for an end-aligned column', (
      tester,
    ) async {
      await tester.pumpRemixApp(
        _table(alignment: AlignmentDirectional.centerEnd),
      );

      expect(_indicatorSide(tester), _Side.right);
    });

    final cases = <(String, AlignmentGeometry, TextDirection, _Side)>[
      ('end-aligned, ltr', AlignmentDirectional.centerEnd, .ltr, .left),
      ('start-aligned, ltr', AlignmentDirectional.centerStart, .ltr, .right),
      ('centered, ltr', Alignment.center, .ltr, .right),
      ('end-aligned, rtl', AlignmentDirectional.centerEnd, .rtl, .right),
      ('start-aligned, rtl', AlignmentDirectional.centerStart, .rtl, .left),
      ('physical right, rtl', Alignment.centerRight, .rtl, .left),
      ('physical right, ltr', Alignment.centerRight, .ltr, .left),
    ];
    for (final (name, alignment, direction, side) in cases) {
      testWidgets('inward draws the indicator on the $side ($name)', (
        tester,
      ) async {
        await tester.pumpRemixApp(
          _table(
            alignment: alignment,
            direction: direction,
            placement: RemixDataTableSortIconPlacement.inward,
          ),
        );

        expect(_indicatorSide(tester), side);
      });
    }

    testWidgets('end keeps the indicator after the label', (tester) async {
      await tester.pumpRemixApp(
        _table(
          alignment: AlignmentDirectional.centerEnd,
          direction: TextDirection.rtl,
          placement: RemixDataTableSortIconPlacement.end,
        ),
      );

      expect(_indicatorSide(tester), _Side.left);
    });
  });
}
