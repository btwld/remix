import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registry_source/src/heroui/components/avatar.dart';
import 'package:registry_source/src/heroui/theme/theme.dart';
import 'package:remix/remix.dart';

import '../helpers/heroui.dart';

const _label = 'JD';

String _id(HeroUiColor color) =>
    color == .defaultColor ? 'default' : color.name;

String _variantId(HeroUiAvatarVariant variant) =>
    variant == .defaultAvatar ? 'default' : variant.name;

Future<AvatarSpec> _pump(
  WidgetTester tester, {
  HeroUiAvatarVariant variant = .defaultAvatar,
  HeroUiColor color = .defaultColor,
  HeroUiAvatarSize size = .md,
  String mode = 'light',
  AvatarStyler style = const AvatarStyler.create(),
}) async {
  await tester.pumpHeroUi(
    HeroUiAvatar(
      variant: variant,
      color: color,
      size: size,
      label: _label,
      style: style,
    ),
    mode: mode,
  );
  await tester.pumpAndSettle();
  return tester.resolvedSpecOf<AvatarSpec>(find.text(_label));
}

BoxDecoration _decoration(AvatarSpec spec) =>
    spec.container.spec.decoration! as BoxDecoration;

void main() {
  test('variants, colours, and sizes follow HeroUI', () {
    expect(HeroUiAvatarVariant.values.map((v) => v.name), [
      'defaultAvatar',
      'soft',
    ]);
    expect(HeroUiColor.values.map((c) => c.name), [
      'defaultColor',
      'accent',
      'success',
      'warning',
      'danger',
    ]);
    expect(HeroUiAvatarSize.values.map((s) => s.name), ['sm', 'md', 'lg']);
  });

  test('the avatar dimension is the --avatar-size of each size', () {
    for (final size in HeroUiAvatarSize.values) {
      expect(
        heroUiAvatarDimension(size),
        heroUiCase('avatar-default-default-${size.name}').size.width,
        reason: size.name,
      );
    }
  });

  for (final mode in ['light', 'dark']) {
    testWidgets('every variant and size matches upstream in $mode', (
      tester,
    ) async {
      for (final variant in HeroUiAvatarVariant.values) {
        for (final size in HeroUiAvatarSize.values) {
          final reason = '${variant.name} ${size.name}';
          final spec = await _pump(
            tester,
            variant: variant,
            size: size,
            mode: mode,
          );
          final id = '${_variantId(variant)}-default-${size.name}';
          final root = heroUiCase('avatar-$id', mode: mode);
          final fallback = heroUiCase('avatar-fallback-$id', mode: mode);

          expect(
            tester.getSize(find.byType(HeroUiAvatar)),
            root.size,
            reason: reason,
          );
          expect(
            _decoration(spec).borderRadius,
            BorderRadius.circular(root.px('borderRadius')),
            reason: reason,
          );
          expect(
            spec.container.spec.clipBehavior,
            Clip.antiAlias,
            reason: reason,
          );
          final text = spec.label.spec.style!;
          expect(text.fontSize, fallback.px('fontSize'), reason: reason);
          expect(
            text.fontSize! * text.height!,
            closeTo(fallback.px('lineHeight'), 1e-9),
            reason: reason,
          );
          expect(text.fontWeight, FontWeight.w500, reason: reason);
        }
      }
    });

    testWidgets('the palette maps all five colours like upstream in $mode', (
      tester,
    ) async {
      for (final variant in HeroUiAvatarVariant.values) {
        for (final color in HeroUiColor.values) {
          final reason = '${variant.name} ${color.name}';
          final spec = await _pump(
            tester,
            variant: variant,
            color: color,
            mode: mode,
          );
          // Under `soft` the root is transparent and the fallback paints the
          // tint over the whole avatar, so the fallback carries the fill.
          final fallback = heroUiCase(
            'avatar-fallback-${_variantId(variant)}-${_id(color)}-md',
            mode: mode,
          );

          expectCssColor(
            _decoration(spec).color!,
            fallback.styles['backgroundColor']!,
            reason: reason,
          );
          expectCssColor(
            spec.label.spec.style!.color!,
            fallback.styles['color']!,
            reason: reason,
          );
          expectCssColor(
            spec.icon.spec.color!,
            fallback.styles['color']!,
            reason: reason,
          );
        }
      }
    });
  }

  testWidgets('a caller style wins over the recipe', (tester) async {
    const override = Color(0xFF00FF00);
    final spec = await _pump(
      tester,
      style: AvatarStyler().color(override).size(64, 64),
    );
    expect(_decoration(spec).color, override);
    expect(tester.getSize(find.byType(HeroUiAvatar)), const Size(64, 64));
  });
}
