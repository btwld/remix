import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/remix.dart';
import 'package:registry_source/fortal.dart';

/// Radix draws every focus ring 2px wide. Outward rings sit 2px off the
/// element; inset rings (fields, soft/outline buttons, cards, select) sit -1px
/// inside it and never move with the offset token.
const _radixWidth = 2.0;
const _radixOffset = 2.0;
const _insetOffset = -1.0;

/// Radix's slider thumb rings `0 0 0 3px accent-3, 0 0 0 5px focus-8`: a 3px
/// halo, then the ring on top of it. The halo is not `outline-offset: 2px`, so
/// it does not follow the offset token.
const _sliderHalo = 3.0;

/// Overrides that differ from Radix and from each other, so a ring that reads
/// the wrong token (or a literal) cannot match by accident.
const _widthOverride = 3.5;
const _offsetOverride = 5.0;

void main() {
  late FocusHighlightStrategy previousStrategy;

  setUp(() {
    previousStrategy = FocusManager.instance.highlightStrategy;
    FocusManager.instance.highlightStrategy =
        FocusHighlightStrategy.alwaysTraditional;
  });

  tearDown(() => FocusManager.instance.highlightStrategy = previousStrategy);

  testWidgets('focus outlines resolve the ring tokens', (tester) async {
    // The first pass keeps the theme's own token values, which must equal
    // Radix; the second overrides both tokens and the outlines must follow.
    for (final (width, offset, overridden) in [
      (_radixWidth, _radixOffset, false),
      (_widthOverride, _offsetOverride, true),
    ]) {
      final rings = await _resolveFocused(tester, overridden: overridden, (
        context,
      ) {
        RemixBoxEffectsSpec effects<S extends Spec<S>>(
          Style<S> style,
          RemixBoxEffectsSpec? Function(S spec) slot,
        ) => slot(style.build(context).spec)!;

        RemixBoxEffectsSpec selectTrigger(FortalSelectVariant variant) =>
            effects(
              fortalSelectStyle(variant: variant),
              (spec) => spec.trigger.spec.containerEffects,
            );

        return (
          outward: {
            'solid button': effects(
              fortalButtonStyle(variant: .solid),
              (spec) => spec.containerEffects,
            ),
            'checkbox': effects(
              fortalCheckboxStyle(),
              (spec) => spec.containerEffects,
            ),
            'radio': effects(
              fortalRadioStyle(),
              (spec) => spec.containerEffects,
            ),
            'switch': effects(fortalSwitchStyle(), (spec) => spec.trackEffects),
            'link': effects(
              fortalLinkStyle(context, actionable: true),
              (spec) => spec.containerEffects,
            ),
          },
          inset: {
            'soft button': effects(
              fortalButtonStyle(variant: .soft),
              (spec) => spec.containerEffects,
            ),
            'text field': effects(
              fortalTextFieldStyle(),
              (spec) => spec.containerEffects,
            ),
            'card': effects(fortalCardStyle(), (spec) => spec.containerEffects),
            'surface select': selectTrigger(.surface),
            'soft select': selectTrigger(.soft),
            'ghost select': selectTrigger(.ghost),
          },
        );
      });

      for (final MapEntry(key: name, value: effects) in rings.outward.entries) {
        final reason = '$name at width $width, offset $offset';
        expect(effects.outline.width, width, reason: reason);
        expect(effects.outlineOffset, offset, reason: reason);
      }
      for (final MapEntry(key: name, value: effects) in rings.inset.entries) {
        final reason = '$name at width $width, offset $offset';
        expect(effects.outline.width, width, reason: reason);
        expect(effects.outlineOffset, _insetOffset, reason: reason);
      }
    }
  });

  testWidgets('slider thumb ring follows the width token past its halo', (
    tester,
  ) async {
    for (final (width, overridden) in [
      (_radixWidth, false),
      (_widthOverride, true),
    ]) {
      for (final variant in FortalSliderVariant.values) {
        final reason = '$variant at width $width';
        final ring = await _resolveFocused(
          tester,
          overridden: overridden,
          (context) => fortalSliderStyle(
            variant: variant,
          ).build(context).spec.thumbFocusEffects!,
        );

        // The ring starts where the halo ends and is as wide as the token, so
        // its outer edge is the halo plus the width: 5px at Radix's 2px.
        expect(ring.overContent!.shadows, hasLength(1), reason: reason);
        expect(
          ring.overContent!.shadows.single.spreadRadius,
          _sliderHalo,
          reason: reason,
        );
        expect(ring.outlineOffset, _sliderHalo, reason: reason);
        expect(ring.outline.width, width, reason: reason);
        expect(
          ring.outlineOffset + ring.outline.width,
          _sliderHalo + width,
          reason: reason,
        );
      }
    }
  });

  testWidgets(
    'a disabled slider draws no thumb ring even when forced focused',
    (tester) async {
      final ring = await _resolveFocused(
        tester,
        overridden: true,
        states: {WidgetState.focused, WidgetState.disabled},
        (context) => fortalSliderStyle().build(context).spec.thumbFocusEffects!,
      );

      expect(ring.outline.style, BorderStyle.none);
      expect(ring.overContent!.shadows, isEmpty);
    },
  );

  testWidgets('inside-border rings follow the width token', (tester) async {
    for (final (width, overridden) in [
      (_radixWidth, false),
      (_widthOverride, true),
    ]) {
      final widths = await _resolveFocused(tester, overridden: overridden, (
        context,
      ) {
        return _ringBoxes(
          context,
        ).map((name, box) => MapEntry(name, _boxWidth(box)));
      });

      expect(widths, {for (final name in widths.keys) name: width});
    }
  });

  testWidgets('inside-border rings are drawn only while focused', (
    tester,
  ) async {
    // Guards the test above: the border it reads is the focus ring, not a
    // frame the control always has.
    final widths = await _resolveFocused(
      tester,
      overridden: false,
      states: {},
      (context) {
        return _ringBoxes(context).values.map(_boxWidth);
      },
    );

    expect(widths, everyElement(isNull));
  });
}

