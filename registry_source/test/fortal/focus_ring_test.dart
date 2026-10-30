import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/remix.dart';
import 'package:registry_source/fortal.dart';

void main() {
  testWidgets(
    'the common ring resolves its width, gap and solid color from tokens',
    (tester) async {
      await tester.pumpWidget(
        FortalTheme(
          child: MixScope(
            tokens: {
              FortalTokens.focusRingWidth: 3.0,
              FortalTokens.focusRingOffset: 5.0,
              FortalTokens.focus8: const Color(0xff123456),
            },
            child: Builder(
              builder: (context) {
                final ring = fortalFocusOutline().resolve(context);
                expect(ring.outline.width, 3);
                expect(ring.outlineOffset, 5);
                expect(ring.outline.color, const Color(0xff123456));
                return const SizedBox();
              },
            ),
          ),
        ),
      );
    },
  );

  for (final dark in [false, true]) {
    testWidgets(
      '${dark ? 'dark' : 'light'}: all effect-capable controls use the same ring',
      (tester) async {
        final previous = FocusManager.instance.highlightStrategy;
        FocusManager.instance.highlightStrategy =
            FocusHighlightStrategy.alwaysTraditional;
        addTearDown(() => FocusManager.instance.highlightStrategy = previous);
        await tester.pumpWidget(
          FortalTheme(
            mode: dark ? .dark : .light,
            child: WidgetStateProvider(
              states: const {WidgetState.focused},
              child: Builder(
                builder: (context) {
                  final expected = FortalTokens.focus8.resolve(context);
                  final rings = <RemixBoxEffectsSpec?>[
                    fortalButtonStyle().build(context).spec.containerEffects,
                    fortalIconButtonStyle()
                        .build(context)
                        .spec
                        .containerEffects,
                    fortalCheckboxStyle().build(context).spec.containerEffects,
                    fortalRadioStyle().build(context).spec.containerEffects,
                    fortalSwitchStyle().build(context).spec.trackEffects,
                    fortalSliderStyle().build(context).spec.thumbFocusEffects,
                    fortalTextFieldStyle().build(context).spec.containerEffects,
                    fortalTextAreaStyle().build(context).spec.containerEffects,
                    fortalSelectStyle()
                        .build(context)
                        .spec
                        .trigger
                        .spec
                        .containerEffects,
                    fortalSegmentedControlStyle()
                        .build(context)
                        .spec
                        .item
                        .spec
                        .containerEffects,
                    fortalCardStyle().build(context).spec.containerEffects,
                    fortalLinkStyle(
                      context,
                      actionable: true,
                    ).build(context).spec.containerEffects,
                  ];
                  for (final ring in rings) {
                    expect(ring?.outline.color, expected);
                    expect(ring?.outline.width, 2);
                    expect(ring?.outlineOffset, 2);
                  }
                  return const SizedBox();
                },
              ),
            ),
          ),
        );
      },
    );
  }

  testWidgets('compact painted buttons expose a 40px tappable target', (
    tester,
  ) async {
    var taps = 0;
    await tester.pumpWidget(
      FortalTheme(
        scaling: .percent90,
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: Center(
            child: FortalButton(
              size: .size1,
              label: 'Save',
              onPressed: () => taps++,
            ),
          ),
        ),
      ),
    );
    final rect = tester.getRect(find.byType(RemixButton));
    expect(rect.height, greaterThanOrEqualTo(40));
    expect(rect.width, greaterThanOrEqualTo(40));
    // This point is inside the target, outside the 21.6px painted button.
    await tester.tapAt(rect.center + const Offset(0, 17));
    expect(taps, 1);
  });

  testWidgets('compact sliders accept taps outside their painted height', (
    tester,
  ) async {
    for (final excludeSemantics in [false, true]) {
      double? changed;
      await tester.pumpWidget(
        FortalTheme(
          scaling: .percent90,
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Center(
              child: SizedBox(
                width: 200,
                child: FortalSlider(
                  size: .size1,
                  value: .5,
                  excludeSemantics: excludeSemantics,
                  onChanged: (value) => changed = value,
                ),
              ),
            ),
          ),
        ),
      );
      final rect = tester.getRect(find.byType(RemixSlider));
      expect(rect.height, greaterThanOrEqualTo(40));
      // The gesture target includes this point, well below the compact thumb.
      await tester.tapAt(rect.center + const Offset(40, 17));
      expect(changed, greaterThan(.5));
    }
  });

  testWidgets(
    'focus does not change layout or replace an outline toggle border',
    (tester) async {
      final node = FocusNode();
      addTearDown(node.dispose);
      final previous = FocusManager.instance.highlightStrategy;
      FocusManager.instance.highlightStrategy =
          FocusHighlightStrategy.alwaysTraditional;
      addTearDown(() => FocusManager.instance.highlightStrategy = previous);
      await tester.pumpWidget(
        FortalTheme(
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Center(
              child: FortalToggle.outline(
                label: 'Toggle',
                selected: false,
                focusNode: node,
                onChanged: (_) {},
              ),
            ),
          ),
        ),
      );
      final before = tester.getSize(find.byType(RemixToggle));
      node.requestFocus();
      await tester.pumpAndSettle();
      expect(tester.getSize(find.byType(RemixToggle)), before);
      expect(tester.takeException(), isNull);
    },
  );
}
