import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/remix.dart';
import 'package:registry_source/fortal.dart';

import '../../helpers/test_helpers.dart';

// The container owns the rounded foreground frame and fill. Trigger and content
// clip their own painted children so the shared focus outline can extend beyond
// the panel. Expanded parts join without rounding their shared edge. These tests
// also pin the content font size so a passage never exceeds its title.
void main() {
  group('panel anatomy', () {
    for (final (size, radius) in const [
      (FortalAccordionSize.size1, 6.0),
      (FortalAccordionSize.size2, 8.0),
      (FortalAccordionSize.size3, 12.0),
    ]) {
      testWidgets('${size.name} container radius and clip are pinned', (
        tester,
      ) async {
        final spec = await _resolve(tester, fortalAccordionStyle(size: size));
        final box = spec.container.spec;

        expect(_radius(box), radius);
        expect(box.clipBehavior, Clip.none);
        expect(spec.trigger.spec.box?.spec.clipBehavior, Clip.antiAlias);
      });
    }

    testWidgets('surface container carries the gray panel border', (
      tester,
    ) async {
      final tokens = await _tokens(tester);
      final spec = await _resolve(tester, fortalAccordionStyle());
      final box = spec.container.spec;
      final border = _foregroundBorder(box);

      expect(border?.top.color, tokens.gray6);
      expect(border?.top.width, 1);
      expect((box.decoration as BoxDecoration).border, isNull);
      expect(box.padding, const EdgeInsets.all(1));
      expect(
        (box.foregroundDecoration as BoxDecoration).borderRadius,
        (box.decoration as BoxDecoration).borderRadius,
      );
    });

    testWidgets('soft container carries the accent panel border', (
      tester,
    ) async {
      final tokens = await _tokens(tester);
      final spec = await _resolve(tester, fortalAccordionStyle(variant: .soft));
      final border = _foregroundBorder(spec.container.spec);

      expect(border?.top.color, tokens.accent6);
    });

    testWidgets('expanded trigger rounds only the top corners to join '
        'content with no notch', (tester) async {
      await tester.pumpRemixApp(
        RemixAccordionGroup<String>(
          controller: RemixAccordionController<String>(),
          initialExpandedValues: const ['item'],
          child: const FortalAccordion<String>(
            value: 'item',
            title: 'Panel title',
            child: Text('Panel body'),
          ),
        ),
      );
      await tester.pumpAndSettle();
      final spec = tester.resolvedSpecOf<AccordionSpec>(
        find.text('Panel title'),
      );
      final triggerBox =
          spec.trigger.spec.box?.spec.decoration as BoxDecoration?;

      final radii = triggerBox!.borderRadius!.resolve(TextDirection.ltr);
      expect(radii.topLeft.x, 8);
      expect(radii.bottomLeft.x, 0);
    });

    testWidgets('collapsed trigger rounds every corner', (tester) async {
      final spec = await _resolve(tester, fortalAccordionStyle());
      final triggerBox =
          spec.trigger.spec.box?.spec.decoration as BoxDecoration?;

      expect(triggerBox?.borderRadius, BorderRadius.circular(8));
    });

    testWidgets('an expanded item renders one continuous panel: the container '
        'decoration wraps both the trigger and the content text', (
      tester,
    ) async {
      await tester.pumpRemixApp(
        RemixAccordionGroup<String>(
          controller: RemixAccordionController<String>(),
          initialExpandedValues: const ['item1'],
          child: FortalAccordion<String>(
            value: 'item1',
            title: 'Panel title',
            child: const Text('Panel body'),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Panel title'), findsOneWidget);
      expect(find.text('Panel body'), findsOneWidget);

      final containerSpec = tester
          .resolvedSpecOf<AccordionSpec>(find.text('Panel title'))
          .container
          .spec;
      final containerDecoration = containerSpec.decoration as BoxDecoration;

      // The container is the single decorated ancestor above both the trigger
      // and content; its foreground decoration carries the visible frame.
      final containerBoxes = find.byWidgetPredicate(
        (widget) =>
            widget is DecoratedBox && widget.decoration == containerDecoration,
      );
      expect(containerBoxes, findsOneWidget);
      expect(
        find.descendant(of: containerBoxes, matching: find.text('Panel title')),
        findsOneWidget,
      );
      expect(
        find.descendant(of: containerBoxes, matching: find.text('Panel body')),
        findsOneWidget,
      );
    });

    for (final size in FortalAccordionSize.values) {
      testWidgets('${size.name} content font size is pinned to 14px and never '
          "exceeds its own trigger's title", (tester) async {
        final spec = await _resolve(tester, fortalAccordionStyle(size: size));
        final titleFontSize = spec.title.spec.style?.fontSize;
        final contentFontSize = _defaultTextStyleModifier(
          spec.content,
        ).style.fontSize;

        expect(contentFontSize, 14.0);
        expect(titleFontSize, isNotNull);
        expect(contentFontSize, lessThanOrEqualTo(titleFontSize!));
      });
    }

    testWidgets('content font size scales with the theme', (tester) async {
      final spec = await _resolve(
        tester,
        fortalAccordionStyle(),
        scaling: .percent110,
      );

      expect(
        _defaultTextStyleModifier(spec.content).style.fontSize,
        closeTo(15.4, 1e-9),
      );
    });
  });
}

DefaultTextStyleModifier _defaultTextStyleModifier(StyleSpec<BoxSpec> box) {
  return (box.widgetModifiers ?? const [])
      .whereType<DefaultTextStyleModifier>()
      .single;
}

Border? _foregroundBorder(BoxSpec box) =>
    (box.foregroundDecoration as BoxDecoration?)?.border as Border?;

double _radius(BoxSpec box) => (box.decoration as BoxDecoration).borderRadius!
    .resolve(TextDirection.ltr)
    .topLeft
    .x;

Future<AccordionSpec> _resolve(
  WidgetTester tester,
  AccordionStyler style, {
  FortalScaling scaling = .percent100,
  Set<WidgetState> states = const {},
}) async {
  late AccordionSpec result;
  await tester.pumpWidget(
    FortalTheme(
      mode: .light,
      scaling: scaling,
      child: WidgetsApp(
        color: Colors.black,
        builder: (context, child) => WidgetStateStyleOverride(
          states: states,
          child: Builder(
            builder: (context) {
              result = style.build(context).spec;
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    ),
  );
  return result;
}

Future<({Color gray6, Color accent6})> _tokens(WidgetTester tester) async {
  late ({Color gray6, Color accent6}) result;
  await tester.pumpWidget(
    FortalTheme(
      mode: .light,
      child: WidgetsApp(
        color: Colors.black,
        builder: (context, child) {
          Color token(ColorToken value) => MixScope.tokenOf(value, context);
          result = (
            gray6: token(FortalTokens.gray6),
            accent6: token(FortalTokens.accent6),
          );
          return const SizedBox.shrink();
        },
      ),
    ),
  );
  return result;
}
