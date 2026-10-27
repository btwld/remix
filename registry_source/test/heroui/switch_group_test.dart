import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registry_source/src/heroui/components/field_layout.dart';
import 'package:registry_source/src/heroui/components/switch.dart';
import 'package:registry_source/src/heroui/components/switch_group.dart';
import 'package:registry_source/src/heroui/theme/theme.dart';
import 'package:remix/remix.dart';

import '../helpers/heroui.dart';

const _modes = ['light', 'dark'];

Widget _group({
  double width = 600,
  Axis orientation = Axis.vertical,
  HeroUiSwitchSize size = .md,
  bool enabled = true,
  bool invalid = false,
  List<bool> selected = const [false, false],
  void Function(int index, bool value)? onChanged,
}) => SizedBox(
  width: width,
  child: HeroUiSwitchGroup(
    orientation: orientation,
    size: size,
    enabled: enabled,
    label: 'Switches',
    items: [
      for (var i = 0; i < selected.length; i++)
        HeroUiSwitchOption(
          selected: selected[i],
          label: 'Switch ${i + 1}',
          description: 'Help text',
          invalid: invalid,
          onChanged: (value) => onChanged?.call(i, value),
        ),
    ],
  ),
);

Future<void> _pump(
  WidgetTester tester,
  Widget group, {
  String mode = 'light',
}) async {
  await tester.pumpHeroUi(group, mode: mode);
  await tester.pumpAndSettle();
}

TextStyle _style(WidgetTester tester, Finder text) =>
    tester.widget<Text>(text).style!;

Finder _item(int index) => find.byType(HeroUiDescribedControl).at(index);

/// The track's own box, which sits inside the switch's spec provider.
Finder _track(int index) => find
    .descendant(
      of: find.byType(HeroUiSwitch).at(index),
      matching: find.byType(StyleSpecBuilder<BoxSpec>),
    )
    .first;

SwitchSpec _spec(WidgetTester tester, int index) =>
    tester.resolvedSpecOf<SwitchSpec>(_track(index));

