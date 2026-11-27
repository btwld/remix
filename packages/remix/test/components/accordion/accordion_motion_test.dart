import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/remix.dart';

import 'package:remix/src/utilities/remix_path_icon.dart';

import '../../helpers/motion_harness.dart';

const _chevron = IconData(0xe5cf);

Widget _accordion({AccordionStyler? style, Widget child = const _Counter()}) =>
    RemixAccordionGroup<String>(
      controller: RemixAccordionController<String>(),
      child: RemixAccordion<String>(
        value: 'a',
        title: 'Details',
        style: style ?? AccordionStyler(),
        child: child,
      ),
    );

Future<void> _toggle(WidgetTester tester) async {
  await tester.tap(find.text('Details'));
  await tester.pump();
}

double _opacity(WidgetTester tester) =>
    effectiveOpacity(tester, find.byType(_Counter));

void main() {
  testWidgets('opens linearly over 200 ms by default', (tester) async {
    await MotionHarness.pump(tester, _accordion());

    await _toggle(tester);
    await tester.pump(const Duration(milliseconds: 100));

    expect(_opacity(tester), moreOrLessEquals(0.5, epsilon: 0.02));
    await tester.pump(const Duration(milliseconds: 101));
    expect(_opacity(tester), 1);
  });

  testWidgets('contentMotion sets the open timing', (tester) async {
    await MotionHarness.pump(
      tester,
      _accordion(
        style: AccordionStyler(
          contentMotion: AnimationConfig.linear(
            const Duration(milliseconds: 400),
          ),
        ),
      ),
    );

    await _toggle(tester);
    await tester.pump(const Duration(milliseconds: 100));

    expect(_opacity(tester), moreOrLessEquals(0.25, epsilon: 0.02));
  });

  testWidgets('a reversible contentMotion closes on its reverse timing', (
    tester,
  ) async {
    await MotionHarness.pump(
      tester,
      _accordion(
        style: AccordionStyler(
          contentMotion: AnimationConfig.reversible(
            AnimationConfig.linear(const Duration(milliseconds: 400)),
            reverse: AnimationConfig.linear(const Duration(milliseconds: 100)),
          ),
        ),
      ),
    );
    await _toggle(tester);
    await tester.pumpAndSettle();

    await _toggle(tester);
    await tester.pump(const Duration(milliseconds: 50));

    expect(_opacity(tester), moreOrLessEquals(0.5, epsilon: 0.02));
    await tester.pump(const Duration(milliseconds: 51));
    expect(find.byType(_Counter), findsNothing);
  });

  testWidgets('a spring contentMotion opens and settles', (tester) async {
    await MotionHarness.pump(
      tester,
      _accordion(
        style: AccordionStyler(
          contentMotion: AnimationConfig.springDescription(
            mass: 1,
            stiffness: 200,
            damping: 30,
          ),
        ),
      ),
    );

    await _toggle(tester);
    await tester.pump(const Duration(milliseconds: 60));
    expect(_opacity(tester), inExclusiveRange(0, 1));

    await tester.pumpAndSettle();
    expect(_opacity(tester), 1);
  });

  testWidgets('reopening mid-close turns the same panel around', (
    tester,
  ) async {
    await MotionHarness.pump(tester, _accordion());
    await _toggle(tester);
    await tester.pumpAndSettle();
    final state = tester.state(find.byType(_Counter));

    await _toggle(tester);
    await tester.pump(const Duration(milliseconds: 100));
    final midway = _opacity(tester);
    await _toggle(tester);
    await tester.pump(const Duration(milliseconds: 20));

    expect(find.byType(_Counter), findsOneWidget);
    expect(tester.state(find.byType(_Counter)), same(state));
    expect(_opacity(tester), moreOrLessEquals(midway + 0.1, epsilon: 0.02));
    // The way back covers half the span, so it takes half the duration.
    await tester.pump(const Duration(milliseconds: 81));
    expect(_opacity(tester), 1);
  });

  testWidgets('reduced motion leaves a narrow panel centered in its item', (
    tester,
  ) async {
    final harness = await MotionHarness.pump(
      tester,
      SizedBox(width: 400, child: _accordion()),
    );
    await harness.set(MotionRequest.platform, enabled: true);
    await _toggle(tester);

    expect(
      tester.getCenter(find.byType(_Counter)).dx,
      tester.getCenter(find.byType(RemixAccordion<String>)).dx,
    );
  });

  testWidgets('the default trigger draws the style icon in place of plus', (
    tester,
  ) async {
    await MotionHarness.pump(
      tester,
      _accordion(
        style: AccordionStyler().trailingIcon(IconStyler().icon(_chevron)),
      ),
    );

    expect(find.byIcon(_chevron), findsOneWidget);
    expect(find.byType(RemixPathIcon), findsNothing);

    await _toggle(tester);
    await tester.pumpAndSettle();
    expect(find.byIcon(_chevron), findsOneWidget);
    expect(find.byType(RemixPathIcon), findsNothing);
  });

  testWidgets('a trailingIcon argument still wins over the style icon', (
    tester,
  ) async {
    await MotionHarness.pump(
      tester,
      RemixAccordionGroup<String>(
        controller: RemixAccordionController<String>(),
        child: RemixAccordion<String>(
          value: 'a',
          title: 'Details',
          trailingIcon: const IconData(0xe145),
          style: AccordionStyler().trailingIcon(IconStyler().icon(_chevron)),
          child: const _Counter(),
        ),
      ),
    );

    expect(find.byIcon(const IconData(0xe145)), findsOneWidget);
    expect(find.byIcon(_chevron), findsNothing);
  });
}

class _Counter extends StatefulWidget {
  const _Counter();

  @override
  State<_Counter> createState() => _CounterState();
}

class _CounterState extends State<_Counter> {
  @override
  Widget build(BuildContext context) => const Text('Panel');
}
