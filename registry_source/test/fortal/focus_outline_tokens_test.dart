import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/remix.dart';
import 'package:registry_source/fortal.dart';

/// Shared ring defaults and deliberately distinct overrides.
const _defaultWidth = 2.0;
const _defaultOffset = 2.0;

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
    // Fortal; the second overrides both tokens and the outlines must follow.
    for (final (width, offset, overridden) in [
      (_defaultWidth, _defaultOffset, false),
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
          controls: {
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
            'solid icon button': effects(
              fortalIconButtonStyle(variant: .solid),
              (spec) => spec.containerEffects,
            ),
          },
          otherControls: {
            'soft button': effects(
              fortalButtonStyle(variant: .soft),
              (spec) => spec.containerEffects,
            ),
            'text field': effects(
              fortalTextFieldStyle(),
              (spec) => spec.containerEffects,
            ),
            'soft icon button': effects(
              fortalIconButtonStyle(variant: .soft),
              (spec) => spec.containerEffects,
            ),
            'card': effects(fortalCardStyle(), (spec) => spec.containerEffects),
            'segmented control item': effects(
              fortalSegmentedControlStyle(),
              (spec) => spec.item.spec.containerEffects,
            ),
            'surface select': selectTrigger(.surface),
            'soft select': selectTrigger(.soft),
            'ghost select': selectTrigger(.ghost),
          },
        );
      });

      for (final MapEntry(key: name, value: effects)
          in rings.controls.entries) {
        final reason = '$name at width $width, offset $offset';
        expect(effects.outline.width, width, reason: reason);
        expect(effects.outlineOffset, offset, reason: reason);
      }
      for (final MapEntry(key: name, value: effects)
          in rings.otherControls.entries) {
        final reason = '$name at width $width, offset $offset';
        expect(effects.outline.width, width, reason: reason);
        expect(effects.outlineOffset, offset, reason: reason);
      }
    }
  });

  testWidgets('slider thumb ring follows the shared width and offset tokens', (
    tester,
  ) async {
    for (final (width, offset, overridden) in [
      (_defaultWidth, _defaultOffset, false),
      (_widthOverride, _offsetOverride, true),
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

        expect(
          ring.behindContent?.shadows ?? const [],
          isEmpty,
          reason: reason,
        );
        expect(ring.overContent?.shadows ?? const [], isEmpty, reason: reason);
        expect(ring.outlineOffset, offset, reason: reason);
        expect(ring.outline.width, width, reason: reason);
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
      expect(ring.behindContent?.shadows ?? const [], isEmpty);
    },
  );

  testWidgets('painted modifier rings follow the width and offset tokens', (
    tester,
  ) async {
    for (final (width, offset, overridden) in [
      (_defaultWidth, _defaultOffset, false),
      (_widthOverride, _offsetOverride, true),
    ]) {
      final painters = await _resolveFocused(
        tester,
        overridden: overridden,
        _ringPainters,
      );
      expect(painters, hasLength(5));
      for (final MapEntry(:key, :value) in painters.entries) {
        final top = await tester.runAsync(() => _paintTop(value));
        final painted = top!.indexed.where((entry) => entry.$2.a != 0).toList();
        expect(painted, hasLength((width * 4).round()), reason: key);
        expect(
          painted.first.$1,
          ((12 - offset - width) * 4).round(),
          reason: key,
        );
        expect(painted.last.$1, ((12 - offset) * 4).round() - 1, reason: key);
      }
    }
  });

  testWidgets('painted modifier rings all use the solid focus color', (
    tester,
  ) async {
    const focusColor = Color(0xff123456);
    final painters = await _resolveFocused(
      tester,
      overridden: false,
      colors: {
        FortalTokens.focus8: focusColor,
        FortalTokens.focusA8: const Color(0xffabcdef),
      },
      _ringPainters,
    );
    expect(painters, hasLength(5));
    for (final MapEntry(:key, :value) in painters.entries) {
      final top = await tester.runAsync(() => _paintTop(value));
      final painted = top!.where((color) => color.a != 0).toList();
      expect(painted, isNotEmpty, reason: key);
      expect(painted, everyElement(focusColor), reason: key);
    }
  });

  testWidgets(
    'text fields retain the shared focus ring and suppress it when disabled or idle',
    (tester) async {
      for (final (width, offset, overridden) in [
        (_defaultWidth, _defaultOffset, false),
        (_widthOverride, _offsetOverride, true),
      ]) {
        for (final widgetStates in [
          {WidgetState.focused, WidgetState.disabled},
          {WidgetState.focused, WidgetState.error},
          {WidgetState.error},
        ]) {
          final (effects, focus8, errorA7) = await _resolveFocused(
            tester,
            overridden: overridden,
            states: widgetStates,
            (context) => (
              fortalTextFieldStyle().build(context).spec.containerEffects!,
              FortalTokens.focus8.resolve(context),
              FortalTokens.errorA7.resolve(context),
            ),
          );
          final reason = '$widgetStates at width $width, offset $offset';
          if (widgetStates.contains(WidgetState.focused) &&
              !widgetStates.contains(WidgetState.disabled)) {
            expect(effects.outline.style, BorderStyle.solid, reason: reason);
            expect(effects.outline.color, focus8, reason: reason);
            expect(effects.outline.width, width, reason: reason);
            expect(effects.outlineOffset, offset, reason: reason);
          } else {
            expect(effects.outline.style, BorderStyle.none, reason: reason);
          }
          if (widgetStates.contains(WidgetState.error)) {
            final frame = effects.overContent!.shadows.single;
            expect(frame.kind, RemixBoxShadowKind.inset, reason: reason);
            expect(frame.color, errorA7, reason: reason);
            expect(frame.spreadRadius, 1, reason: reason);
          }
        }
      }
    },
  );
}

/// Read the actual painters produced by the five recipes without effects slots.
Map<String, CustomPainter> _ringPainters(BuildContext context) {
  final modifiers = {
    'toggle': fortalToggleStyle().build(context).spec.container.widgetModifiers,
    'toggle group item': fortalToggleGroupStyle()
        .build(context)
        .spec
        .item
        .spec
        .container
        .widgetModifiers,
    'tab': fortalTabStyle().build(context).spec.container.widgetModifiers,
    'disclosure': fortalDisclosureStyle()
        .build(context)
        .spec
        .container
        .widgetModifiers,
    'accordion': fortalAccordionStyle()
        .build(context)
        .spec
        .container
        .widgetModifiers,
  };
  return {
    for (final MapEntry(:key, :value) in modifiers.entries)
      key: value!
          .map((modifier) => modifier.build(const SizedBox()))
          .whereType<CustomPaint>()
          .single
          .foregroundPainter!,
  };
}

/// Paint at 4x and read the center column above the box's top edge.
Future<List<Color>> _paintTop(CustomPainter painter) async {
  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder)
    ..scale(4)
    ..translate(12.0, 12.0);
  painter.paint(canvas, const Size(20, 20));
  final picture = recorder.endRecording();
  final image = await picture.toImage(176, 176);
  final data = (await image.toByteData())!;
  final colors = [
    for (var y = 0; y < 48; y++)
      Color.fromARGB(
        data.getUint8((y * 176 + 88) * 4 + 3),
        data.getUint8((y * 176 + 88) * 4),
        data.getUint8((y * 176 + 88) * 4 + 1),
        data.getUint8((y * 176 + 88) * 4 + 2),
      ),
  ];
  image.dispose();
  picture.dispose();
  return colors;
}

/// Reads [read] under [FortalTheme] with [states] active, at the theme's own
/// ring tokens or, when [overridden], at [_widthOverride] and [_offsetOverride].
Future<T> _resolveFocused<T>(
  WidgetTester tester,
  T Function(BuildContext context) read, {
  required bool overridden,
  Map<ColorToken, Color>? colors,
  Set<WidgetState> states = const {WidgetState.focused},
}) async {
  late T result;
  await tester.pumpWidget(
    FortalTheme(
      child: MixScope.inherit(
        colors: colors,
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