void main() {
  for (final mode in _modes) {
    testWidgets('a vertical group matches upstream in $mode', (tester) async {
      await _pump(tester, _group(), mode: mode);
      final group = heroUiCase('switch-group-vertical', mode: mode);
      final item = heroUiCase('switch-group-vertical-a', mode: mode);
      final content = heroUiCase('switch-group-vertical-a-content', mode: mode);
      final label = heroUiCase('switch-group-vertical-a-label', mode: mode);
      final description = heroUiCase(
        'switch-group-vertical-a-description',
        mode: mode,
      );
      final control = heroUiCase('switch-group-vertical-a-control', mode: mode);

      // The label and two described switches, each `gap-4` apart.
      expect(
        tester.getSize(find.byType(HeroUiSwitchGroup)).height,
        group.size.height,
      );
      expect(tester.getSize(_item(0)).height, item.size.height);
      expect(tester.getSize(_track(0)), control.size);

      final text = _style(tester, find.text('Switch 1'));
      expect(text.fontSize, label.px('fontSize'));
      expect(text.fontSize! * text.height!, label.px('lineHeight'));
      expect(text.fontWeight, FontWeight.w500);
      expectCssColor(text.color!, label.styles['color']!, reason: 'label');

      final help = _style(tester, find.text('Help text').first);
      expect(help.fontSize, description.px('fontSize'));
      expectCssColor(
        help.color!,
        description.styles['color']!,
        reason: 'description',
      );

      final track = tester.getRect(_track(0));
      expect(
        tester.getRect(find.text('Switch 1')).left - track.right,
        content.px('gap'),
      );
      expect(
        tester.getRect(find.text('Help text').first).left - track.left,
        description.px('paddingLeft'),
      );
    });

    // `[data-invalid] .label` turns the label danger; `switch.css` has no
    // invalid rule, so the track and thumb stay as at rest.
    for (final selected in [false, true]) {
      final state = selected ? 'invalid-selected' : 'invalid';
      testWidgets('an invalid ${selected ? 'selected ' : ''}switch has a '
          'danger label and an unchanged control in $mode', (tester) async {
        await _pump(
          tester,
          _group(invalid: true, selected: [selected, selected]),
          mode: mode,
        );
        final label = heroUiCase('switch-md-$state-label', mode: mode);
        final control = heroUiCase('switch-md-$state-control', mode: mode);
        final thumb = heroUiCase('switch-md-$state-thumb', mode: mode);
        final rest = heroUiCase(
          'switch-md-${selected ? 'selected' : 'rest'}-label',
          mode: mode,
        );
        expect(
          label.styles['color'],
          isNot(rest.styles['color']),
          reason: 'upstream recolors the label',
        );
        final danger = heroUiToken(HeroUiTokens.danger, mode);
        for (final text in ['Switch 1', 'Switch 2']) {
          expectCssColor(
            _style(tester, find.text(text)).color!,
            label.styles['color']!,
            reason: text,
          );
          expect(_style(tester, find.text(text)).color, danger, reason: text);
        }
        // The description keeps its own color.
        expect(
          _style(tester, find.text('Help text').first).color,
          heroUiToken(HeroUiTokens.muted, mode),
        );

        final spec = _spec(tester, 0);
        expectCssColor(
          (spec.container.spec.decoration as BoxDecoration).color!,
          control.styles['backgroundColor']!,
          reason: 'track',
        );
        expectCssColor(
          (spec.thumb.spec.decoration as BoxDecoration).color!,
          thumb.styles['backgroundColor']!,
          reason: 'thumb',
        );
        expectShadows(
          spec.thumbEffects!.behindContent!.shadows,
          cssShadows(thumb.styles['boxShadow'] ?? ''),
        );
      });
    }

    testWidgets('only the invalid switches get the danger label in $mode', (
      tester,
    ) async {
      await _pump(
        tester,
        HeroUiSwitchGroup(
          items: [
            HeroUiSwitchOption(
              selected: false,
              label: 'Fine',
              onChanged: (_) {},
            ),
            HeroUiSwitchOption(
              selected: false,
              label: 'Wrong',
              invalid: true,
              onChanged: (_) {},
            ),
          ],
        ),
        mode: mode,
      );
      expect(
        _style(tester, find.text('Fine')).color,
        heroUiToken(HeroUiTokens.foreground, mode),
      );
      expect(
        _style(tester, find.text('Wrong')).color,
        heroUiToken(HeroUiTokens.danger, mode),
      );
    });

    testWidgets('disabled dims the track once and the text twice in $mode', (
      tester,
    ) async {
      await _pump(tester, _group(enabled: false), mode: mode);
      final root = heroUiCase('switch-md-disabled', mode: mode);
      final label = heroUiCase('switch-md-disabled-label', mode: mode);
      final description = heroUiCase(
        'switch-md-disabled-description',
        mode: mode,
      );

      // The switch dims its track and label together; the label's own
      // `status-disabled` is its color's alpha.
      final rootOpacity = double.parse(root.styles['opacity']!);
      expect(tester.opacityAbove(_track(0)), rootOpacity);
      expect(tester.opacityAbove(find.text('Switch 1')), rootOpacity);
      expect(
        _style(tester, find.text('Switch 1')).color!.a,
        closeTo(double.parse(label.styles['opacity']!), .001),
      );
      expect(
        tester.opacityAbove(find.text('Help text').first),
        closeTo(
          double.parse(description.styles['opacity']!) * rootOpacity,
          .001,
        ),
      );
      expect(
        tester.opacityAbove(find.text('Switches')),
        HeroUiTokens.disabledOpacity,
      );
    });
  }

  testWidgets('the description follows the size of the track', (tester) async {
    for (final size in HeroUiSwitchSize.values) {
      await _pump(tester, _group(size: size));
      final description = heroUiCase('switch-${size.name}-rest-description');
      final track = tester.getRect(_track(0));
      expect(
        tester.getRect(find.text('Help text').first).left - track.left,
        description.px('paddingLeft'),
        reason: size.name,
      );
    }
  });

  testWidgets('a horizontal group is one wrapping row with gap-4', (
    tester,
  ) async {
    await _pump(tester, _group(orientation: Axis.horizontal, width: 1200));
    final group = heroUiCase('switch-group-horizontal');
    final label = tester.getRect(find.text('Switches'));
    final a = tester.getRect(_item(0));
    final b = tester.getRect(_item(1));
    expect(
      tester.getSize(find.byType(HeroUiSwitchGroup)).height,
      group.size.height,
    );
    // Upstream flows the label in the row with the switches, `gap-4` apart
    // (`switch-group.css`; the capture puts the first switch 16px after it).
    const gap = 16.0;
    expect(a.left - label.right, gap);
    expect(b.left - a.right, gap);
    expect(a.top, b.top);
  });

  testWidgets('tapping a switch label toggles that switch', (tester) async {
    final selected = [false, true];
    await _pump(
      tester,
      StatefulBuilder(
        builder: (context, setState) => _group(
          selected: List.of(selected),
          onChanged: (index, value) => setState(() => selected[index] = value),
        ),
      ),
    );
    await tester.tap(find.text('Switch 1'));
    await tester.pumpAndSettle();
    expect(selected, [true, true]);
  });

  testWidgets('each switch keeps its own value', (tester) async {
    final selected = [false, true];
    await _pump(
      tester,
      StatefulBuilder(
        builder: (context, setState) => _group(
          selected: List.of(selected),
          onChanged: (index, value) => setState(() => selected[index] = value),
        ),
      ),
    );
    await tester.tap(find.byType(HeroUiSwitch).first);
    await tester.pumpAndSettle();
    expect(selected, [true, true]);
    await tester.tap(find.byType(HeroUiSwitch).last);
    await tester.pumpAndSettle();
    expect(selected, [true, false]);
  });
}
