import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registry_source/src/heroui/components/switch.dart';
import 'package:registry_source/src/heroui/theme/theme.dart';
import 'package:remix/remix.dart';

import '../helpers/heroui.dart';

const _modes = ['light', 'dark'];

Widget _switch({
  HeroUiSwitchSize size = .md,
  bool selected = false,
  bool enabled = true,
  ValueChanged<bool>? onChanged,
  SwitchStyler style = const SwitchStyler.create(),
}) => HeroUiSwitch(
  size: size,
  selected: selected,
  enabled: enabled,
  semanticLabel: _label,
  onChanged: onChanged ?? (_) {},
  style: style,
);

Widget _labeledSwitch({
  bool selected = false,
  bool invalid = false,
  ValueChanged<bool>? onChanged,
}) => HeroUiSwitch(
  selected: selected,
  invalid: invalid,
  label: _label,
  onChanged: onChanged ?? (_) {},
);

const _label = 'Notifications';

Future<void> _pump(
  WidgetTester tester,
  Widget widget, {
  String mode = 'light',
}) async {
  await tester.pumpHeroUi(widget, mode: mode);
  await tester.pumpAndSettle();
}

/// The track's own box, which sits inside the switch's spec provider.
Finder get _track => find
    .descendant(
      of: find.byType(HeroUiSwitch),
      matching: find.byType(StyleSpecBuilder<BoxSpec>),
    )
    .first;

Finder get _thumb => find
    .descendant(
      of: find.byType(HeroUiSwitch),
      matching: find.byType(StyleSpecBuilder<BoxSpec>),
    )
    .last;

SwitchSpec _spec(WidgetTester tester) =>
    tester.resolvedSpecOf<SwitchSpec>(_track);

