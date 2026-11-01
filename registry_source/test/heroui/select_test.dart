import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registry_source/heroui.dart';
import 'package:remix/remix.dart';

import '../helpers/heroui.dart';

/// Upstream renders the select 320px wide.
Widget _select({
  HeroUiSelectVariant variant = .primary,
  bool invalid = false,
  SelectStyler style = const SelectStyler.create(),
  ValueChanged<String?>? onChanged,
}) => SizedBox(
  width: 320,
  child: HeroUiSelect<String>(
    variant: variant,
    invalid: invalid,
    style: style,
    trigger: const RemixSelectTrigger(placeholder: 'Choose'),
    items: const [
      RemixSelectItem(value: 'apple', label: 'Apple'),
      RemixSelectItem(value: 'banana', label: 'Banana'),
    ],
    onChanged: onChanged ?? (_) {},
  ),
);

/// `IconChevronDown` in the pinned `source/react/dist/components/icons.js`
/// draws its chevron from x 2.75 to x 13.25 of the 16px slot that
/// `.select__indicator` measures.
const _chevronInkWidth = 10.5;

/// `.select__indicator` sits at `end-2`.
const _indicatorEnd = 8.0;

/// Browser colors are 8-bit; recipe colors come from the theme tokens.
const _colorTolerance = 1.5 / 255;

SelectTriggerSpec _trigger(WidgetTester tester) =>
    tester.resolvedSpecOf<SelectTriggerSpec>(find.text('Choose'));

Color? _fill(SelectTriggerSpec spec) =>
    (spec.container.spec.boxSpec.decoration as BoxDecoration?)?.color;

