import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/remix.dart';

import '../../helpers/test_helpers.dart';

const _items = [
  RemixSegmentedControlItem(value: 'a', label: 'A'),
  RemixSegmentedControlItem(value: 'b', label: 'Bravo Bravo'),
  RemixSegmentedControlItem(value: 'c', label: 'Charlie'),
];

Widget _control({
  RemixSegmentSizing? sizing,
  MainAxisSize? mainAxisSize,
  Axis orientation = Axis.horizontal,
}) {
  var style = SegmentedControlStyler().spacing(4);
  if (sizing != null) style = style.segmentSizing(sizing);
  if (mainAxisSize != null) style = style.mainAxisSize(mainAxisSize);
  return RemixSegmentedControl<String>(
    selectedValue: 'a',
    onChanged: (_) {},
    orientation: orientation,
    style: style,
    items: _items,
  );
}

Rect _segment(WidgetTester tester, String label) => tester.getRect(
  find
      .ancestor(of: find.text(label), matching: find.byType(MergeSemantics))
      .first,
);

double _natural(WidgetTester tester, String label) =>
    tester.getSize(find.text(label)).width;

void main() {
  testWidgets('segments share the largest extent by default', (tester) async {
    await tester.pumpRemixApp(_control());
    final widths = [
      for (final label in ['A', 'Bravo Bravo', 'Charlie'])
        _segment(tester, label).width,
    ];
    expect(widths.toSet(), hasLength(1));
    expect(widths.first, closeTo(_natural(tester, 'Bravo Bravo'), .01));
  });

  testWidgets('content sizing gives each segment its own extent', (
    tester,
  ) async {
    await tester.pumpRemixApp(_control(sizing: .content));
    final a = _segment(tester, 'A');
    final b = _segment(tester, 'Bravo Bravo');
    final c = _segment(tester, 'Charlie');
    expect(a.width, closeTo(_natural(tester, 'A'), .01));
    expect(b.width, closeTo(_natural(tester, 'Bravo Bravo'), .01));
    expect(c.width, closeTo(_natural(tester, 'Charlie'), .01));
    expect(b.left - a.right, closeTo(4, .01));
    expect(c.left - b.right, closeTo(4, .01));
    expect(a.height, b.height);
  });

  testWidgets('content segments keep their proportions in a filled track', (
    tester,
  ) async {
    await tester.pumpRemixApp(
      SizedBox(
        width: 400,
        child: _control(sizing: .content, mainAxisSize: .max),
      ),
    );
    final a = _segment(tester, 'A');
    final b = _segment(tester, 'Bravo Bravo');
    final c = _segment(tester, 'Charlie');
    expect(a.width + b.width + c.width + 8, closeTo(400, .01));
    expect(
      b.width / a.width,
      closeTo(_natural(tester, 'Bravo Bravo') / _natural(tester, 'A'), .01),
    );
  });

  testWidgets('content segments follow the text direction', (tester) async {
    await tester.pumpRemixApp(
      _control(sizing: .content),
      textDirection: TextDirection.rtl,
    );
    final a = _segment(tester, 'A');
    final b = _segment(tester, 'Bravo Bravo');
    expect(b.right, lessThan(a.left));
    expect(a.left - b.right, closeTo(4, .01));
  });

  testWidgets('content segments report their summed intrinsic width', (
    tester,
  ) async {
    await tester.pumpRemixApp(
      IntrinsicWidth(child: _control(sizing: .content)),
    );
    final track =
        _natural(tester, 'A') +
        _natural(tester, 'Bravo Bravo') +
        _natural(tester, 'Charlie') +
        8;
    expect(
      tester.getSize(find.byType(RemixSegmentedControl<String>)).width,
      closeTo(track, .01),
    );
  });

  testWidgets('content sizing applies along a vertical track', (tester) async {
    await tester.pumpRemixApp(
      _control(sizing: .content, orientation: Axis.vertical),
    );
    final a = _segment(tester, 'A');
    final b = _segment(tester, 'Bravo Bravo');
    expect(b.top - a.bottom, closeTo(4, .01));
    expect(a.width, b.width);
  });
}
