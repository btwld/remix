import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/remix.dart';

import '../../helpers/test_helpers.dart';

const _enter = Duration(milliseconds: 200);
const _exit = Duration(milliseconds: 100);

/// Records the last animation and text each row's builder received, keyed by
/// the message text.
class _Recorder {
  final animations = <String, Animation<double>>{};
  final texts = <String>[];

  RemixFieldMessageTransition get transition => RemixFieldMessageTransition(
    duration: _enter,
    reverseDuration: _exit,
    builder: (context, info, row) {
      animations[info.text] = info.animation;
      texts.add(info.text);
      return FadeTransition(opacity: info.animation, child: row);
    },
  );
}

Widget _field({
  String? helperText,
  String? errorText,
  RemixFieldMessageTransition? transition,
}) => SizedBox(
  width: 300,
  child: RemixTextField(
    label: 'Email',
    helperText: helperText,
    errorText: errorText,
    style: transition == null
        ? const TextFieldStyler.create()
        : TextFieldStyler().messageTransition(transition),
  ),
);

double _height(WidgetTester tester) =>
    tester.getSize(find.byType(RemixTextField)).height;

void main() {
  group('RemixTextField errorText', () {
    testWidgets('shows the helper row and the error row at once', (
      tester,
    ) async {
      await tester.pumpRemixApp(
        _field(helperText: 'We never share it', errorText: 'Email is taken'),
      );

      final helper = tester.getTopLeft(find.text('We never share it'));
      final error = tester.getTopLeft(find.text('Email is taken'));
      expect(error.dy, greaterThan(helper.dy));
    });

    testWidgets('puts the field in its error state', (tester) async {
      await tester.pumpRemixApp(
        SizedBox(
          width: 300,
          child: RemixTextField(
            helperText: 'Helper',
            errorText: 'Required',
            style: TextFieldStyler().variant(
              ContextVariant.widgetState(WidgetState.error),
              TextFieldStyler().helperText(
                TextStyler().color(const Color(0xFFFF0000)),
              ),
            ),
          ),
        ),
      );

      final helper = tester.widget<Text>(find.text('Helper'));
      expect(helper.style?.color, const Color(0xFFFF0000));
    });

    testWidgets('styles the error row from its own slot', (tester) async {
      await tester.pumpRemixApp(
        SizedBox(
          width: 300,
          child: RemixTextField(
            errorText: 'Required',
            style: TextFieldStyler().errorText(
              TextStyler().color(const Color(0xFF00FF00)),
            ),
          ),
        ),
      );

      final error = tester.widget<Text>(find.text('Required'));
      expect(error.style?.color, const Color(0xFF00FF00));
    });

    testWidgets('announces errorText as the error and helperText as a hint', (
      tester,
    ) async {
      final semantics = tester.ensureSemantics();
      try {
        await tester.pumpRemixApp(
          const RemixTextField(
            semanticLabel: 'Email',
            hintText: 'name@example.com',
            helperText: 'We never share it',
            errorText: 'Email is taken',
          ),
        );
        await tester.pump();

        final field = tester.semantics
            .simulatedAccessibilityTraversal()
            .map((node) => node.getSemanticsData())
            .singleWhere((data) => data.flagsCollection.isTextField);
        expect(field.validationResult, SemanticsValidationResult.invalid);
        expect(
          field.hint,
          'name@example.com\nWe never share it\nEmail is taken',
        );
      } finally {
        semantics.dispose();
      }
    });
  });

  group('RemixTextField messageTransition', () {
    testWidgets('without a transition a cleared helper leaves at once', (
      tester,
    ) async {
      await tester.pumpRemixApp(_field(helperText: 'Helper'));
      await tester.pumpRemixApp(_field());

      expect(find.text('Helper'), findsNothing);
    });

    testWidgets('a cleared helper plays its exit, then leaves the layout', (
      tester,
    ) async {
      final recorder = _Recorder();
      await tester.pumpRemixApp(_field(transition: recorder.transition));
      final bare = _height(tester);

      await tester.pumpRemixApp(
        _field(helperText: 'Helper', transition: recorder.transition),
      );
      await tester.pump(_enter);
      await tester.pumpRemixApp(_field(transition: recorder.transition));

      expect(find.text('Helper'), findsOneWidget);
      expect(recorder.animations['Helper']!.status, AnimationStatus.reverse);

      await tester.pump(_exit ~/ 2);
      expect(find.text('Helper'), findsOneWidget);
      expect(recorder.animations['Helper']!.value, closeTo(0.5, 0.01));

      await tester.pumpAndSettle();
      expect(find.text('Helper'), findsNothing);
      expect(_height(tester), bare);
    });

    testWidgets('a new helper plays its entrance', (tester) async {
      final recorder = _Recorder();
      await tester.pumpRemixApp(_field(transition: recorder.transition));
      await tester.pumpRemixApp(
        _field(helperText: 'Helper', transition: recorder.transition),
      );

      expect(recorder.animations['Helper']!.value, 0);
      await tester.pump(_enter ~/ 2);
      expect(recorder.animations['Helper']!.value, closeTo(0.5, 0.01));
      await tester.pump(_enter ~/ 2);
      expect(recorder.animations['Helper']!.value, 1);
    });

    testWidgets('a helper shown when the field first builds starts at rest', (
      tester,
    ) async {
      final recorder = _Recorder();
      await tester.pumpRemixApp(
        _field(helperText: 'Helper', transition: recorder.transition),
      );

      expect(recorder.animations['Helper']!.value, 1);
      expect(tester.hasRunningAnimations, isFalse);
    });

    testWidgets('a new message on a shown row updates it in place', (
      tester,
    ) async {
      final recorder = _Recorder();
      await tester.pumpRemixApp(
        _field(errorText: 'Too short', transition: recorder.transition),
      );
      await tester.pumpRemixApp(
        _field(errorText: 'Too long', transition: recorder.transition),
      );

      expect(find.text('Too short'), findsNothing);
      expect(find.text('Too long'), findsOneWidget);
      expect(
        recorder.animations['Too long'],
        same(recorder.animations['Too short']),
      );
      expect(recorder.animations['Too long']!.value, 1);
    });

    testWidgets('a message that returns mid-exit reverses the same row', (
      tester,
    ) async {
      final recorder = _Recorder();
      await tester.pumpRemixApp(
        _field(errorText: 'Required', transition: recorder.transition),
      );
      await tester.pumpRemixApp(_field(transition: recorder.transition));
      await tester.pump(_exit ~/ 2);
      final animation = recorder.animations['Required']!;
      expect(animation.value, closeTo(0.5, 0.01));

      await tester.pumpRemixApp(
        _field(errorText: 'Required', transition: recorder.transition),
      );
      expect(animation.status, AnimationStatus.forward);
      await tester.pumpAndSettle();
      expect(animation.value, 1);
      expect(find.text('Required'), findsOneWidget);
    });

    testWidgets('under reduced motion rows appear and leave at once', (
      tester,
    ) async {
      final recorder = _Recorder();
      Widget host(String? helperText) => MediaQuery(
        data: const MediaQueryData(disableAnimations: true),
        child: _field(helperText: helperText, transition: recorder.transition),
      );
      await tester.pumpRemixApp(host(null));
      await tester.pumpRemixApp(host('Helper'));
      expect(recorder.animations['Helper']!.value, 1);

      await tester.pumpRemixApp(host(null));
      await tester.pump();
      expect(find.text('Helper'), findsNothing);
    });
  });
}
