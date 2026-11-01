import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registry_source/src/heroui/components/button.dart';
import 'package:registry_source/src/heroui/theme/theme.dart';
import 'package:remix/remix.dart';

import '../helpers/heroui.dart';

const _label = 'Continue';
const _glyph = IconData(0xe000, fontFamily: 'Test');

/// The measured hover, pressed, and focus captures of the outline button in a
/// group: the only variant that has them.
const _groupFirst = 'button-group-outline-md-horizontal-first';

String _id(HeroUiButtonVariant variant) =>
    variant == .dangerSoft ? 'danger-soft' : variant.name;

/// `--button-bg-hover` (button.css). Outline hovers to `default` at 60%, which
/// the measured hover case carries instead.
ColorToken _hoverToken(HeroUiButtonVariant variant) => switch (variant) {
  .primary => HeroUiTokens.accentHover,
  .secondary || .tertiary => HeroUiTokens.defaultHover,
  .outline || .ghost => HeroUiTokens.defaultColor,
  .danger => HeroUiTokens.dangerHover,
  .dangerSoft => HeroUiTokens.dangerSoftHover,
};

/// `--button-bg-pressed`: the hover fill, except outline presses to the full
/// `default`.
ColorToken _pressedToken(HeroUiButtonVariant variant) =>
    variant == .outline ? HeroUiTokens.defaultColor : _hoverToken(variant);

/// The pressed scale of `.button--sm|md|lg:active`.
double _pressedScale(HeroUiButtonSize size) => switch (size) {
  .sm => .98,
  .md => .97,
  .lg => .96,
};

/// Expects the hover fill of [variant] in [mode].
void _expectHoverFill(Color? actual, HeroUiButtonVariant variant, String mode) {
  if (variant == .outline) {
    final hover = heroUiCase('$_groupFirst-hover', mode: mode, state: true);
    expectCssColor(actual!, hover.styles['backgroundColor']!, reason: 'hover');
  } else {
    expect(actual, heroUiToken(_hoverToken(variant), mode));
  }
}

Future<ButtonSpec> _pump(
  WidgetTester tester, {
  HeroUiButtonVariant variant = .primary,
  HeroUiButtonSize size = .md,
  String mode = 'light',
  double width = 1024,
  bool enabled = true,
  bool loading = false,
  bool fullWidth = false,
  IconData? leadingIcon,
  VoidCallback? onPressed,
  ButtonStyler style = const ButtonStyler.create(),
}) async {
  await tester.pumpHeroUi(
    HeroUiButton(
      variant: variant,
      size: size,
      fullWidth: fullWidth,
      label: _label,
      leadingIcon: leadingIcon,
      enabled: enabled,
      loading: loading,
      style: style,
      onPressed: onPressed ?? () {},
    ),
    mode: mode,
    width: width,
  );
  // A loading button's spinner never settles.
  loading
      ? await tester.pump(const Duration(milliseconds: 100))
      : await tester.pumpAndSettle();
  return _spec(tester);
}

ButtonSpec _spec(WidgetTester tester) =>
    tester.resolvedSpecOf<ButtonSpec>(find.text(_label));

IconButtonSpec _iconSpec(WidgetTester tester) =>
    tester.resolvedSpecOf<IconButtonSpec>(find.byType(Icon));

BoxDecoration _decoration(ButtonSpec spec) =>
    spec.container.spec.boxSpec.decoration! as BoxDecoration;

Color? _fill(ButtonSpec spec) => boxFill(spec.container.spec.box!);

/// The smallest scale among the label's ancestors; 1 when there is none.
double _scale(WidgetTester tester, [Finder? of]) => tester
    .widgetList<Transform>(
      find.ancestor(
        of: of ?? find.text(_label),
        matching: find.byType(Transform),
      ),
    )
    .map((transform) => transform.transform.entry(0, 0))
    .fold(1.0, (a, b) => a < b ? a : b);

