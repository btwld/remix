import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registry_source/src/heroui/components/chip.dart';
import 'package:registry_source/src/heroui/theme/theme.dart';
import 'package:remix/remix.dart';

import '../helpers/heroui.dart';

const _label = 'Active';

String _id(HeroUiColor color) =>
    color == .defaultColor ? 'default' : color.name;

Future<BadgeSpec> _pump(
  WidgetTester tester, {
  HeroUiChipVariant variant = .secondary,
  HeroUiColor color = .defaultColor,
  HeroUiChipSize size = .md,
  String mode = 'light',
  BadgeStyler style = const BadgeStyler.create(),
}) async {
  await tester.pumpHeroUi(
    HeroUiChip(
      variant: variant,
      color: color,
      size: size,
      label: _label,
      style: style,
    ),
    mode: mode,
  );
  await tester.pumpAndSettle();
  return tester.resolvedSpecOf<BadgeSpec>(find.text(_label));
}

BoxDecoration _decoration(BadgeSpec spec) =>
    spec.container.spec.decoration! as BoxDecoration;

void main() {
  test('variants, colours, and sizes follow HeroUI', () {
    expect(HeroUiChipVariant.values.map((v) => v.name), [
      'primary',
      'secondary',
      'soft',
      'tertiary',
    ]);
    expect(HeroUiColor.values.map((c) => c.name), [
      'defaultColor',
      'accent',
      'success',
      'warning',
      'danger',
    ]);
    expect(HeroUiChipSize.values.map((s) => s.name), ['sm', 'md', 'lg']);
  });

  test('a chip defaults to the secondary variant, default colour, md', () {
    const chip = HeroUiChip(label: _label);
    expect(chip.variant, HeroUiChipVariant.secondary);
    expect(chip.color, HeroUiColor.defaultColor);
    expect(chip.size, HeroUiChipSize.md);
  });

  for (final mode in ['light', 'dark']) {
    testWidgets('every variant and size matches upstream in $mode', (
      tester,
    ) async {
      for (final variant in HeroUiChipVariant.values) {
        for (final size in HeroUiChipSize.values) {
          final reason = '${variant.name} ${size.name}';
          final spec = await _pump(
            tester,
            variant: variant,
            size: size,
            mode: mode,
          );
          final upstream = heroUiCase(
            'chip-${variant.name}-default-${size.name}',
            mode: mode,
          );

          expect(
            tester.getSize(find.byType(HeroUiChip)).height,
            upstream.size.height,
            reason: reason,
          );
          expect(
            _decoration(spec).borderRadius,
            BorderRadius.circular(upstream.px('borderRadius')),
            reason: reason,
          );
          // The label's `px-0.5` sits inside the chip's own padding.
          expect(
            spec.container.spec.padding,
            EdgeInsets.symmetric(
              horizontal: upstream.px('paddingLeft') + 2,
              vertical: upstream.px('paddingTop'),
            ),
            reason: reason,
          );
          final text = spec.label.spec.style!;
          expect(text.fontSize, upstream.px('fontSize'), reason: reason);
          expect(
            text.fontSize! * text.height!,
            closeTo(upstream.px('lineHeight'), 1e-9),
            reason: reason,
          );
          expect(text.fontWeight, FontWeight.w500, reason: reason);
        }
      }
    });

    testWidgets('the palette maps all five colours like upstream in $mode', (
      tester,
    ) async {
      for (final variant in HeroUiChipVariant.values) {
        for (final color in HeroUiColor.values) {
          final reason = '${variant.name} ${color.name}';
          final spec = await _pump(
            tester,
            variant: variant,
            color: color,
            mode: mode,
          );
          final upstream = heroUiCase(
            'chip-${variant.name}-${_id(color)}-md',
            mode: mode,
          );

          expectFill(_decoration(spec).color, upstream, reason: reason);
          expectCssColor(
            spec.label.spec.style!.color!,
            upstream.styles['color']!,
            reason: reason,
          );
        }
      }
    });
  }

  testWidgets('the label keeps its width plus the chip padding', (
    tester,
  ) async {
    // Same text in every size, so the width difference is the padding alone.
    final widths = <HeroUiChipSize, double>{};
    for (final size in HeroUiChipSize.values) {
      await _pump(tester, size: size);
      widths[size] = tester.getSize(find.byType(HeroUiChip)).width;
    }
    // sm and md share a font size: only the horizontal padding differs.
    expect(
      widths[HeroUiChipSize.md]! - widths[HeroUiChipSize.sm]!,
      heroUiCase('chip-secondary-default-md').size.width -
          heroUiCase('chip-secondary-default-sm').size.width,
    );
  });

  testWidgets('a caller style wins over the recipe', (tester) async {
    const override = Color(0xFF00FF00);
    final spec = await _pump(
      tester,
      style: BadgeStyler().color(override).labelColor(override),
    );
    expect(_decoration(spec).color, override);
    expect(spec.label.spec.style!.color, override);
  });
}
