import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registry_source/src/heroui/components/badge.dart';
import 'package:registry_source/src/heroui/theme/theme.dart';
import 'package:remix/remix.dart';

import '../helpers/heroui.dart';

const _anchor = Key('anchor');

String _id(HeroUiColor color) =>
    color == .defaultColor ? 'default' : color.name;

Future<BadgeSpec> _pump(
  WidgetTester tester, {
  String? label = '3',
  HeroUiBadgeVariant variant = .primary,
  HeroUiColor color = .danger,
  HeroUiBadgeSize size = .md,
  HeroUiBadgePlacement placement = .topRight,
  String mode = 'light',
  BadgeStyler style = const BadgeStyler.create(),
}) async {
  await tester.pumpHeroUi(
    Padding(
      padding: const EdgeInsets.all(40),
      child: HeroUiBadge(
        label: label,
        variant: variant,
        color: color,
        size: size,
        placement: placement,
        style: style,
        child: const SizedBox.square(key: _anchor, dimension: 48),
      ),
    ),
    mode: mode,
  );
  await tester.pumpAndSettle();
  return tester.resolvedSpecOf<BadgeSpec>(find.text(label ?? ''));
}

BoxDecoration _decoration(BadgeSpec spec) =>
    spec.container.spec.decoration! as BoxDecoration;

void main() {
  test('variants, colours, sizes, and placements follow HeroUI', () {
    expect(HeroUiBadgeVariant.values.map((v) => v.name), [
      'primary',
      'secondary',
      'soft',
    ]);
    expect(HeroUiColor.values.map((c) => c.name), [
      'defaultColor',
      'accent',
      'success',
      'warning',
      'danger',
    ]);
    expect(HeroUiBadgeSize.values.map((s) => s.name), ['sm', 'md', 'lg']);
    expect(HeroUiBadgePlacement.values.map((p) => p.name), [
      'topRight',
      'topLeft',
      'bottomRight',
      'bottomLeft',
    ]);
  });

  for (final mode in ['light', 'dark']) {
    testWidgets('every variant, colour, and size matches upstream in $mode', (
      tester,
    ) async {
      for (final variant in HeroUiBadgeVariant.values) {
        for (final color in HeroUiColor.values) {
          for (final size in HeroUiBadgeSize.values) {
            final reason = '${variant.name} ${color.name} ${size.name}';
            final spec = await _pump(
              tester,
              variant: variant,
              color: color,
              size: size,
              mode: mode,
            );
            final upstream = heroUiCase(
              'badge-${variant.name}-${_id(color)}-${size.name}',
              mode: mode,
            );

            expect(
              tester.getSize(find.byType(RemixBadge)),
              upstream.size,
              reason: reason,
            );
            final decoration = _decoration(spec);
            expect(
              decoration.borderRadius,
              BorderRadius.circular(upstream.px('borderRadius')),
              reason: reason,
            );
            expectCssColor(
              decoration.color!,
              upstream.styles['backgroundColor']!,
              reason: reason,
            );
            final border = decoration.border! as Border;
            expect(
              border.top.width,
              upstream.px('borderTopWidth'),
              reason: reason,
            );
            expectCssColor(
              border.top.color,
              upstream.styles['borderColor']!,
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
            expectCssColor(
              text.color!,
              upstream.styles['color']!,
              reason: reason,
            );
          }
        }
      }
    });

    testWidgets('a badge without overrides is primary, default, md in $mode', (
      tester,
    ) async {
      // @heroui/styles defaultVariants: color default, size md, variant primary.
      await tester.pumpHeroUi(
        const Padding(
          padding: EdgeInsets.all(40),
          child: HeroUiBadge(
            label: '3',
            child: SizedBox.square(key: _anchor, dimension: 48),
          ),
        ),
        mode: mode,
      );
      await tester.pumpAndSettle();
      final spec = tester.resolvedSpecOf<BadgeSpec>(find.text('3'));
      final upstream = heroUiCase('badge-primary-default-md', mode: mode);

      expect(tester.getSize(find.byType(RemixBadge)), upstream.size);
      final decoration = _decoration(spec);
      expectCssColor(decoration.color!, upstream.styles['backgroundColor']!);
      expect(
        decoration.borderRadius,
        BorderRadius.circular(upstream.px('borderRadius')),
      );
      expectCssColor(spec.label.spec.style!.color!, upstream.styles['color']!);
      // The default placement is the top right corner, shifted out a quarter.
      expect(
        tester.getTopRight(find.byType(RemixBadge)),
        tester.getTopRight(find.byKey(_anchor)) +
            Offset(upstream.size.width / 4, -upstream.size.height / 4),
      );
    });
  }

  testWidgets('a label wider than the minimum grows the badge', (tester) async {
    await _pump(tester, label: '99+');
    expect(tester.getSize(find.byType(RemixBadge)).width, greaterThan(28));
    expect(tester.getSize(find.byType(RemixBadge)).height, 28);
  });

  testWidgets('without a label the badge is the empty dot', (tester) async {
    await _pump(tester, label: null, size: .sm);
    expect(
      tester.getSize(find.byType(RemixBadge)),
      heroUiCase('badge-primary-danger-sm').size,
    );
  });

  testWidgets('each placement pins a corner and shifts out by a quarter', (
    tester,
  ) async {
    // badge.css: `top-0 right-0` with `translate(25%, -25%)`, and so on.
    final badgeSize = heroUiCase('badge-anchored-top-right').size;
    final anchorSize = heroUiCase('badge-anchor-top-right').size;
    expect(anchorSize, const Size(48, 48));
    final shift = Offset(badgeSize.width / 4, badgeSize.height / 4);

    for (final (placement, corner, outward) in [
      (
        HeroUiBadgePlacement.topRight,
        (Rect rect) => rect.topRight,
        Offset(shift.dx, -shift.dy),
      ),
      (
        HeroUiBadgePlacement.topLeft,
        (Rect rect) => rect.topLeft,
        Offset(-shift.dx, -shift.dy),
      ),
      (
        HeroUiBadgePlacement.bottomRight,
        (Rect rect) => rect.bottomRight,
        Offset(shift.dx, shift.dy),
      ),
      (
        HeroUiBadgePlacement.bottomLeft,
        (Rect rect) => rect.bottomLeft,
        Offset(-shift.dx, shift.dy),
      ),
    ]) {
      await _pump(tester, placement: placement);
      expect(tester.getSize(find.byType(RemixBadge)), badgeSize);
      final anchor = tester.getRect(find.byKey(_anchor));
      final badge = tester.getRect(find.byType(RemixBadge));
      expect(corner(badge), corner(anchor) + outward, reason: placement.name);
    }
  });

  testWidgets('the anchor keeps its own size', (tester) async {
    await _pump(tester);
    expect(tester.getSize(find.byKey(_anchor)), const Size(48, 48));
  });

  testWidgets('a caller style wins over the recipe', (tester) async {
    const override = Color(0xFF00FF00);
    final spec = await _pump(tester, style: BadgeStyler().color(override));
    expect(_decoration(spec).color, override);
  });
}
