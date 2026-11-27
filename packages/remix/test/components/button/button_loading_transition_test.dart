import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/remix.dart';

import '../../helpers/motion_harness.dart';
import '../../helpers/test_helpers.dart';

const _transition = RemixLoadingTransition(
  duration: Duration(milliseconds: 200),
  reverseDuration: Duration(milliseconds: 100),
);

Widget _button(ValueNotifier<bool> loading, {ButtonStyler? style}) =>
    ValueListenableBuilder<bool>(
      valueListenable: loading,
      builder: (context, isLoading, _) => RemixButton(
        label: 'Save',
        leadingIcon: Icons.add,
        loading: isLoading,
        onPressed: () {},
        style: style ?? ButtonStyler().loadingTransition(_transition),
      ),
    );

void main() {
  late ValueNotifier<bool> loading;

  setUp(() => loading = ValueNotifier(false));
  tearDown(() => loading.dispose());

  testWidgets('without a transition the spinner swaps in and out at once', (
    tester,
  ) async {
    await tester.pumpRemixApp(_button(loading, style: ButtonStyler()));

    loading.value = true;
    await tester.pump();
    expect(find.byType(RemixSpinner), findsOneWidget);
    expect(
      tester
          .widgetList<Visibility>(find.byType(Visibility))
          .map((v) => v.visible),
      everyElement(isFalse),
    );

    loading.value = false;
    await tester.pump();
    expect(find.byType(RemixSpinner), findsNothing);
  });

  testWidgets('content fades out and the spinner fades in over duration', (
    tester,
  ) async {
    await tester.pumpRemixApp(_button(loading));
    final idleSize = tester.getSize(find.byType(RemixButton));
    expect(find.byType(RemixSpinner), findsNothing);
    expect(effectiveOpacity(tester, find.text('Save')), 1);

    loading.value = true;
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    expect(effectiveOpacity(tester, find.text('Save')), closeTo(.5, .01));
    expect(effectiveOpacity(tester, find.byIcon(Icons.add)), closeTo(.5, .01));
    expect(
      effectiveOpacity(tester, find.byType(RemixSpinner)),
      closeTo(.5, .01),
    );

    await tester.pump(const Duration(milliseconds: 100));
    expect(effectiveOpacity(tester, find.text('Save')), 0);
    expect(effectiveOpacity(tester, find.byType(RemixSpinner)), 1);
    expect(tester.getSize(find.byType(RemixButton)), idleSize);
  });

  testWidgets('the spinner stays mounted until its exit has played', (
    tester,
  ) async {
    loading.value = true;
    await tester.pumpRemixApp(_button(loading));
    expect(effectiveOpacity(tester, find.byType(RemixSpinner)), 1);

    loading.value = false;
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
    expect(find.byType(RemixSpinner), findsOneWidget);
    expect(
      effectiveOpacity(tester, find.byType(RemixSpinner)),
      closeTo(.5, .01),
    );
    expect(effectiveOpacity(tester, find.text('Save')), closeTo(.5, .01));

    await tester.pump(const Duration(milliseconds: 51));
    expect(find.byType(RemixSpinner), findsNothing);
    expect(effectiveOpacity(tester, find.text('Save')), 1);
  });

  testWidgets('builders see the direction of the change', (tester) async {
    final statuses = <AnimationStatus>[];
    Widget record(BuildContext context, Animation<double> a, Widget child) {
      statuses.add(a.status);
      return child;
    }

    await tester.pumpRemixApp(
      _button(
        loading,
        style: ButtonStyler().loadingTransition(
          RemixLoadingTransition(
            duration: const Duration(milliseconds: 200),
            spinnerBuilder: record,
          ),
        ),
      ),
    );

    loading.value = true;
    await tester.pump();
    expect(statuses.last, AnimationStatus.forward);
    await tester.pump(const Duration(milliseconds: 200));

    loading.value = false;
    await tester.pump();
    expect(statuses.last, AnimationStatus.reverse);
  });

  testWidgets('loading still disables the button during the transition', (
    tester,
  ) async {
    var presses = 0;
    await tester.pumpRemixApp(
      ValueListenableBuilder<bool>(
        valueListenable: loading,
        builder: (context, isLoading, _) => RemixButton(
          label: 'Save',
          loading: isLoading,
          onPressed: () => presses++,
          style: ButtonStyler().loadingTransition(_transition),
        ),
      ),
    );

    loading.value = true;
    await tester.pump();
    await tester.tap(find.byType(RemixButton), warnIfMissed: false);
    await tester.pump(const Duration(milliseconds: 50));
    expect(presses, 0);

    loading.value = false;
    await tester.pump(const Duration(milliseconds: 200));
    await tester.tap(find.byType(RemixButton));
    await tester.pump();
    expect(presses, 1);
  });

  for (final request in MotionRequest.values) {
    testWidgets('reduced motion ($request) switches at once', (tester) async {
      final harness = await MotionHarness.pump(tester, _button(loading));
      await harness.set(request, enabled: true);

      loading.value = true;
      await tester.pump();
      expect(effectiveOpacity(tester, find.text('Save')), 0);
      expect(effectiveOpacity(tester, find.byType(RemixSpinner)), 1);

      loading.value = false;
      await tester.pump();
      await tester.pump();
      expect(find.byType(RemixSpinner), findsNothing);
      expect(effectiveOpacity(tester, find.text('Save')), 1);
    });
  }
}
