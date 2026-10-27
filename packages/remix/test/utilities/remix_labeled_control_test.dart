import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/remix.dart';

import '../helpers/test_helpers.dart';

const _label = 'Receive updates and release notes';
const _longLabel =
    'Receive detailed release notes and important API migration updates';
const _spacing = 12.0;
const _probe = Key('probe');

class _Subject {
  _Subject(this.name, this.finder, this.build);

  final String name;
  final Finder finder;
  final Widget Function(String label, {Size minimumTapTargetSize}) build;

  Finder get control =>
      find.descendant(of: finder, matching: find.byType(Box)).first;
}

final _subjects = [
  _Subject(
    'RemixRadio',
    find.byType(RemixRadio<String>),
    (label, {minimumTapTargetSize = Size.zero}) => RemixRadioGroup<String>(
      groupValue: 'a',
      onChanged: (_) {},
      child: RemixRadio<String>(
        value: 'b',
        label: label,
        minimumTapTargetSize: minimumTapTargetSize,
        style: RadioStyler().size(16, 16).labelSpacing(_spacing),
      ),
    ),
  ),
  _Subject(
    'RemixSwitch',
    find.byType(RemixSwitch),
    (label, {minimumTapTargetSize = Size.zero}) => RemixSwitch(
      selected: false,
      onChanged: (_) {},
      label: label,
      minimumTapTargetSize: minimumTapTargetSize,
      style: SwitchStyler().size(32, 18).labelSpacing(_spacing),
    ),
  ),
  _Subject(
    'RemixCheckbox',
    find.byType(RemixCheckbox),
    (label, {minimumTapTargetSize = Size.zero}) => RemixCheckbox(
      selected: false,
      onChanged: (_) {},
      label: label,
      minimumTapTargetSize: minimumTapTargetSize,
      style: CheckboxStyler().size(16, 16).labelSpacing(_spacing),
    ),
  ),
];

