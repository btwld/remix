import 'dart:ui' show SemanticsAction;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/remix.dart';
import 'package:remix/src/rendering/remix_box_effects.dart';

import '../helpers/test_helpers.dart';

const _label = 'Email me';
const _description = 'Weekly, no more';

void main() {
  group('checkbox description and row', () {
    testWidgets('stacks the description under the label with its spacing', (
      tester,
    ) async {
      await tester.pumpRemixApp(
        RemixCheckbox(
          selected: false,
          label: _label,
          description: _description,
          onChanged: (_) {},
          style: CheckboxStyler()
              .size(16, 16)
              .descriptionSpacing(6)
              .description(TextStyler().fontSize(10)),
        ),
      );

      final label = tester.getRect(find.text(_label));
      final description = tester.getRect(find.text(_description));
      expect(description.top - label.bottom, 6);
      expect(description.left, label.left);
      expect(description.height, lessThan(label.height));
    });

    testWidgets('reads the description as the hint, not the name', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await tester.pumpRemixApp(
        RemixCheckbox(
          selected: false,
          label: _label,
          description: _description,
          onChanged: (_) {},
        ),
      );

      final data = tester
          .getSemantics(find.byType(RemixCheckbox))
          .getSemanticsData();
      expect(data.label, _label);
      expect(data.hint, _description);
      expect(data.hasAction(SemanticsAction.tap), isTrue);
      handle.dispose();
    });

    testWidgets('a description is part of the tap target', (tester) async {
      var changes = 0;
      await tester.pumpRemixApp(
        RemixCheckbox(
          selected: false,
          label: _label,
          description: _description,
          onChanged: (_) => changes++,
        ),
      );

      await tester.tap(find.text(_description));
      expect(changes, 1);
    });

    testWidgets('row draws one box around the control and its copy', (
      tester,
    ) async {
      var changes = 0;
      await tester.pumpRemixApp(
        RemixCheckbox(
          selected: false,
          label: _label,
          onChanged: (_) => changes++,
          minimumTapTargetSize: Size.zero,
          style: CheckboxStyler()
              .size(16, 16)
              .labelSpacing(8)
              .row(BoxStyler().padding(.all(12))),
        ),
      );

      final adapters = find.byType(RemixBoxAdapter);
      expect(adapters, findsNWidgets(2));
      final row = tester.getRect(adapters.first);
      final label = tester.getRect(find.text(_label));
      expect(row.left, label.left - 8 - 16 - 12);
      expect(row.right, label.right + 12);
      expect(tester.getSize(find.byType(RemixCheckbox)), row.size);

      await tester.tapAt(row.topLeft + const Offset(2, 2));
      expect(changes, 1);
    });

    testWidgets('row resolves in the control state', (tester) async {
      await tester.pumpRemixApp(
        RemixCheckbox(
          selected: true,
          label: _label,
          onChanged: (_) {},
          style: CheckboxStyler()
              .row(BoxStyler().padding(.all(4)))
              .onSelected(CheckboxStyler().row(BoxStyler().padding(.all(10)))),
        ),
      );

      final row = tester.getRect(find.byType(RemixBoxAdapter).first);
      final label = tester.getRect(find.text(_label));
      expect(row.right - label.right, 10);
    });

    testWidgets('start alignment lines the control up with the label top', (
      tester,
    ) async {
      await tester.pumpRemixApp(
        RemixCheckbox(
          selected: false,
          label: _label,
          description: _description,
          onChanged: (_) {},
          style: CheckboxStyler()
              .size(16, 16)
              .controlAlignment(CrossAxisAlignment.start),
        ),
      );

      final box = tester.getRect(find.byType(RemixBoxAdapter));
      expect(box.top, tester.getRect(find.text(_label)).top);
    });

    testWidgets('by default there is no row box and the control is centered', (
      tester,
    ) async {
      await tester.pumpRemixApp(
        RemixCheckbox(
          selected: false,
          label: _label,
          description: _description,
          onChanged: (_) {},
          style: CheckboxStyler().size(16, 16),
        ),
      );

      final box = tester.getRect(find.byType(RemixBoxAdapter));
      final copyTop = tester.getRect(find.text(_label)).top;
      final copyBottom = tester.getRect(find.text(_description)).bottom;
      expect(find.byType(RemixBoxAdapter), findsOneWidget);
      expect(box.center.dy, closeTo((copyTop + copyBottom) / 2, 0.01));
    });

    testWidgets('a group item forwards its description', (tester) async {
      await tester.pumpRemixApp(
        RemixCheckboxGroup<String>(
          values: const {},
          onChanged: (_) {},
          child: const RemixCheckboxGroupItem<String>(
            value: 'a',
            label: _label,
            description: _description,
          ),
        ),
      );

      expect(find.text(_description), findsOneWidget);
    });
  });

  group('radio description and row', () {
    testWidgets('shows the description and reads it as the hint', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await tester.pumpRemixApp(
        RemixRadioGroup<String>(
          groupValue: null,
          onChanged: (_) {},
          child: const RemixRadio<String>(
            value: 'a',
            label: _label,
            description: _description,
          ),
        ),
      );

      expect(find.text(_description), findsOneWidget);
      final data = tester
          .getSemantics(find.byType(RemixRadio<String>))
          .getSemanticsData();
      expect(data.label, _label);
      expect(data.hint, _description);
      expect(data.hasAction(SemanticsAction.tap), isTrue);
      handle.dispose();
    });

    testWidgets('row wraps an unlabeled compact radio too', (tester) async {
      await tester.pumpRemixApp(
        RemixRadioGroup<String>(
          groupValue: null,
          onChanged: (_) {},
          child: RemixRadio<String>(
            value: 'a',
            semanticLabel: 'A',
            style: RadioStyler()
                .size(16, 16)
                .row(BoxStyler().padding(.all(12))),
          ),
        ),
      );

      expect(
        tester.getSize(find.byType(RemixRadio<String>)),
        const Size.square(40),
      );
    });
  });
}
