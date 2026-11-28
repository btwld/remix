import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/remix.dart';
import 'package:registry_source/fortal.dart';

import '../../helpers/contrast.dart';
import '../../helpers/test_helpers.dart';

void main() {
  group('focus-visible behavior', () {
    late FocusHighlightStrategy previousStrategy;

    setUp(() {
      previousStrategy = FocusManager.instance.highlightStrategy;
    });

    tearDown(() {
      FocusManager.instance.highlightStrategy = previousStrategy;
    });

    testWidgets('focused item hides its ring in touch mode', (tester) async {
      FocusManager.instance.highlightStrategy =
          FocusHighlightStrategy.alwaysTouch;
      final focusNode = FocusNode();
      addTearDown(focusNode.dispose);

      await tester.pumpRemixApp(
        FortalSegmentedControl<String>(
          items: [
            RemixSegmentedControlItem(
              value: 'a',
              label: 'Alpha',
              focusNode: focusNode,
            ),
          ],
          selectedValue: null,
          onChanged: (_) {},
        ),
      );
      await tester.pumpAndSettle();

      focusNode.requestFocus();
      await tester.pumpAndSettle();

      expect(focusNode.hasFocus, isTrue);
      final spec = tester.resolvedSpecOf<SegmentedControlItemSpec>(
        find.text('Alpha'),
      );
      expect(spec.containerEffects?.outline.width ?? 0, 0);
    });
  });

  for (final (size, segment, paddingX, fontSize, frameRadius, segmentRadius)
      in const [
        (FortalSegmentedControlSize.size1, 28.0, 10.0, 12.0, 14.0, 10.0),
        (FortalSegmentedControlSize.size2, 32.0, 12.0, 13.0, 14.0, 10.0),
        (FortalSegmentedControlSize.size3, 36.0, 14.0, 13.0, 16.0, 12.0),
      ]) {
    testWidgets('${size.name} resolves its segment and frame metrics', (
      tester,
    ) async {
      final result = await _resolve(tester, size: size);
      final track = result.spec.container.spec;
      final item = result.spec.item.spec.container.spec;
      final indicator = result.spec.indicator!.spec;

      expect(track.padding, const EdgeInsets.all(3));
      expect(result.spec.spacing, 2);
      expect(result.spec.segmentSizing, RemixSegmentSizing.content);
      expect(_radius(track), frameRadius);
      expect(item.constraints!.minHeight, segment);
      expect(item.padding, EdgeInsets.symmetric(horizontal: paddingX));
      expect(_radius(item), segmentRadius);
      expect(_radius(indicator), segmentRadius);
      expect(result.spec.item.spec.label.spec.style!.fontSize, fontSize);
    });
  }

  testWidgets('a muted track in a border holds a raised gliding pill', (
    tester,
  ) async {
    final result = await _resolve(tester, accent: FortalAccentColor.orla);
    final track = result.spec.container.spec.decoration! as BoxDecoration;
    final pill = result.spec.indicator!.spec.decoration! as BoxDecoration;

    expect(track.color, const Color(0xFFF8F8F8));
    expect((track.border! as Border).top.color, const Color(0xFFE9E9E9));
    expect(pill.color, const Color(0xFFFFFFFF));
    expect((pill.border! as Border).top.color, const Color(0xFFE9E9E9));
    expect(pill.boxShadow, isNotEmpty);
    expect(
      result.spec.indicatorMotion,
      AnimationConfig.curve(
        duration: const Duration(milliseconds: 200),
        curve: FortalMotion.easeStandard,
      ),
    );
  });

  testWidgets('the dark track and pill take the dark surface roles', (
    tester,
  ) async {
    final result = await _resolve(
      tester,
      accent: FortalAccentColor.orla,
      mode: FortalThemeMode.dark,
    );
    final track = result.spec.container.spec.decoration! as BoxDecoration;
    final pill = result.spec.indicator!.spec.decoration! as BoxDecoration;

    expect(track.color, const Color(0xFF242424));
    expect((track.border! as Border).top.color, const Color(0xFF2B2B2B));
    expect(pill.color, const Color(0xFF191919));
  });

  testWidgets('labels are muted until hovered, pressed or selected', (
    tester,
  ) async {
    const muted = Color(0xFF7D7D7D);
    const ink = Color(0xFF0B0B0B);
    for (final (states, color) in [
      (const <WidgetState>{}, muted),
      ({WidgetState.hovered}, ink),
      ({WidgetState.pressed}, ink),
      ({WidgetState.selected}, ink),
    ]) {
      final result = await _resolve(
        tester,
        accent: FortalAccentColor.orla,
        states: states,
      );
      final label = result.spec.item.spec.label.spec.style!;

      expect(label.color, color, reason: '$states');
      expect(label.fontWeight, FontWeight.w500, reason: '$states');
      // Segments never fill: the gliding pill is the only selected surface.
      expect(
        _color(result.spec.item.spec.container.spec),
        isNull,
        reason: '$states',
      );
    }
  });

  testWidgets('high contrast lifts resting labels to 4.5:1 on the track', (
    tester,
  ) async {
    for (final mode in [FortalThemeMode.light, FortalThemeMode.dark]) {
      final result = await _resolve(tester, mode: mode, highContrast: true);
      final track =
          (result.spec.container.spec.decoration! as BoxDecoration).color!;
      final item = result.spec.item.spec;

      expect(
        contrastRatio(item.label.spec.style!.color!, track),
        greaterThanOrEqualTo(4.5),
        reason: '${mode.name} label',
      );
      expect(
        contrastRatio(item.icon.spec.color!, track),
        greaterThanOrEqualTo(4.5),
        reason: '${mode.name} icon',
      );
    }
  });

  testWidgets('a disabled control shows at 52%', (tester) async {
    for (final enabled in [true, false]) {
      await tester.pumpRemixApp(
        FortalSegmentedControl<String>(
          items: const [
            RemixSegmentedControlItem(value: 'a', label: 'Alpha'),
            RemixSegmentedControlItem(value: 'b', label: 'Bravo'),
          ],
          selectedValue: 'a',
          enabled: enabled,
          onChanged: (_) {},
        ),
      );
      await tester.pumpAndSettle();

      for (final label in ['Alpha', 'Bravo']) {
        expect(
          _shownOpacity(tester, find.text(label)),
          closeTo(enabled ? 1 : 0.52, 1e-9),
          reason: '$label enabled: $enabled',
        );
      }
    }
  });

  testWidgets('labels stay on one line so a narrow track cannot clip them', (
    tester,
  ) async {
    for (final states in [
      const <WidgetState>{},
      {WidgetState.selected},
      {WidgetState.disabled},
    ]) {
      final result = await _resolve(tester, states: states);
      final label = result.spec.item.spec.label.spec;

      expect(label.maxLines, 1);
      expect(label.overflow, TextOverflow.ellipsis);
    }
  });

  testWidgets('the track paints no layer over the selected indicator', (
    tester,
  ) async {
    final idle = await _resolve(tester);
    final disabled = await _resolve(tester, states: {WidgetState.disabled});

    expect(idle.spec.container.spec.foregroundDecoration, isNull);
    expect(disabled.spec.container.spec.foregroundDecoration, isNull);
  });
}