/// The box that carries each inside-border focus ring.
Map<String, BoxSpec?> _ringBoxes(BuildContext context) => {
  'toggle': fortalToggleStyle().build(context).spec.container.spec.box?.spec,
  'toggle group item': fortalToggleGroupStyle()
      .build(context)
      .spec
      .item
      .spec
      .container
      .spec
      .box
      ?.spec,
  'tab': fortalTabStyle().build(context).spec.container.spec.box?.spec,
  'disclosure trigger': fortalDisclosureStyle()
      .build(context)
      .spec
      .trigger
      .spec,
  'accordion trigger': fortalAccordionStyle()
      .build(context)
      .spec
      .trigger
      .spec
      .box
      ?.spec,
};

/// The width of [box]'s border, or null when it has none.
double? _boxWidth(BoxSpec? box) {
  final border = (box?.decoration as BoxDecoration?)?.border;
  return border == null ? null : (border as Border).top.width;
}

/// Reads [read] under [FortalTheme] with [states] active, at the theme's own
/// ring tokens or, when [overridden], at [_widthOverride] and [_offsetOverride].
Future<T> _resolveFocused<T>(
  WidgetTester tester,
  T Function(BuildContext context) read, {
  required bool overridden,
  Set<WidgetState> states = const {WidgetState.focused},
}) async {
  late T result;
  await tester.pumpWidget(
    FortalTheme(
      child: MixScope.inherit(
        spaces: overridden
            ? {
                FortalTokens.focusRingWidth: _widthOverride,
                FortalTokens.focusRingOffset: _offsetOverride,
              }
            : null,
        child: WidgetStateProvider(
          states: states,
          child: Builder(
            builder: (context) {
              result = read(context);
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    ),
  );
  return result;
}