void main() {
  test('sizes follow HeroUI, with the track widths of the CSS', () {
    expect(HeroUiSwitchSize.values, [
      HeroUiSwitchSize.sm,
      HeroUiSwitchSize.md,
      HeroUiSwitchSize.lg,
    ]);
    for (final size in HeroUiSwitchSize.values) {
      final control = heroUiCase('switch-${size.name}-rest-control');
      expect(size.trackWidth, control.size.width, reason: size.name);
    }
  });

  for (final mode in _modes) {
    for (final size in HeroUiSwitchSize.values) {
      for (final selected in [false, true]) {
        final state = selected ? 'selected' : 'rest';
        testWidgets('${size.name} $state matches upstream in $mode', (
          tester,
        ) async {
          await _pump(
            tester,
            _switch(size: size, selected: selected),
            mode: mode,
          );
          final control = heroUiCase(
            'switch-${size.name}-$state-control',
            mode: mode,
          );
          final thumb = heroUiCase(
            'switch-${size.name}-$state-thumb',
            mode: mode,
          );
          final spec = _spec(tester);

          expect(tester.getSize(find.byType(HeroUiSwitch)), control.size);
          expect(
            (spec.container.spec.decoration as BoxDecoration).borderRadius,
            BorderRadius.circular(control.px('borderRadius')),
          );
          expectCssColor(
            (spec.container.spec.decoration as BoxDecoration).color!,
            control.styles['backgroundColor']!,
            reason: 'track',
          );

          final thumbRect = tester.getRect(_thumb);
          final trackRect = tester.getRect(find.byType(HeroUiSwitch));
          expect(thumbRect.size, thumb.size);
          expect(
            (spec.thumb.spec.decoration as BoxDecoration).borderRadius,
            BorderRadius.circular(thumb.px('borderRadius')),
          );
          expectCssColor(
            (spec.thumb.spec.decoration as BoxDecoration).color!,
            thumb.styles['backgroundColor']!,
            reason: 'thumb',
          );
          // `ms-0.5`, and the same inset on the far side once selected.
          const inset = 2.0;
          expect(
            selected
                ? trackRect.right - thumbRect.right
                : thumbRect.left - trackRect.left,
            inset,
          );
          expect(thumbRect.center.dy, trackRect.center.dy);

          expectShadows(
            spec.thumbEffects!.behindContent!.shadows,
            cssShadows(thumb.styles['boxShadow'] ?? ''),
          );
        });
      }
    }

    for (final selected in [false, true]) {
      final state = selected ? 'selected' : 'rest';

      // The hovered track is `default` at 80%, or `accent-hover` once selected.
      testWidgets('hover fades the $state track in $mode', (tester) async {
        await _pump(tester, _switch(selected: selected), mode: mode);
        final hovered = heroUiCase(
          'switch-md-$state-hover',
          mode: mode,
          state: true,
        );
        await tester.hoverCenter(find.byType(HeroUiSwitch));
        expectCssColor(
          (_spec(tester).container.spec.decoration as BoxDecoration).color!,
          hovered.styles['backgroundColor']!,
          reason: 'hover',
        );
      }, variant: desktopOnly);

      testWidgets('pressing takes the hover colors of the $state track in '
          '$mode', (tester) async {
        await _pump(tester, _switch(selected: selected), mode: mode);
        final pressed = heroUiCase(
          'switch-md-$state-pressed',
          mode: mode,
          state: true,
        );
        final press = await tester.pressCenter(find.byType(HeroUiSwitch));
        expectCssColor(
          (_spec(tester).container.spec.decoration as BoxDecoration).color!,
          pressed.styles['backgroundColor']!,
          reason: 'pressed',
        );
        await press.up();
      });

      testWidgets('keyboard focus draws the measured ring on the $state track '
          'in $mode', (tester) async {
        await _pump(tester, _switch(selected: selected), mode: mode);
        final before = tester.getSize(find.byType(HeroUiSwitch));
        await tester.focusWithTab();
        expectFocusRing(
          _spec(tester).trackEffects,
          heroUiCase('switch-md-$state-focus-control', mode: mode, state: true),
        );
        expect(tester.getSize(find.byType(HeroUiSwitch)), before);
      });
    }

    testWidgets('a disabled selected switch keeps the accent track in $mode', (
      tester,
    ) async {
      await _pump(tester, _switch(enabled: false, selected: true), mode: mode);
      final control = heroUiCase(
        'switch-md-disabled-selected-control',
        mode: mode,
      );
      expectCssColor(
        (_spec(tester).container.spec.decoration as BoxDecoration).color!,
        control.styles['backgroundColor']!,
        reason: 'track',
      );
      expect(
        control.styles['backgroundColor'],
        heroUiCase(
          'switch-md-selected-control',
          mode: mode,
        ).styles['backgroundColor'],
      );
    });

    testWidgets('disabled dims the switch, and its thumb again, in $mode', (
      tester,
    ) async {
      await _pump(tester, _switch(enabled: false), mode: mode);
      final root = heroUiCase('switch-md-disabled', mode: mode);
      final thumb = heroUiCase('switch-md-disabled-thumb', mode: mode);
      expect(tester.opacityAbove(find.byType(HeroUiSwitch)), 1);
      expect(
        tester.opacityAbove(_track),
        double.parse(root.styles['opacity']!),
      );
      expectCssColor(
        (_spec(tester).thumb.spec.decoration as BoxDecoration).color!,
        thumb.styles['backgroundColor']!,
        reason: 'thumb',
      );

      await _pump(tester, _switch(enabled: false, selected: true), mode: mode);
      final selected = heroUiCase(
        'switch-md-disabled-selected-thumb',
        mode: mode,
      );
      expect(
        tester
            .widget<Opacity>(
              find.descendant(of: _thumb, matching: find.byType(Opacity)),
            )
            .opacity,
        double.parse(selected.styles['opacity']!),
      );
      expectCssColor(
        (_spec(tester).thumb.spec.decoration as BoxDecoration).color!,
        selected.styles['backgroundColor']!,
        reason: 'selected thumb',
      );
    });
  }

  for (final mode in _modes) {
    testWidgets('the label matches the upstream label and content row in '
        '$mode', (tester) async {
      await _pump(tester, _labeledSwitch(), mode: mode);
      final label = heroUiCase('switch-md-rest-label', mode: mode);
      final content = heroUiCase('switch-group-vertical-a-content', mode: mode);
      final style = tester.widget<Text>(find.text(_label)).style!;
      expect(style.fontSize, label.px('fontSize'));
      expect(style.fontSize! * style.height!, label.px('lineHeight'));
      expect(style.fontWeight, FontWeight.w500);
      expectCssColor(style.color!, label.styles['color']!, reason: 'label');

      final track = tester.getRect(_track);
      final text = tester.getRect(find.text(_label));
      expect(text.left - track.right, content.px('gap'));
      expect(text.center.dy, track.center.dy);
    });

    testWidgets('an invalid switch turns only the label danger in $mode', (
      tester,
    ) async {
      await _pump(tester, _labeledSwitch(invalid: true), mode: mode);
      final label = heroUiCase('switch-md-invalid-label', mode: mode);
      expectCssColor(
        tester.widget<Text>(find.text(_label)).style!.color!,
        label.styles['color']!,
        reason: 'label',
      );
      expect(
        (_spec(tester).container.spec.decoration as BoxDecoration).color,
        heroUiToken(HeroUiTokens.defaultColor, mode),
      );
    });

    // The label is inside the one target: hovering or pressing it moves the
    // track through the same states as pointing at the track.
    testWidgets('hovering the label fades the track in $mode', (tester) async {
      await _pump(tester, _labeledSwitch(), mode: mode);
      final hovered = heroUiCase(
        'switch-md-rest-hover',
        mode: mode,
        state: true,
      );
      await tester.hoverCenter(find.text(_label));
      expectCssColor(
        (_spec(tester).container.spec.decoration as BoxDecoration).color!,
        hovered.styles['backgroundColor']!,
        reason: 'hover',
      );
    }, variant: desktopOnly);

    testWidgets('pressing the label takes the pressed track colors in $mode', (
      tester,
    ) async {
      await _pump(tester, _labeledSwitch(), mode: mode);
      final pressed = heroUiCase(
        'switch-md-rest-pressed',
        mode: mode,
        state: true,
      );
      final press = await tester.pressCenter(find.text(_label));
      expectCssColor(
        (_spec(tester).container.spec.decoration as BoxDecoration).color!,
        pressed.styles['backgroundColor']!,
        reason: 'pressed',
      );
      await press.up();
    });
  }

  testWidgets('tapping the label toggles, and the switch is one node named by '
      'it', (tester) async {
    final semantics = tester.ensureSemantics();
    bool? value;
    await _pump(tester, _labeledSwitch(onChanged: (next) => value = next));
    expect(find.semantics.byLabel(_label), findsOne);

    await tester.tap(find.text(_label));
    expect(value, isTrue);
    semantics.dispose();
  });

  testWidgets('tapping toggles through Remix and slides the thumb', (
    tester,
  ) async {
    var selected = false;
    await _pump(
      tester,
      StatefulBuilder(
        builder: (context, setState) => _switch(
          selected: selected,
          onChanged: (value) => setState(() => selected = value),
        ),
      ),
    );
    final off = tester.getRect(_thumb);
    await tester.tap(find.byType(HeroUiSwitch));
    await tester.pumpAndSettle();
    expect(selected, isTrue);
    expect(tester.getRect(_thumb).left, greaterThan(off.left));
  });

  testWidgets('a caller style wins over the recipe', (tester) async {
    const override = Color(0xFF00FF00);
    await _pump(tester, _switch(style: SwitchStyler().trackColor(override)));
    expect(
      (_spec(tester).container.spec.decoration as BoxDecoration).color,
      override,
    );
  });
}