void main() {
  test('variants and sizes follow HeroUI', () {
    expect(HeroUiButtonVariant.values.map((v) => v.name), [
      'primary',
      'secondary',
      'tertiary',
      'outline',
      'ghost',
      'danger',
      'dangerSoft',
    ]);
    expect(HeroUiButtonSize.values.map((s) => s.name), ['sm', 'md', 'lg']);
  });

  for (final mode in ['light', 'dark']) {
    for (final width in [375, 1024]) {
      testWidgets(
        'every variant and size matches upstream at $width px in $mode',
        (tester) async {
          for (final variant in HeroUiButtonVariant.values) {
            for (final size in HeroUiButtonSize.values) {
              final reason = '${variant.name} ${size.name}';
              final spec = await _pump(
                tester,
                variant: variant,
                size: size,
                mode: mode,
                width: width.toDouble(),
              );
              final upstream = heroUiCase(
                'button-${_id(variant)}-${size.name}',
                mode: mode,
                width: width,
              );

              expect(
                tester.getSize(find.byType(HeroUiButton)).height,
                upstream.size.height,
                reason: reason,
              );
              expect(
                _decoration(spec).borderRadius,
                BorderRadius.circular(upstream.px('borderRadius')),
                reason: reason,
              );
              expect(
                spec.container.spec.boxSpec.padding,
                EdgeInsets.symmetric(horizontal: upstream.px('paddingLeft')),
                reason: reason,
              );
              final text = spec.label.spec.style!;
              expect(text.fontSize, upstream.px('fontSize'), reason: reason);
              expect(
                text.fontSize! * text.height!,
                upstream.px('lineHeight'),
                reason: reason,
              );
              expect(text.fontWeight, FontWeight.w500, reason: reason);
              expectFill(_fill(spec), upstream, reason: reason);
              final foreground = upstream.styles['color']!;
              expectCssColor(text.color!, foreground, reason: reason);
              expectCssColor(spec.icon.spec.color!, foreground, reason: reason);
            }
          }
        },
      );
    }
  }

  for (final mode in ['light', 'dark']) {
    testWidgets('outline draws the 1px border token in $mode; others none', (
      tester,
    ) async {
      final solid = await _pump(tester, mode: mode);
      final solidWidth = tester.getSize(find.byType(HeroUiButton)).width;
      expect(_decoration(solid).border, isNull);

      final outline = await _pump(tester, variant: .outline, mode: mode);
      final upstream = heroUiCase('button-outline-md', mode: mode);
      final border = _decoration(outline).border! as Border;
      expect(border.top.width, heroUiCase(_groupFirst).px('borderTopWidth'));
      expectCssColor(border.top.color, upstream.styles['borderColor']!);
      // The border adds to the width, not the height.
      expect(
        tester.getSize(find.byType(HeroUiButton)).width - solidWidth,
        upstream.size.width -
            heroUiCase('button-primary-md', mode: mode).size.width,
      );
      expect(
        tester.getSize(find.byType(HeroUiButton)).height,
        upstream.size.height,
      );
    });
  }

  testWidgets('a leading icon adds its size and the pulled-in gap', (
    tester,
  ) async {
    for (final width in [375, 1024]) {
      await _pump(tester, width: width.toDouble());
      final plain = tester.getSize(find.byType(HeroUiButton)).width;
      final spec = await _pump(
        tester,
        width: width.toDouble(),
        leadingIcon: _glyph,
      );
      final withIcon = tester.getSize(find.byType(HeroUiButton)).width;
      final upstreamPlain = heroUiCase('button-primary-md', width: width);
      final upstreamIcon = heroUiCase('button-leading', width: width);

      expect(
        withIcon - plain,
        upstreamIcon.size.width - upstreamPlain.size.width,
        reason: '$width',
      );
      expect(spec.icon.spec.size, width == 375 ? 20 : 16, reason: '$width');
    }
  });

  testWidgets('the small size keeps 16px icons on narrow screens', (
    tester,
  ) async {
    final spec = await _pump(tester, size: .sm, width: 375);
    expect(spec.icon.spec.size, 16);
  });

  for (final mode in ['light', 'dark']) {
    for (final variant in HeroUiButtonVariant.values) {
      testWidgets(
        '${variant.name} hovers and presses with its variant fills in $mode',
        (tester) async {
          await _pump(tester, variant: variant, mode: mode);
          final rest = _fill(_spec(tester));
          expect(_scale(tester), 1);

          final mouse = await tester.hoverCenter(find.text(_label));
          final hovered = _fill(_spec(tester));
          expect(hovered, isNot(rest));
          _expectHoverFill(hovered, variant, mode);

          await mouse.down(tester.getCenter(find.text(_label)));
          await tester.pumpAndSettle();
          expect(_scale(tester), closeTo(_pressedScale(.md), 1e-6));
          // A pointer press keeps the hover fill: button.css declares :hover
          // after :active.
          expect(_fill(_spec(tester)), hovered);
          await mouse.up();
          await mouse.removePointer();

          // Without a hover (touch), `:active` shows `--button-bg-pressed`.
          await _pump(tester, variant: variant, mode: mode);
          final touch = await tester.pressCenter(find.text(_label));
          expect(_scale(tester), closeTo(_pressedScale(.md), 1e-6));
          expect(
            _fill(_spec(tester)),
            heroUiToken(_pressedToken(variant), mode),
          );
          await touch.up();
        },
      );
    }

    testWidgets('each size presses to its own scale in $mode', (tester) async {
      for (final size in HeroUiButtonSize.values) {
        await _pump(tester, size: size, mode: mode);
        final touch = await tester.pressCenter(find.text(_label));
        expect(
          _scale(tester),
          closeTo(_pressedScale(size), 1e-6),
          reason: size.name,
        );
        await touch.up();
      }
    });

    testWidgets('outline hover and pointer press match the measured fills in '
        '$mode', (tester) async {
      await _pump(tester, variant: .outline, mode: mode);
      final mouse = await tester.hoverCenter(find.text(_label));
      final hover = heroUiCase('$_groupFirst-hover', mode: mode, state: true);
      expectCssColor(
        _fill(_spec(tester))!,
        hover.styles['backgroundColor']!,
        reason: 'hover',
      );

      await mouse.down(tester.getCenter(find.text(_label)));
      await tester.pumpAndSettle();
      final pressed = heroUiCase(
        '$_groupFirst-pressed',
        mode: mode,
        state: true,
      );
      expectCssColor(
        _fill(_spec(tester))!,
        pressed.styles['backgroundColor']!,
        reason: 'pressed',
      );
      await mouse.up();
    });

    testWidgets('keyboard focus draws the measured ring in $mode', (
      tester,
    ) async {
      final rest = await _pump(tester, mode: mode);
      expect(rest.containerEffects?.isEmpty ?? true, isTrue);
      final before = tester.getSize(find.byType(HeroUiButton));

      await tester.focusWithTab();
      expectFocusRing(
        _spec(tester).containerEffects,
        heroUiCase('$_groupFirst-focus', mode: mode, state: true),
      );
      expect(tester.getSize(find.byType(HeroUiButton)), before);
    });

    testWidgets('disabled dims like upstream and ignores input in $mode', (
      tester,
    ) async {
      var pressed = 0;
      await _pump(
        tester,
        enabled: false,
        mode: mode,
        onPressed: () => pressed++,
      );
      expect(
        tester.opacityAbove(find.text(_label)),
        double.parse(
          heroUiCase('button-disabled', mode: mode).styles['opacity']!,
        ),
      );
      await tester.tap(find.text(_label));
      expect(pressed, 0);

      // pointer-events: none, so hover does not recolor it.
      final rest = _fill(_spec(tester));
      await tester.hoverCenter(find.text(_label));
      expect(_fill(_spec(tester)), rest);
    });

    testWidgets(
      'loading keeps the size, dims like pending, and spins in $mode',
      (tester) async {
        var pressed = 0;
        await _pump(tester, mode: mode);
        final size = tester.getSize(find.byType(HeroUiButton));

        final spec = await _pump(
          tester,
          loading: true,
          mode: mode,
          onPressed: () => pressed++,
        );
        final pending = heroUiCase('button-pending', mode: mode);
        expect(tester.getSize(find.byType(HeroUiButton)), size);
        expect(
          tester.opacityAbove(find.text(_label)),
          double.parse(pending.styles['opacity']!),
        );
        expectFill(_fill(spec), pending);

        final spinner = tester.resolvedSpecOf<SpinnerSpec>(
          find.descendant(
            of: find.byType(RemixSpinner),
            matching: find.byType(CustomPaint),
          ),
        );
        expect(spinner.size, heroUiCase('spinner-accent-sm').size.width);
        expectCssColor(spinner.indicatorColor!, pending.styles['color']!);

        await tester.tap(find.byType(HeroUiButton));
        expect(pressed, 0);
      },
    );
  }

  testWidgets('fullWidth fills the available width and centres the label', (
    tester,
  ) async {
    await tester.pumpHeroUi(
      const SizedBox(
        width: 300,
        child: HeroUiButton(label: _label, fullWidth: true),
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.getSize(find.byType(HeroUiButton)).width, 300);
    expect(
      tester.getCenter(find.text(_label)).dx,
      tester.getCenter(find.byType(HeroUiButton)).dx,
    );
  });

  testWidgets('breakpoints switch at 640 and 768 px, inclusive', (
    tester,
  ) async {
    // button.css: `h-10 md:h-9`, and the icon's `size-5 sm:size-4`.
    for (final (width, height, icon) in [
      (639.0, 40.0, 20.0),
      (640.0, 40.0, 16.0),
      (767.0, 40.0, 16.0),
      (768.0, 36.0, 16.0),
    ]) {
      final spec = await _pump(tester, width: width, leadingIcon: _glyph);
      expect(
        tester.getSize(find.byType(HeroUiButton)).height,
        height,
        reason: '$width',
      );
      expect(spec.icon.spec.size, icon, reason: '$width');
    }
  });

  testWidgets('a caller style wins over the recipe', (tester) async {
    const override = Color(0xFF00FF00);
    final spec = await _pump(
      tester,
      style: ButtonStyler()
          .color(override)
          // The recipe sets the desktop height in a breakpoint fragment, so an
          // override of it is a fragment too.
          .onBreakpoint(
            const Breakpoint.minWidth(HeroUiTokens.breakpointMd),
            ButtonStyler().height(50),
          ),
    );
    expect(_fill(spec), override);
    expect(tester.getSize(find.byType(HeroUiButton)).height, 50);

    await _pump(tester, width: 375, style: ButtonStyler().height(50));
    expect(tester.getSize(find.byType(HeroUiButton)).height, 50);
  });

  testWidgets('pressing runs the Remix callback', (tester) async {
    var pressed = 0;
    await _pump(tester, onPressed: () => pressed++);
    await tester.tap(find.text(_label));
    expect(pressed, 1);
  });

  group('icon button', () {
    Future<IconButtonSpec> pumpIcon(
      WidgetTester tester, {
      HeroUiButtonVariant variant = .primary,
      HeroUiButtonSize size = .md,
      String mode = 'light',
      double width = 1024,
      bool enabled = true,
      bool loading = false,
      VoidCallback? onPressed,
      IconButtonStyler style = const IconButtonStyler.create(),
    }) async {
      await tester.pumpHeroUi(
        HeroUiIconButton(
          variant: variant,
          size: size,
          icon: _glyph,
          semanticLabel: 'Confirm',
          enabled: enabled,
          loading: loading,
          style: style,
          onPressed: onPressed ?? () {},
        ),
        mode: mode,
        width: width,
      );
      // A loading button's spinner never settles.
      loading
          ? await tester.pump(const Duration(milliseconds: 100))
          : await tester.pumpAndSettle();
      return _iconSpec(tester);
    }

    for (final width in [375, 1024]) {
      testWidgets('is square at the button height at $width px', (
        tester,
      ) async {
        for (final size in HeroUiButtonSize.values) {
          await pumpIcon(tester, size: size, width: width.toDouble());
          final upstream = heroUiCase(
            'button-primary-${size.name}',
            width: width,
          );
          expect(
            tester.getSize(find.byType(HeroUiIconButton)),
            Size.square(upstream.size.height),
            reason: size.name,
          );
        }
        // button-icon is the same control upstream, measured at md.
        await pumpIcon(tester, width: width.toDouble());
        expect(
          tester.getSize(find.byType(HeroUiIconButton)),
          heroUiCase('button-icon', width: width).size,
        );
      });
    }

    for (final mode in ['light', 'dark']) {
      testWidgets('every variant paints the button colours in $mode', (
        tester,
      ) async {
        for (final variant in HeroUiButtonVariant.values) {
          final spec = await pumpIcon(tester, variant: variant, mode: mode);
          // An icon-only button is the same `.button--<variant>` upstream.
          final upstream = heroUiCase('button-${_id(variant)}-md', mode: mode);
          expectFill(boxFill(spec.container), upstream, reason: variant.name);
          expectCssColor(
            spec.icon.spec.color!,
            upstream.styles['color']!,
            reason: variant.name,
          );
          expect(
            (spec.container.spec.decoration! as BoxDecoration).borderRadius,
            BorderRadius.circular(
              heroUiCase('button-icon', mode: mode).px('borderRadius'),
            ),
            reason: variant.name,
          );
        }
      });

      testWidgets('hover and press use the variant fills in $mode', (
        tester,
      ) async {
        for (final variant in HeroUiButtonVariant.values) {
          await pumpIcon(tester, variant: variant, mode: mode);
          final finder = find.byType(Icon);
          final rest = boxFill(_iconSpec(tester).container);
          expect(_scale(tester, finder), 1, reason: variant.name);

          final mouse = await tester.hoverCenter(finder);
          final hovered = boxFill(_iconSpec(tester).container);
          expect(hovered, isNot(rest), reason: variant.name);
          _expectHoverFill(hovered, variant, mode);

          await mouse.down(tester.getCenter(finder));
          await tester.pumpAndSettle();
          expect(
            _scale(tester, finder),
            closeTo(_pressedScale(.md), 1e-6),
            reason: variant.name,
          );
          expect(
            boxFill(_iconSpec(tester).container),
            hovered,
            reason: variant.name,
          );
          await mouse.up();
          await mouse.removePointer();

          await pumpIcon(tester, variant: variant, mode: mode);
          final touch = await tester.pressCenter(finder);
          expect(
            boxFill(_iconSpec(tester).container),
            heroUiToken(_pressedToken(variant), mode),
            reason: variant.name,
          );
          await touch.up();
        }
      });

      testWidgets('each size presses to its own scale in $mode', (
        tester,
      ) async {
        for (final size in HeroUiButtonSize.values) {
          await pumpIcon(tester, size: size, mode: mode);
          final touch = await tester.pressCenter(find.byType(Icon));
          expect(
            _scale(tester, find.byType(Icon)),
            closeTo(_pressedScale(size), 1e-6),
            reason: size.name,
          );
          await touch.up();
        }
      });

      testWidgets('keyboard focus draws the measured ring in $mode', (
        tester,
      ) async {
        final rest = await pumpIcon(tester, mode: mode);
        expect(rest.containerEffects?.isEmpty ?? true, isTrue);
        final before = tester.getSize(find.byType(HeroUiIconButton));

        await tester.focusWithTab();
        expectFocusRing(
          _iconSpec(tester).containerEffects,
          heroUiCase('$_groupFirst-focus', mode: mode, state: true),
        );
        expect(tester.getSize(find.byType(HeroUiIconButton)), before);
      });

      testWidgets('disabled dims like upstream and ignores input in $mode', (
        tester,
      ) async {
        var pressed = 0;
        await pumpIcon(
          tester,
          enabled: false,
          mode: mode,
          onPressed: () => pressed++,
        );
        expect(
          tester.opacityAbove(find.byType(Icon)),
          double.parse(
            heroUiCase('button-disabled', mode: mode).styles['opacity']!,
          ),
        );
        await tester.tap(find.byType(HeroUiIconButton));
        expect(pressed, 0);

        final rest = boxFill(_iconSpec(tester).container);
        await tester.hoverCenter(find.byType(Icon));
        expect(boxFill(_iconSpec(tester).container), rest);
      });

      testWidgets('loading keeps the size, dims like pending, and spins in '
          '$mode', (tester) async {
        var pressed = 0;
        await pumpIcon(tester, mode: mode);
        final size = tester.getSize(find.byType(HeroUiIconButton));

        final spec = await pumpIcon(
          tester,
          loading: true,
          mode: mode,
          onPressed: () => pressed++,
        );
        final pending = heroUiCase('button-pending', mode: mode);
        expect(tester.getSize(find.byType(HeroUiIconButton)), size);
        expect(
          tester.opacityAbove(find.byType(Icon)),
          double.parse(pending.styles['opacity']!),
        );
        expect(boxFill(spec.container), heroUiToken(HeroUiTokens.accent, mode));

        final spinner = tester.resolvedSpecOf<SpinnerSpec>(
          find.descendant(
            of: find.byType(RemixSpinner),
            matching: find.byType(CustomPaint),
          ),
        );
        expect(spinner.size, heroUiCase('spinner-accent-sm').size.width);
        expectCssColor(spinner.indicatorColor!, pending.styles['color']!);

        await tester.tap(find.byType(HeroUiIconButton));
        expect(pressed, 0);
      });
    }

    testWidgets('a caller style wins over the recipe', (tester) async {
      await pumpIcon(
        tester,
        style: IconButtonStyler().onBreakpoint(
          const Breakpoint.minWidth(HeroUiTokens.breakpointMd),
          IconButtonStyler().size(60, 60),
        ),
      );
      expect(tester.getSize(find.byType(HeroUiIconButton)), const Size(60, 60));
    });
  });
}