void main() {
  test('variants follow HeroUI', () {
    expect(HeroUiSelectVariant.values, [
      HeroUiSelectVariant.primary,
      HeroUiSelectVariant.secondary,
    ]);
  });

  for (final mode in ['light', 'dark']) {
    for (final width in [375, 1024]) {
      testWidgets('trigger matches upstream at $width px in $mode', (
        tester,
      ) async {
        await tester.pumpHeroUi(_select(), width: width.toDouble(), mode: mode);
        await tester.pumpAndSettle();
        final trigger = heroUiCase(
          'select-primary-rest-select-trigger',
          mode: mode,
          width: width,
        );
        final value = heroUiCase(
          'select-primary-rest-select-value',
          mode: mode,
          width: width,
        );
        final indicator = heroUiCase(
          'select-primary-rest-select-default-indicator',
          mode: mode,
          width: width,
        );
        final spec = _trigger(tester);

        expect(tester.getSize(find.byType(HeroUiSelect<String>)), trigger.size);
        expect(tester.getSize(find.text('Choose')).width, value.size.width);
        expect(
          (spec.container.spec.boxSpec.decoration as BoxDecoration)
              .borderRadius,
          BorderRadius.circular(trigger.px('borderRadius')),
        );
        expectCssColor(_fill(spec)!, trigger.styles['backgroundColor']!);
        expect(spec.placeholder.spec.style!.fontSize, value.px('fontSize'));
        expect(
          spec.placeholder.spec.style!.color,
          heroUiToken(HeroUiTokens.fieldPlaceholder, mode),
        );
        // Remix's chevron fills its box's width, so the glyph box is the
        // upstream chevron's ink, centered where the 16px slot is.
        expect(spec.indicator.spec.size, closeTo(_chevronInkWidth, .5));
        expectCssColor(spec.indicator.spec.color!, indicator.styles['color']!);
        final glyph = tester.getRect(
          find.byKey(const ValueKey('remix-select-indicator')),
        );
        expect(glyph.width, spec.indicator.spec.size);
        expect(
          glyph.center.dx,
          tester.getRect(find.byType(HeroUiSelect<String>)).right -
              _indicatorEnd -
              indicator.size.width / 2,
        );
      });
    }

    testWidgets('secondary uses the default fill without a shadow in $mode', (
      tester,
    ) async {
      await tester.pumpHeroUi(_select(variant: .secondary), mode: mode);
      await tester.pumpAndSettle();
      final trigger = heroUiCase(
        'select-secondary-rest-select-trigger',
        mode: mode,
      );
      final spec = _trigger(tester);
      expectCssColor(_fill(spec)!, trigger.styles['backgroundColor']!);
      expect(spec.containerEffects?.behindContent, isNull);
    });

    testWidgets('invalid draws the 1px danger ring, 2px on focus in $mode', (
      tester,
    ) async {
      await tester.pumpHeroUi(_select(invalid: true), mode: mode);
      await tester.pumpAndSettle();
      var spec = _trigger(tester);
      final danger = heroUiToken(HeroUiTokens.danger, mode);
      expect(spec.containerEffects!.outline.width, 1);
      expect(spec.containerEffects!.outline.color, danger);
      expect(_fill(spec), heroUiToken(HeroUiTokens.fieldFocus, mode));

      await tester.focusWithTab();
      spec = _trigger(tester);
      expect(spec.containerEffects!.outline.width, HeroUiTokens.focusWidth);
      expect(spec.containerEffects!.outline.color, danger);
    });

    testWidgets('hover fills the trigger with field-hover in $mode', (
      tester,
    ) async {
      await tester.pumpHeroUi(_select(), mode: mode);
      await tester.pumpAndSettle();
      await tester.hoverCenter(find.text('Choose'));
      expect(
        _fill(_trigger(tester)),
        heroUiToken(HeroUiTokens.fieldHover, mode),
      );
    }, variant: desktopOnly);

    testWidgets('keyboard focus rings the trigger and shows field-focus in '
        '$mode', (tester) async {
      await tester.pumpHeroUi(_select(), mode: mode);
      await tester.pumpAndSettle();
      final size = tester.getSize(find.byType(HeroUiSelect<String>));
      await tester.focusWithTab();
      final spec = _trigger(tester);
      expect(
        spec.containerEffects!.outline.color,
        heroUiToken(HeroUiTokens.focus, mode),
      );
      expect(spec.containerEffects!.outlineOffset, HeroUiTokens.ringOffset);
      expect(_fill(spec), heroUiToken(HeroUiTokens.fieldFocus, mode));
      expect(tester.getSize(find.byType(HeroUiSelect<String>)), size);
    });

    testWidgets('the open list matches the upstream popover and items in '
        '$mode', (tester) async {
      String? picked;
      await tester.pumpHeroUi(
        _select(onChanged: (value) => picked = value),
        mode: mode,
      );
      await tester.tap(find.text('Choose'));
      await tester.pumpAndSettle();
      final popover = heroUiCase(
        'select-primary-keyboard-open-select-popover',
        mode: mode,
      );
      final itemCase = heroUiCase(
        'select-primary-keyboard-open-list-box-item:Apple',
        mode: mode,
      );

      final content = tester.resolvedSpecOf<SelectContentSpec>(
        find.text('Apple'),
      );
      final box = content.container.spec.decoration as BoxDecoration;
      expectCssColor(box.color!, popover.styles['backgroundColor']!);
      expect(
        box.borderRadius,
        BorderRadius.circular(popover.px('borderRadius')),
      );
      expect(
        behindShadows(content.containerEffects),
        cssRemixShadows(popover.styles['boxShadow']!),
      );

      final item = tester.resolvedSpecOf<SelectMenuItemSpec>(
        find.text('Apple'),
      );
      final itemBox = item.container.spec.boxSpec;
      expect(itemBox.constraints!.minHeight, itemCase.size.height);
      expect(
        (itemBox.decoration as BoxDecoration).borderRadius,
        BorderRadius.circular(itemCase.px('borderRadius')),
      );
      expect(item.container.spec.flex!.spec.spacing, itemCase.px('gap'));

      await tester.tap(find.text('Banana'));
      await tester.pumpAndSettle();
      expect(picked, 'banana');
    });

    testWidgets('keyboard focus rings an item without moving it in $mode', (
      tester,
    ) async {
      await tester.pumpHeroUi(_select(), mode: mode);
      await tester.focusWithTab();
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();
      final item = heroUiCase(
        'select-primary-keyboard-open-list-box-item:Apple',
        mode: mode,
      );
      // A background gap, then the focus colour; the recipe draws the focus
      // colour as a ring-width inside border.
      final layers = cssRemixShadows(item.styles['boxShadow']!);
      final before = tester.getRect(find.text('Banana'));
      Border ring(String label) =>
          (tester
                          .resolvedSpecOf<SelectMenuItemSpec>(find.text(label))
                          .container
                          .spec
                          .boxSpec
                          .decoration!
                      as BoxDecoration)
                  .border!
              as Border;

      expect(
        ring('Apple').top.color,
        isSameColorAs(layers.last.color, threshold: _colorTolerance),
      );
      expect(
        ring('Apple').top.width,
        layers.last.spreadRadius - layers.first.spreadRadius,
      );
      // Opening focuses the first enabled option; ArrowDown moves to the next.
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pumpAndSettle();
      expect(ring('Apple').top.color, const Color(0x00000000));
      expect(
        ring('Banana').top.color,
        isSameColorAs(layers.last.color, threshold: _colorTolerance),
      );
      expect(tester.getRect(find.text('Banana')), before);
    });

    testWidgets('hovering an item fills it with default in $mode', (
      tester,
    ) async {
      await tester.pumpHeroUi(_select(), mode: mode);
      await tester.tap(find.text('Choose'));
      await tester.pumpAndSettle();
      SelectMenuItemSpec spec() =>
          tester.resolvedSpecOf<SelectMenuItemSpec>(find.text('Banana'));
      Color? fill() =>
          (spec().container.spec.boxSpec.decoration as BoxDecoration).color;
      expect(fill(), isNull);

      await tester.hoverCenter(find.text('Banana'));
      expect(fill(), heroUiToken(HeroUiTokens.defaultColor, mode));
    }, variant: desktopOnly);
  }

  testWidgets('a caller style wins over the recipe', (tester) async {
    const override = Color(0xFF00FF00);
    await tester.pumpHeroUi(
      _select(style: SelectStyler().trigger(.color(override))),
    );
    await tester.pumpAndSettle();
    expect(_fill(_trigger(tester)), override);
  });
}
