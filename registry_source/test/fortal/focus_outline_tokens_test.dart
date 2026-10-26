import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/remix.dart';
import 'package:registry_source/fortal.dart';

/// Radix draws every focus ring 2px wide. Outward rings sit 2px off the
/// element; inset rings (fields, soft/outline buttons, cards) sit -1px inside
/// it and never move with the offset token.
const _radixWidth = 2.0;
const _radixOffset = 2.0;
const _insetOffset = -1.0;

void main() {
  testWidgets('focus outlines resolve the ring tokens', (tester) async {
    final previous = FocusManager.instance.highlightStrategy;
    FocusManager.instance.highlightStrategy =
        FocusHighlightStrategy.alwaysTraditional;
    addTearDown(() => FocusManager.instance.highlightStrategy = previous);

    // The first pass keeps the theme's own token values, which must equal
    // Radix; the second overrides both tokens and the outlines must follow.
    for (final (width, offset, overridden) in [
      (_radixWidth, _radixOffset, false),
      (3.5, 5.0, true),
    ]) {
      late RemixBoxEffectsSpec button;
      late RemixBoxEffectsSpec insetButton;
      late RemixBoxEffectsSpec checkbox;
      late RemixBoxEffectsSpec radio;
      late RemixBoxEffectsSpec toggleSwitch;
      late RemixBoxEffectsSpec field;
      late RemixBoxEffectsSpec card;
      late RemixBoxEffectsSpec link;

      await tester.pumpWidget(
        FortalTheme(
          child: MixScope.inherit(
            spaces: overridden
                ? {
                    FortalTokens.focusRingWidth: width,
                    FortalTokens.focusRingOffset: offset,
                  }
                : null,
            child: WidgetStateProvider(
              states: const {WidgetState.focused},
              child: Builder(
                builder: (context) {
                  RemixBoxEffectsSpec effects<S extends Spec<S>>(
                    Style<S> style,
                    RemixBoxEffectsSpec? Function(S spec) slot,
                  ) => slot(style.build(context).spec)!;

                  button = effects(
                    fortalButtonStyle(variant: .solid),
                    (spec) => spec.containerEffects,
                  );
                  insetButton = effects(
                    fortalButtonStyle(variant: .soft),
                    (spec) => spec.containerEffects,
                  );
                  checkbox = effects(
                    fortalCheckboxStyle(),
                    (spec) => spec.containerEffects,
                  );
                  radio = effects(
                    fortalRadioStyle(),
                    (spec) => spec.containerEffects,
                  );
                  toggleSwitch = effects(
                    fortalSwitchStyle(),
                    (spec) => spec.trackEffects,
                  );
                  field = effects(
                    fortalTextFieldStyle(),
                    (spec) => spec.containerEffects,
                  );
                  card = effects(
                    fortalCardStyle(),
                    (spec) => spec.containerEffects,
                  );
                  link = effects(
                    fortalLinkStyle(context, actionable: true),
                    (spec) => spec.containerEffects,
                  );
                  return const SizedBox.shrink();
                },
              ),
            ),
          ),
        ),
      );

      final outward = {
        'solid button': button,
        'checkbox': checkbox,
        'radio': radio,
        'switch': toggleSwitch,
        'link': link,
      };
      final inset = {
        'soft button': insetButton,
        'text field': field,
        'card': card,
      };
      for (final MapEntry(key: name, value: effects) in outward.entries) {
        final reason = '$name at width $width, offset $offset';
        expect(effects.outline.width, width, reason: reason);
        expect(effects.outlineOffset, offset, reason: reason);
      }
      for (final MapEntry(key: name, value: effects) in inset.entries) {
        final reason = '$name at width $width, offset $offset';
        expect(effects.outline.width, width, reason: reason);
        expect(effects.outlineOffset, _insetOffset, reason: reason);
      }
    }
  });
}
