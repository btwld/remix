import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registry_source/heroui.dart';
import 'package:remix/remix.dart';

import '../helpers/heroui.dart';

const _label = 'Subscribe';
const _modes = ['light', 'dark'];

Future<CheckboxSpec> _pump(
  WidgetTester tester, {
  HeroUiCheckboxVariant variant = .primary,
  bool? selected = false,
  bool invalid = false,
  bool enabled = true,
  String mode = 'light',
  CheckboxStyler style = const CheckboxStyler.create(),
}) async {
  await tester.pumpHeroUi(
    HeroUiCheckbox(
      variant: variant,
      invalid: invalid,
      selected: selected,
      tristate: selected == null,
      enabled: enabled,
      label: _label,
      style: style,
      onChanged: (_) {},
    ),
    mode: mode,
  );
  await tester.pumpAndSettle();
  return _spec(tester);
}

CheckboxSpec _spec(WidgetTester tester) =>
    tester.resolvedSpecOf<CheckboxSpec>(find.text(_label));

Color? _fill(CheckboxSpec spec) =>
    (spec.container.spec.decoration as BoxDecoration?)?.color;

/// The pixel size Tailwind's `size-N` gives the mark svg [slot] in the pinned
/// `checkbox.css`.
double _markSize(String slot) {
  final css = File(
    'reference/heroui_3_2_6/source/dist/components/checkbox.css',
  ).readAsStringSync();
  final match = RegExp(
    'checkbox-default-indicator--$slot"\\]\\s*\\{[^}]*?@apply size-([\\d.]+)',
  ).firstMatch(css)!;
  return double.parse(match[1]!) * 4;
}

