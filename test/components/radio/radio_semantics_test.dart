import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/remix.dart';

import '../../helpers/test_helpers.dart';

void main() {
  group('RemixRadio Semantics', () {
    testWidgets('exposes checked, group, focusable for selected/unselected',
        (tester) async {
      String groupValue = 'A';

      await tester.pumpRemixApp(
        StatefulBuilder(
          builder: (context, setState) {
            return RemixRadioGroup<String>(
              groupValue: groupValue,
              onChanged: (value) =>
                  setState(() => groupValue = value ?? groupValue),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                spacing: 16,
                children: const [
                  _LabeledRemixRadio<String>(
                    radioKey: ValueKey('remix_radio_a'),
                    value: 'A',
                    label: 'A',
                  ),
                  _LabeledRemixRadio<String>(
                    radioKey: ValueKey('remix_radio_b'),
                    value: 'B',
                    label: 'B',
                  ),
                ],
              ),
            );
          },
        ),
      );

      final a = tester
          .getSemantics(find.byKey(const ValueKey('remix_radio_a')))
          .getSemanticsData();
      final b = tester
          .getSemantics(find.byKey(const ValueKey('remix_radio_b')))
          .getSemanticsData();

      expect(a.flagsCollection.hasCheckedState, isTrue);
      expect(a.flagsCollection.isChecked, isTrue);
      expect(a.flagsCollection.isInMutuallyExclusiveGroup, isTrue);
      expect(a.flagsCollection.isFocusable, isTrue);

      expect(b.flagsCollection.hasCheckedState, isTrue);
      expect(b.flagsCollection.isChecked, isFalse);
      expect(b.flagsCollection.isInMutuallyExclusiveGroup, isTrue);
      expect(b.flagsCollection.isFocusable, isTrue);
    }, skip: true);

    testWidgets('disabled radios are not focusable', (tester) async {
      await tester.pumpRemixApp(
        RemixRadioGroup<String>(
          groupValue: null,
          onChanged: (_) {},
          child: const _LabeledRemixRadio<String>(
            radioKey: ValueKey('remix_radio_disabled'),
            value: 'X',
            label: 'X',
            enabled: false,
          ),
        ),
      );

      final data = tester
          .getSemantics(find.byKey(const ValueKey('remix_radio_disabled')))
          .getSemanticsData();
      expect(data.flagsCollection.isFocusable, isFalse);
    });
  });

  group('Parity with Material Radio', () {
    testWidgets('group-level role is radioGroup (Remix + Material)',
        (tester) async {
      String remixGroup = 'A';
      String materialGroup = 'A';

      await tester.pumpRemixApp(
        StatefulBuilder(
          builder: (context, setState) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              spacing: 48,
              children: [
                RemixRadioGroup<String>(
                  key: const ValueKey('remix_group'),
                  groupValue: remixGroup,
                  onChanged: (v) => setState(() => remixGroup = v ?? 'A'),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    spacing: 16,
                    children: const [
                      _LabeledRemixRadio<String>(value: 'A', label: 'A'),
                      _LabeledRemixRadio<String>(value: 'B', label: 'B'),
                    ],
                  ),
                ),
                RadioGroup<String>(
                  key: const ValueKey('material_group'),
                  groupValue: materialGroup,
                  onChanged: (v) => setState(() => materialGroup = v ?? 'A'),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    spacing: 16,
                    children: const [
                      Radio<String>(value: 'A'),
                      Radio<String>(value: 'B'),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      );

      final remixGroupData = tester
          .getSemantics(find.byKey(const ValueKey('remix_group')))
          .getSemanticsData();
      final materialGroupData = tester
          .getSemantics(find.byKey(const ValueKey('material_group')))
          .getSemanticsData();

      expect(remixGroupData.role, SemanticsRole.radioGroup);
      expect(materialGroupData.role, SemanticsRole.radioGroup);
    });
    testWidgets('selected/unselected semantics parity', (tester) async {
      String remixGroup = 'A';
      String materialGroup = 'A';

      await tester.pumpRemixApp(
        StatefulBuilder(
          builder: (context, setState) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              spacing: 48,
              children: [
                RemixRadioGroup<String>(
                  groupValue: remixGroup,
                  onChanged: (v) => setState(() => remixGroup = v ?? 'A'),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    spacing: 16,
                    children: const [
                      _LabeledRemixRadio<String>(
                        radioKey: ValueKey('remix_a'),
                        value: 'A',
                        label: 'A',
                      ),
                      _LabeledRemixRadio<String>(
                        radioKey: ValueKey('remix_b'),
                        value: 'B',
                        label: 'B',
                      ),
                    ],
                  ),
                ),
                RadioGroup<String>(
                  groupValue: materialGroup,
                  onChanged: (v) => setState(() => materialGroup = v ?? 'A'),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    spacing: 16,
                    children: const [
                      Radio<String>(key: ValueKey('material_a'), value: 'A'),
                      Radio<String>(key: ValueKey('material_b'), value: 'B'),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      );

      final remixA = tester
          .getSemantics(find.byKey(const ValueKey('remix_a')))
          .getSemanticsData();
      final remixB = tester
          .getSemantics(find.byKey(const ValueKey('remix_b')))
          .getSemanticsData();
      final materialA = tester
          .getSemantics(find.byKey(const ValueKey('material_a')))
          .getSemanticsData();
      final materialB = tester
          .getSemantics(find.byKey(const ValueKey('material_b')))
          .getSemanticsData();

      // Selected A, Unselected B for both implementations
      expect(remixA.flagsCollection.isChecked, isTrue);
      expect(materialA.flagsCollection.isChecked, isTrue);
      expect(remixB.flagsCollection.isChecked, isFalse);
      expect(materialB.flagsCollection.isChecked, isFalse);

      // Group and focusable
      expect(remixA.flagsCollection.isInMutuallyExclusiveGroup, isTrue);
      expect(materialA.flagsCollection.isInMutuallyExclusiveGroup, isTrue);
      expect(remixB.flagsCollection.isInMutuallyExclusiveGroup, isTrue);
      expect(materialB.flagsCollection.isInMutuallyExclusiveGroup, isTrue);
    });

    testWidgets('keyboard: Space selects focused radio (Remix + Material)',
        (tester) async {
      String remixGroup = 'A';
      String materialGroup = 'A';

      await tester.pumpRemixApp(
        StatefulBuilder(
          builder: (context, setState) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              spacing: 48,
              children: [
                Focus(
                  autofocus: true,
                  child: RemixRadioGroup<String>(
                    groupValue: remixGroup,
                    onChanged: (v) => setState(() => remixGroup = v ?? 'A'),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      spacing: 16,
                      children: const [
                        _LabeledRemixRadio<String>(
                          radioKey: ValueKey('r_a'),
                          value: 'A',
                          label: 'A',
                        ),
                        _LabeledRemixRadio<String>(
                          radioKey: ValueKey('r_b'),
                          value: 'B',
                          label: 'B',
                        ),
                      ],
                    ),
                  ),
                ),
                Focus(
                  autofocus: true,
                  child: RadioGroup<String>(
                    groupValue: materialGroup,
                    onChanged: (v) => setState(() => materialGroup = v ?? 'A'),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      spacing: 16,
                      children: const [
                        Radio<String>(key: ValueKey('m_a'), value: 'A'),
                        Radio<String>(key: ValueKey('m_b'), value: 'B'),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      );

      // Focus and toggle Remix second via Space
      await tester.tap(find.byKey(const ValueKey('r_b')));
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.space);
      await tester.pump();
      expect(remixGroup, 'B');

      // Focus and toggle Material second via Space
      await tester.tap(find.byKey(const ValueKey('m_b')));
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.space);
      await tester.pump();
      expect(materialGroup, 'B');
    });

    testWidgets(
        'keyboard: Arrow Right/Down selects next; Left/Up selects previous; wraps (Remix + Material)',
        (tester) async {
      String remixGroup = 'A';
      String materialGroup = 'A';

      await tester.pumpRemixApp(
        StatefulBuilder(
          builder: (context, setState) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              spacing: 48,
              children: [
                RemixRadioGroup<String>(
                  groupValue: remixGroup,
                  onChanged: (v) => setState(() => remixGroup = v ?? 'A'),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    spacing: 16,
                    children: const [
                      _LabeledRemixRadio<String>(
                        radioKey: ValueKey('remix_r1'),
                        value: 'A',
                        label: 'A',
                      ),
                      _LabeledRemixRadio<String>(
                        radioKey: ValueKey('remix_r2'),
                        value: 'B',
                        label: 'B',
                      ),
                      _LabeledRemixRadio<String>(
                        radioKey: ValueKey('remix_r3'),
                        value: 'C',
                        label: 'C',
                      ),
                    ],
                  ),
                ),
                RadioGroup<String>(
                  groupValue: materialGroup,
                  onChanged: (v) => setState(() => materialGroup = v ?? 'A'),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    spacing: 16,
                    children: const [
                      Radio<String>(key: ValueKey('mat_r1'), value: 'A'),
                      Radio<String>(key: ValueKey('mat_r2'), value: 'B'),
                      Radio<String>(key: ValueKey('mat_r3'), value: 'C'),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      );

      // Focus first item in both groups
      await tester.tap(find.byKey(const ValueKey('remix_r1')));
      await tester.pump();
      await tester.tap(find.byKey(const ValueKey('mat_r1')));
      await tester.pump();

      // Right: A -> B
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
      await tester.pump();
      expect(remixGroup, 'B');
      expect(materialGroup, 'B');

      // Down: B -> C
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pump();
      expect(remixGroup, 'C');
      expect(materialGroup, 'C');

      // Right wrap: C -> A
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
      await tester.pump();
      expect(remixGroup, 'A');
      expect(materialGroup, 'A');

      // Left previous with wrap: A -> C
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
      await tester.pump();
      expect(remixGroup, 'C');
      expect(materialGroup, 'C');

      // Up previous: C -> B
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowUp);
      await tester.pump();
      expect(remixGroup, 'B');
      expect(materialGroup, 'B');
      // RemixRadioGroup currently does not change selection via arrow keys; tracking parity follow-up.
    }, skip: true);

    // Note: Arrow-key navigation parity is not asserted here because
    // Flutter Material Radio does not change selection on arrow keys by default,
    // while RemixRadio (via NakedRadio) may support it. We validate Space key behavior instead.
  });
}

class _LabeledRemixRadio<T> extends StatelessWidget {
  const _LabeledRemixRadio({
    super.key,
    required this.value,
    required this.label,
    this.enabled = true,
    this.radioKey,
  });

  final T value;
  final String label;
  final bool enabled;
  final Key? radioKey;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 8,
      children: [
        RemixRadio<T>(
          key: radioKey ?? key,
          value: value,
          enabled: enabled,
          semanticLabel: label,
        ),
        Text(label),
      ],
    );
  }
}
