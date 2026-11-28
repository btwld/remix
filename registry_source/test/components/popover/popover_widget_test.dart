import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registry_source/fortal.dart';

import '../../helpers/contrast.dart';
import '../../helpers/test_helpers.dart';

void main() {
  testWidgets('the default panel is 192 to 352px, 20px corners, floating', (
    tester,
  ) async {
    final resolved = await resolveInFortalTheme(
      tester,
      (context) => fortalPopoverStyle().build(context),
    );
    final box = resolved.spec.container.spec;
    final decoration = box.decoration! as BoxDecoration;

    expect(box.constraints, const BoxConstraints(minWidth: 192, maxWidth: 352));
    expect(box.padding, const EdgeInsets.all(16));
    expect(decoration.borderRadius, BorderRadius.circular(20));
    expect(decoration.boxShadow, hasLength(2));
    expect(resolved.spec.containerEffects?.backdropBlur, isNull);
    expect(resolved.spec.panelTransition!.duration, FortalMotion.spring);
    expect(resolved.spec.panelTransition!.reverseDuration, FortalMotion.fast);
  });

  for (final mode in [FortalThemeMode.light, FortalThemeMode.dark]) {
    testWidgets('theme high contrast lifts the panel edge to 3:1 '
        '(${mode.name})', (tester) async {
      final ratios = <double>[];
      for (final highContrast in [false, true]) {
        await tester.pumpRemixApp(
          Builder(
            builder: (context) {
              final box = fortalPopoverStyle()
                  .build(context)
                  .spec
                  .container
                  .spec;
              final decoration = box.decoration! as BoxDecoration;
              ratios.add(
                contrastRatio(
                  (decoration.border! as Border).top.color,
                  decoration.color!,
                ),
              );
              return const SizedBox.shrink();
            },
          ),
          mode: mode,
          highContrast: highContrast,
        );
      }
      expect(ratios.first, lessThan(3));
      expect(ratios.last, greaterThanOrEqualTo(3));
    });
  }

  testWidgets('FortalPopover supplies the themed overlay style', (
    tester,
  ) async {
    await tester.pumpRemixApp(
      const FortalPopover(
        popoverChild: Text('Fortal content'),
        child: Text('Open Fortal popover'),
      ),
    );

    await tester.tap(find.text('Open Fortal popover'));
    await tester.pumpAndSettle();

    expect(find.text('Fortal content'), findsOneWidget);
  });

  group('motion', () {
    Future<void> open(WidgetTester tester, {bool reduceMotion = false}) async {
      await tester.pumpRemixApp(
        MediaQuery(
          data: MediaQueryData(disableAnimations: reduceMotion),
          child: const Align(
            alignment: Alignment.topLeft,
            child: FortalPopover(
              popoverChild: SizedBox(
                width: 300,
                height: 100,
                child: Text('Panel'),
              ),
              child: Text('Open'),
            ),
          ),
        ),
      );
      await tester.tap(find.text('Open'));
      await tester.pump();
    }

    Finder panel() => find.byWidgetPredicate(
      (widget) => widget is SizedBox && widget.width == 300,
    );

    double opacity(WidgetTester tester) => tester
        .widget<Opacity>(
          find.ancestor(of: panel(), matching: find.byType(Opacity)).first,
        )
        .opacity;

    testWidgets('slides 5px from the trigger and grows from its corner', (
      tester,
    ) async {
      final semantics = tester.ensureSemantics();
      await open(tester);
      expect(opacity(tester), 0);
      expect(find.bySemanticsLabel('Panel'), findsOneWidget);
      semantics.dispose();

      await tester.pump(const Duration(milliseconds: 75));
      final spring = FortalSpringCurve.css.transform(75 / 440);
      expect(
        opacity(tester),
        closeTo(FortalMotion.easeEnter.transform(.5), .02),
      );
      final mid = tester.getRect(panel());
      await tester.pumpAndSettle();
      final rest = tester.getRect(panel());

      final scale = .97 + .03 * spring;
      // The content sits inside 16px padding and a 1px border, so the scale
      // around the panel's top start corner also pulls it in by 17px * (1 - s).
      final inset = 17 * (1 - scale);
      expect(mid.width / rest.width, closeTo(scale, .002));
      expect(
        mid.left - rest.left,
        closeTo(-inset, .05),
        reason: 'grows from the start corner',
      );
      expect(
        mid.top - rest.top,
        closeTo(-5 * (1 - spring) - inset, .05),
        reason: 'starts above its place, toward the trigger',
      );
    });

    testWidgets('closes in 150ms, halfway back and to 98%', (tester) async {
      await open(tester);
      await tester.pumpAndSettle();
      final rest = tester.getRect(panel());

      await tester.tapAt(const Offset(700, 500));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 75));
      final p = FortalMotion.easeStandard.transform(.5);
      expect(opacity(tester), closeTo(1 - p, .03));
      expect(
        tester.getRect(panel()).width / rest.width,
        closeTo(1 - .02 * p, .002),
      );
      await tester.pump(const Duration(milliseconds: 80));
      expect(panel(), findsNothing);
    });

    testWidgets('only fades, over 100ms, under reduced motion', (tester) async {
      await open(tester, reduceMotion: true);
      await tester.pump(const Duration(milliseconds: 50));
      expect(opacity(tester), closeTo(.5, .02));
      final mid = tester.getRect(panel());
      await tester.pumpAndSettle();
      expect(tester.getRect(panel()), mid);
    });
  });
}