void main() {
  test('variants follow HeroUI', () {
    expect(HeroUiCheckboxVariant.values, [
      HeroUiCheckboxVariant.primary,
      HeroUiCheckboxVariant.secondary,
    ]);
  });

  for (final mode in _modes) {
    for (final variant in HeroUiCheckboxVariant.values) {
      testWidgets('${variant.name} control matches upstream in $mode', (
        tester,
      ) async {
        for (final (selected, state) in [
          (false, 'rest'),
          (true, 'selected'),
          (null, 'mixed'),
        ]) {
          final spec = await _pump(
            tester,
            variant: variant,
            selected: selected,
            mode: mode,
          );
          final control = heroUiCase(
            'checkbox-${variant.name}-$state-control',
            mode: mode,
          );
          final box = spec.container.spec;
          expect(
            box.constraints,
            BoxConstraints.tight(control.size),
            reason: state,
          );
          expect(
            (box.decoration as BoxDecoration).borderRadius,
            BorderRadius.circular(control.px('borderRadius')),
          );
          if (state == 'selected') {
            // The selected capture reports the field fill on the control box;
            // `mixed` carries the accent fill the checked box shares.
            expect(_fill(spec), heroUiToken(HeroUiTokens.accent, mode));
          } else {
            expectCssColor(
              _fill(spec)!,
              control.styles['backgroundColor']!,
              reason: state,
            );
          }
          if (state != 'rest') {
            final indicator = heroUiCase(
              'checkbox-${variant.name}-$state-indicator',
              mode: mode,
            );
            expectCssColor(
              spec.indicator.spec.color!,
              indicator.styles['color']!,
              reason: '$state mark',
            );
            expect(
              spec.indicator.spec.size,
              _markSize(selected == null ? 'indeterminate' : 'checkmark'),
              reason: '$state mark size',
            );
          }
        }
      });
    }

    testWidgets('primary carries the upstream shadow in $mode', (tester) async {
      final spec = await _pump(tester, mode: mode);
      final control = heroUiCase('checkbox-primary-rest-control', mode: mode);
      expectShadows(
        behindShadows(spec.containerEffects),
        cssShadows(control.styles['boxShadow'] ?? ''),
      );
    });

    testWidgets('label and gap match the upstream content row in $mode', (
      tester,
    ) async {
      final spec = await _pump(tester, mode: mode);
      final label = heroUiCase('checkbox-primary-rest-label', mode: mode);
      final content = heroUiCase('checkbox-primary-rest-content', mode: mode);
      final style = spec.label.spec.style!;
      expect(style.fontSize, label.px('fontSize'));
      expect(style.fontSize! * style.height!, label.px('lineHeight'));
      expect(style.fontWeight, FontWeight.w500);
      expectCssColor(style.color!, label.styles['color']!, reason: 'label');
      expect(spec.labelSpacing, content.px('gap'));
    });

    for (final variant in HeroUiCheckboxVariant.values) {
      // The primary variant darkens a selected box (`bg-accent-hover`); the
      // secondary one keeps `bg-accent`. No capture shows the selected fill.
      testWidgets(
        'hovering a selected ${variant.name} checkbox in $mode',
        (tester) async {
          await _pump(tester, variant: variant, selected: true, mode: mode);
          await tester.hoverCenter(find.text(_label));
          expect(
            _fill(_spec(tester)),
            heroUiToken(
              variant == .primary
                  ? HeroUiTokens.accentHover
                  : HeroUiTokens.accent,
              mode,
            ),
          );
        },
        variant: desktopOnly,
      );

      testWidgets('invalid paints danger on the ${variant.name} label, ring, '
          'and fill in $mode', (tester) async {
        final danger = heroUiToken(HeroUiTokens.danger, mode);
        final rest = await _pump(
          tester,
          variant: variant,
          invalid: true,
          mode: mode,
        );
        final label = heroUiCase(
          'checkbox-${variant.name}-invalid-label',
          mode: mode,
        );
        final control = heroUiCase(
          'checkbox-${variant.name}-invalid-control',
          mode: mode,
        );
        expectCssColor(
          rest.label.spec.style!.color!,
          label.styles['color']!,
          reason: 'label',
        );
        expectCssColor(
          _fill(rest)!,
          control.styles['backgroundColor']!,
          reason: 'rest fill',
        );
        // `invalid-field-ring`: a 1px danger outline, only while unselected.
        expect(rest.containerEffects!.outline.width, 1);
        expect(rest.containerEffects!.outline.color, danger);

        final selected = await _pump(
          tester,
          variant: variant,
          invalid: true,
          selected: true,
          mode: mode,
        );
        final selectedControl = heroUiCase(
          'checkbox-${variant.name}-invalid-selected-control',
          mode: mode,
        );
        final mark = heroUiCase(
          'checkbox-${variant.name}-invalid-selected-indicator',
          mode: mode,
        );
        expectCssColor(
          _fill(selected)!,
          selectedControl.styles['backgroundColor']!,
          reason: 'selected fill',
        );
        expectCssColor(
          selected.indicator.spec.color!,
          mark.styles['color']!,
          reason: 'mark',
        );
        expect(selected.containerEffects!.outline.style, BorderStyle.none);
      });
    }

    testWidgets('disabled dims the field, and the label twice, in $mode', (
      tester,
    ) async {
      final spec = await _pump(tester, enabled: false, mode: mode);
      final root = heroUiCase('checkbox-primary-disabled', mode: mode);
      final label = heroUiCase('checkbox-primary-disabled-label', mode: mode);
      expect(
        tester.opacityAbove(find.text(_label)),
        double.parse(root.styles['opacity']!),
      );
      expect(
        spec.label.spec.style!.color!.a,
        closeTo(double.parse(label.styles['opacity']!), .001),
      );
    });

    // The `*-focus-control` captures hold the ring; the selected one reports
    // the unselected fill, but its ring is what is compared here.
    for (final (selected, invalid, id) in [
      (false, false, 'checkbox-primary-rest-focus-control'),
      (true, false, 'checkbox-primary-selected-focus-control'),
      (true, true, 'checkbox-primary-invalid-selected-focus-control'),
    ]) {
      testWidgets('keyboard focus draws the ring of $id in $mode', (
        tester,
      ) async {
        await _pump(tester, invalid: invalid, selected: selected, mode: mode);
        final before = tester.getSize(find.byType(HeroUiCheckbox));
        await tester.focusWithTab();
        expectFocusRing(
          _spec(tester).containerEffects,
          heroUiCase(id, mode: mode, state: true),
        );
        expect(tester.getSize(find.byType(HeroUiCheckbox)), before);
      });
    }
  }

  testWidgets('the field keeps HeroUI\'s 24px touch target', (tester) async {
    await _pump(tester);
    final content = heroUiCase('checkbox-primary-rest-content');
    // `touch-target` is `size-6`; the content row stays 20.
    expect(content.size.height, 20);
    expect(tester.getSize(find.byType(HeroUiCheckbox)).height, 24);
  });

  testWidgets('a caller style wins over the recipe', (tester) async {
    const override = Color(0xFF00FF00);
    final spec = await _pump(tester, style: CheckboxStyler().color(override));
    expect(_fill(spec), override);
  });

  testWidgets('tapping the label toggles through Remix', (tester) async {
    bool? value;
    await tester.pumpHeroUi(
      HeroUiCheckbox(
        selected: false,
        label: _label,
        onChanged: (next) => value = next,
      ),
    );
    await tester.tap(find.text(_label));
    expect(value, isTrue);
  });
}
