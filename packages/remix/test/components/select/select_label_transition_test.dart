import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/remix.dart';

import '../../helpers/test_helpers.dart';

const _enter = Duration(milliseconds: 200);
const _exit = Duration(milliseconds: 100);

/// The last info each label's builder received, keyed by the label's text.
class _Recorder {
  final infos = <String, RemixSelectLabelTransitionInfo>{};

  RemixSelectLabelTransition get transition => RemixSelectLabelTransition(
    duration: _enter,
    reverseDuration: _exit,
    builder: (context, info, label) {
      final text = (label as Opacity).child! as StyledText;
      infos[text.text] = info;
      return FadeTransition(opacity: info.animation, child: label);
    },
  );
}

Widget _select(int? value, {RemixSelectLabelTransition? transition}) =>
    RemixSelect<int>(
      trigger: const RemixSelectTrigger(placeholder: 'Pick'),
      items: const [
        RemixSelectItem(value: 1, label: 'One'),
        RemixSelectItem(value: 2, label: 'Two'),
        RemixSelectItem(value: 3, label: 'Three'),
      ],
      selectedValue: value,
      onChanged: (_) {},
      style: transition == null
          ? SelectStyler()
          : SelectStyler().trigger(
              SelectTriggerStyler().labelTransition(transition),
            ),
    );

void main() {
  group('RemixSelect labelTransition', () {
    testWidgets('without a transition the label changes at once', (
      tester,
    ) async {
      await tester.pumpRemixApp(_select(1));
      await tester.pumpRemixApp(_select(2));

      expect(find.text('One'), findsNothing);
      expect(find.text('Two'), findsOneWidget);
    });

    testWidgets('the old label leaves while the new one arrives', (
      tester,
    ) async {
      final recorder = _Recorder();
      await tester.pumpRemixApp(_select(1, transition: recorder.transition));
      await tester.pumpRemixApp(_select(2, transition: recorder.transition));

      final arriving = recorder.infos['Two']!;
      final leaving = recorder.infos['One']!;
      expect(arriving.entering, isTrue);
      expect(arriving.animation.value, 0);
      expect(leaving.entering, isFalse);
      expect(leaving.animation.status, AnimationStatus.reverse);

      await tester.pump(_exit ~/ 2);
      expect(find.text('One'), findsOneWidget);
      expect(leaving.animation.value, closeTo(0.5, 0.01));
      expect(arriving.animation.value, closeTo(0.25, 0.01));

      await tester.pump(_exit ~/ 2 + const Duration(milliseconds: 1));
      await tester.pump();
      expect(find.text('One'), findsNothing);
      expect(find.text('Two'), findsOneWidget);

      await tester.pumpAndSettle();
      expect(arriving.animation.value, 1);
    });

    testWidgets('reports which way the selection moved', (tester) async {
      final recorder = _Recorder();
      await tester.pumpRemixApp(_select(null, transition: recorder.transition));
      await tester.pumpRemixApp(_select(2, transition: recorder.transition));
      expect(recorder.infos['Two']!.direction, RemixSelectLabelDirection.later);
      expect(
        recorder.infos['Pick']!.direction,
        RemixSelectLabelDirection.later,
      );
      await tester.pumpAndSettle();

      await tester.pumpRemixApp(_select(1, transition: recorder.transition));
      expect(
        recorder.infos['One']!.direction,
        RemixSelectLabelDirection.earlier,
      );
      expect(
        recorder.infos['Two']!.direction,
        RemixSelectLabelDirection.earlier,
      );
      await tester.pumpAndSettle();

      await tester.pumpRemixApp(_select(null, transition: recorder.transition));
      expect(
        recorder.infos['Pick']!.direction,
        RemixSelectLabelDirection.earlier,
      );
    });

    testWidgets('the label shown at the first build starts at rest', (
      tester,
    ) async {
      final recorder = _Recorder();
      await tester.pumpRemixApp(_select(1, transition: recorder.transition));

      expect(recorder.infos['One']!.animation.value, 1);
      expect(tester.hasRunningAnimations, isFalse);
    });

    testWidgets('hides the leaving label from semantics', (tester) async {
      final semantics = tester.ensureSemantics();
      try {
        final recorder = _Recorder();
        await tester.pumpRemixApp(_select(1, transition: recorder.transition));
        await tester.pumpRemixApp(_select(2, transition: recorder.transition));

        final labels = tester.semantics
            .simulatedAccessibilityTraversal()
            .map((node) => node.getSemanticsData().label)
            .join(' ');
        expect(find.text('One'), findsOneWidget);
        expect(labels, isNot(contains('One')));
        await tester.pumpAndSettle();
      } finally {
        semantics.dispose();
      }
    });

    testWidgets('under reduced motion the label changes at once', (
      tester,
    ) async {
      final recorder = _Recorder();
      Widget host(int value) => MediaQuery(
        data: const MediaQueryData(disableAnimations: true),
        child: _select(value, transition: recorder.transition),
      );
      await tester.pumpRemixApp(host(1));
      await tester.pumpRemixApp(host(2));

      expect(find.text('One'), findsNothing);
      expect(recorder.infos['Two']!.animation.value, 1);
    });
  });
}