Future<({SegmentedControlSpec spec})> _resolve(
  WidgetTester tester, {
  FortalSegmentedControlSize size = FortalSegmentedControlSize.size2,
  FortalAccentColor? accent,
  FortalThemeMode? mode,
  bool? highContrast,
  Set<WidgetState> states = const {},
}) async {
  late ({SegmentedControlSpec spec}) result;
  await tester.pumpWidget(
    FortalTheme(
      accent: accent,
      mode: mode,
      highContrast: highContrast,
      child: WidgetStateStyleOverride(
        states: states,
        child: Builder(
          builder: (context) {
            result = (
              spec: fortalSegmentedControlStyle(size: size).build(context).spec,
            );
            return const SizedBox.shrink();
          },
        ),
      ),
    ),
  );
  return result;
}

double _radius(BoxSpec box) =>
    ((box.decoration! as BoxDecoration).borderRadius! as BorderRadius)
        .topLeft
        .x;

Color? _color(BoxSpec box) => (box.decoration as BoxDecoration?)?.color;

double _shownOpacity(WidgetTester tester, Finder finder) => tester
    .widgetList<Opacity>(
      find.ancestor(of: finder, matching: find.byType(Opacity)),
    )
    .fold(1.0, (shown, layer) => shown * layer.opacity);
