import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/remix.dart';
import 'package:registry_source/fortal.dart';

void main() {
  for (final overridden in [false, true]) {
    testWidgets('every effects slot uses the shared focus tokens '
        '(overridden: $overridden)', (tester) async {
      final previous = FocusManager.instance.highlightStrategy;
      FocusManager.instance.highlightStrategy =
          FocusHighlightStrategy.alwaysTraditional;
      addTearDown(() => FocusManager.instance.highlightStrategy = previous);
      await tester.pumpWidget(
        FortalTheme(
          child: MixScope.inherit(
            spaces: overridden
                ? {
                    FortalTokens.focusRingWidth: 3.5,
                    FortalTokens.focusRingOffset: 5.0,
                  }
                : null,
            colors: overridden
                ? {FortalTokens.focus8: const Color(0xFFFF00FF)}
                : null,
            child: WidgetStateProvider(
              states: const {WidgetState.focused},
              child: Builder(
                builder: (context) {
                  final rings = <RemixBoxEffectsSpec?>[
                    for (final variant in FortalButtonVariant.values)
                      fortalButtonStyle(
                        variant: variant,
                      ).build(context).spec.containerEffects,
                    for (final variant in FortalIconButtonVariant.values)
                      fortalIconButtonStyle(
                        variant: variant,
                      ).build(context).spec.containerEffects,
                    for (final variant in FortalRadioVariant.values)
                      fortalRadioStyle(
                        variant: variant,
                      ).build(context).spec.containerEffects,
                    for (final variant in FortalSelectVariant.values)
                      fortalSelectStyle(
                        variant: variant,
                      ).build(context).spec.trigger.spec.containerEffects,
                    fortalCheckboxStyle().build(context).spec.containerEffects,
                    fortalSwitchStyle().build(context).spec.trackEffects,
                    fortalSliderStyle().build(context).spec.thumbFocusEffects,
                    fortalTextFieldStyle().build(context).spec.containerEffects,
                    fortalTextAreaStyle().build(context).spec.containerEffects,
                    fortalCardStyle().build(context).spec.containerEffects,
                    fortalLinkStyle(
                      context,
                      actionable: true,
                    ).build(context).spec.containerEffects,
                    fortalSegmentedControlStyle()
                        .build(context)
                        .spec
                        .item
                        .spec
                        .containerEffects,
                    fortalToggleStyle().build(context).spec.containerEffects,
                    fortalToggleGroupStyle()
                        .build(context)
                        .spec
                        .item
                        .spec
                        .containerEffects,
                    fortalTabStyle().build(context).spec.containerEffects,
                    fortalDisclosureStyle().build(context).spec.triggerEffects,
                    fortalAccordionStyle().build(context).spec.triggerEffects,
                  ];
                  for (final ring in rings) {
                    expect(
                      ring?.outline.width,
                      FortalTokens.focusRingWidth.resolve(context),
                    );
                    expect(
                      ring?.outlineOffset,
                      FortalTokens.focusRingOffset.resolve(context),
                    );
                    expect(
                      ring?.outline.color,
                      FortalTokens.focus8.resolve(context),
                    );
                  }
                  final slider = fortalSliderStyle()
                      .build(context)
                      .spec
                      .thumbFocusEffects!;
                  expect(slider.behindContent?.shadows ?? [], isEmpty);
                  expect(slider.overContent?.shadows ?? [], isEmpty);
                  return const SizedBox.shrink();
                },
              ),
            ),
          ),
        ),
      );
    });
  }

  testWidgets('disabled controls suppress the shared outline', (tester) async {
    await tester.pumpWidget(
      FortalTheme(
        child: WidgetStateProvider(
          states: const {WidgetState.focused, WidgetState.disabled},
          child: Builder(
            builder: (context) {
              final rings = <RemixBoxEffectsSpec?>[
                fortalSliderStyle().build(context).spec.thumbFocusEffects,
                fortalTextFieldStyle().build(context).spec.containerEffects,
                fortalTextAreaStyle().build(context).spec.containerEffects,
                fortalToggleStyle().build(context).spec.containerEffects,
                fortalToggleGroupStyle()
                    .build(context)
                    .spec
                    .item
                    .spec
                    .containerEffects,
                fortalTabStyle().build(context).spec.containerEffects,
                fortalDisclosureStyle().build(context).spec.triggerEffects,
                fortalAccordionStyle().build(context).spec.triggerEffects,
              ];
              for (final ring in rings) {
                expect(ring?.outline.style, BorderStyle.none);
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  });
}