Future<void> _showDialogWith(WidgetTester tester, Widget content) async {
  await tester.pumpRemixApp(const SizedBox.shrink());
  unawaited(
    showDialog<void>(
      context: tester.element(find.byType(Scaffold)),
      builder: (_) => AlertDialog(content: content),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  for (final subject in _subjects) {
    group('${subject.name} label layout', () {
      for (final direction in TextDirection.values) {
        testWidgets('IntrinsicWidth fits the control, gap, and label in '
            '${direction.name}', (tester) async {
          await tester.pumpRemixApp(
            IntrinsicWidth(key: _probe, child: subject.build(_label)),
            textDirection: direction,
          );

          expect(tester.takeException(), isNull);
          final controlRect = tester.getRect(subject.control);
          final labelRect = tester.getRect(find.text(_label));
          expect(
            tester.getSize(find.byKey(_probe)).width,
            closeTo(controlRect.width + _spacing + labelRect.width, 0.01),
          );
          final gap = direction == TextDirection.ltr
              ? labelRect.left - controlRect.right
              : controlRect.left - labelRect.right;
          expect(gap, closeTo(_spacing, 0.01));
        });
      }

      testWidgets('IntrinsicHeight reports the wrapped label height and '
          'centers the control against it', (tester) async {
        await tester.pumpRemixApp(
          SizedBox(
            width: 220,
            child: IntrinsicHeight(
              key: _probe,
              child: subject.build(_longLabel),
            ),
          ),
        );

        expect(tester.takeException(), isNull);
        final controlRect = tester.getRect(subject.control);
        final labelRect = tester.getRect(find.text(_longLabel));
        expect(labelRect.height, greaterThan(controlRect.height));
        expect(tester.getSize(find.byKey(_probe)).height, labelRect.height);
        expect(controlRect.center.dy, closeTo(labelRect.center.dy, 0.01));
      });

      testWidgets('IntrinsicHeight sizes to the taller of control and label', (
        tester,
      ) async {
        await tester.pumpRemixApp(
          IntrinsicHeight(key: _probe, child: subject.build(_label)),
        );

        expect(tester.takeException(), isNull);
        expect(
          tester.getSize(find.byKey(_probe)).height,
          math.max(
            tester.getSize(subject.control).height,
            tester.getSize(find.text(_label)).height,
          ),
        );
      });

      testWidgets('the minimum tap target still applies under intrinsic '
          'sizing', (tester) async {
        const label = 'OK';
        await tester.pumpRemixApp(
          IntrinsicWidth(
            child: IntrinsicHeight(
              key: _probe,
              child: subject.build(
                label,
                minimumTapTargetSize: const Size.square(48),
              ),
            ),
          ),
        );

        expect(tester.takeException(), isNull);
        expect(
          tester.getSize(find.byKey(_probe)),
          Size(
            math.max(
              48,
              tester.getSize(subject.control).width +
                  _spacing +
                  tester.getSize(find.text(label)).width,
            ),
            48,
          ),
        );
      });

      testWidgets('lays out inside AlertDialog content', (tester) async {
        await _showDialogWith(tester, subject.build(_label));

        expect(tester.takeException(), isNull);
        final dialogRect = tester.getRect(find.byType(AlertDialog));
        final labelRect = tester.getRect(find.text(_label));
        expect(labelRect.left, greaterThanOrEqualTo(dialogRect.left));
        expect(labelRect.right, lessThanOrEqualTo(dialogRect.right));
        expect(
          tester.getSize(subject.finder).width,
          greaterThanOrEqualTo(
            tester.getSize(subject.control).width + _spacing + labelRect.width,
          ),
        );
      });

      testWidgets('reports intrinsic extents and a dry layout that match its '
          'laid-out size', (tester) async {
        await tester.pumpRemixApp(
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [subject.build(_label)],
          ),
        );

        expect(tester.takeException(), isNull);
        final controlWidth = tester.getSize(subject.control).width;
        final labelBox = tester.renderObject<RenderBox>(find.text(_label));
        final box = tester.renderObject<RenderBox>(subject.finder);
        expect(
          box.size.width,
          closeTo(controlWidth + _spacing + labelBox.size.width, 0.01),
        );
        expect(
          box.getMaxIntrinsicWidth(double.infinity),
          closeTo(box.size.width, 0.01),
        );
        expect(
          box.getMinIntrinsicWidth(double.infinity),
          closeTo(
            controlWidth +
                _spacing +
                labelBox.getMinIntrinsicWidth(double.infinity),
            0.01,
          ),
        );
        expect(
          box.getMaxIntrinsicHeight(box.size.width),
          closeTo(box.size.height, 0.01),
        );
        expect(box.getDryLayout(box.constraints), box.size);
      });

      testWidgets('wraps the label inside a narrow bounded width', (
        tester,
      ) async {
        await tester.pumpRemixApp(
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [subject.build(_label)],
          ),
        );
        final lineHeight = tester.getSize(find.text(_label)).height;

        await tester.pumpRemixApp(
          SizedBox(key: _probe, width: 220, child: subject.build(_longLabel)),
        );

        expect(tester.takeException(), isNull);
        final labelRect = tester.getRect(find.text(_longLabel));
        expect(labelRect.height, greaterThan(lineHeight * 1.5));
        expect(
          labelRect.right,
          lessThanOrEqualTo(tester.getRect(find.byKey(_probe)).right),
        );
        expect(
          tester.getRect(subject.control).center.dy,
          closeTo(labelRect.center.dy, 0.01),
        );
      });
    });
  }

  testWidgets('a radio group picks an option inside AlertDialog content', (
    tester,
  ) async {
    String? picked;
    await _showDialogWith(
      tester,
      StatefulBuilder(
        builder: (context, setState) => RemixRadioGroup<String>(
          groupValue: picked,
          onChanged: (value) => setState(() => picked = value),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final option in const ['Email', 'Text message'])
                RemixRadio<String>(
                  value: option,
                  label: option,
                  style: RadioStyler().size(16, 16).labelSpacing(_spacing),
                ),
            ],
          ),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
    await tester.tap(find.text('Text message'));
    await tester.pump();

    expect(picked, 'Text message');
  });
}
