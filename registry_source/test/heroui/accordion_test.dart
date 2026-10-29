import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registry_source/src/heroui/components/accordion.dart';
import 'package:registry_source/src/heroui/theme/theme.dart';
import 'package:remix/remix.dart';

import '../helpers/heroui.dart';

const _chevron = IconData(0xe5cf);

/// Browser colors are 8-bit; recipe colors come from the theme tokens.
const _colorTolerance = 1.5 / 255;

String _id(HeroUiAccordionVariant variant) =>
    variant == .surface ? 'surface' : 'default';

/// Three items in the upstream fixture's column: the first (`one`) open when
/// [expanded] says so, the last (`three`) being the last item.
Widget _accordion({
  HeroUiAccordionVariant variant = .defaultAccordion,
  bool enabled = true,
  List<String> expanded = const [],
  AccordionStyler style = const AccordionStyler.create(),
  BoxStyler groupStyle = const BoxStyler.create(),
  double width = 360,
}) => SizedBox(
  width: width,
  child: HeroUiAccordionGroup<String>(
    variant: variant,
    style: groupStyle,
    controller: RemixAccordionController<String>(),
    initialExpandedValues: expanded,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final (value, title, body) in [
          ('one', 'First', 'Panel text'),
          ('two', 'Second', 'Other text'),
          ('three', 'Third', 'Last text'),
        ])
          HeroUiAccordion<String>(
            variant: variant,
            style: value == 'one' ? style : const AccordionStyler.create(),
            value: value,
            title: title,
            enabled: value != 'one' || enabled,
            trailingIcon: _chevron,
            child: Text(body),
          ),
      ],
    ),
  ),
);

AccordionSpec _spec(WidgetTester tester, [String title = 'First']) =>
    tester.resolvedSpecOf<AccordionSpec>(find.text(title));

BoxDecoration? _decoration(StyleSpec<BoxSpec> box) =>
    box.spec.decoration as BoxDecoration?;

BoxDecoration _trigger(AccordionSpec spec) =>
    spec.trigger.spec.boxSpec.decoration! as BoxDecoration;

Border _triggerBorder(AccordionSpec spec) => _trigger(spec).border! as Border;

/// The card the group paints: its first `Container`.
final _cardFinder = find
    .descendant(
      of: find.byType(HeroUiAccordionGroup<String>),
      matching: find.byType(Container),
    )
    .first;

Container _card(WidgetTester tester) => tester.widget<Container>(_cardFinder);

Finder _item(int index) => find.byType(HeroUiAccordion<String>).at(index);

/// The turn of an indicator case such as `rotate: -180deg`, in radians.
double _rotation(HeroUiCase indicator) =>
    double.parse(indicator.styles['rotate']!.replaceAll('deg', '')) *
    math.pi /
    180;

void main() {
  test('variants follow HeroUI', () {
    expect(HeroUiAccordionVariant.values, [
      HeroUiAccordionVariant.defaultAccordion,
      HeroUiAccordionVariant.surface,
    ]);
  });

  for (final mode in ['light', 'dark']) {
    for (final variant in HeroUiAccordionVariant.values) {
      final id = _id(variant);

      testWidgets('${variant.name} follows accordion.css in $mode', (
        tester,
      ) async {
        final root = heroUiCase('accordion-$id-root', mode: mode);
        await tester.pumpHeroUi(
          _accordion(
            variant: variant,
            expanded: ['one'],
            width: root.size.width,
          ),
          mode: mode,
        );
        await tester.pumpAndSettle();
        final spec = _spec(tester);
        final trigger = heroUiCase('accordion-$id-closed-trigger', mode: mode);
        final indicator = heroUiCase(
          'accordion-$id-closed-indicator',
          mode: mode,
        );
        final body = heroUiCase('accordion-$id-open-body-inner', mode: mode);

        // One open item and two closed ones fill the upstream column.
        expect(tester.getSize(_cardFinder), root.size);
        expect(
          tester.getSize(_item(0)).height,
          heroUiCase('accordion-$id-open-item', mode: mode).size.height,
        );
        expect(
          tester.getSize(_item(1)).height,
          heroUiCase('accordion-$id-closed-item', mode: mode).size.height,
        );
        expect(
          tester.getSize(_item(2)).height,
          heroUiCase('accordion-$id-last-item', mode: mode).size.height,
        );

        // The group paints the card; an item paints neither fill nor radius.
        expect(_decoration(spec.container)?.color, isNull);
        expect(_decoration(spec.container)?.borderRadius, isNull);

        // .accordion__trigger: px-4 py-4, text-sm font-medium.
        final title = spec.title.spec.style!;
        expect(title.fontSize, trigger.px('fontSize'));
        expect(
          title.fontSize! * title.height!,
          closeTo(trigger.px('lineHeight'), .01),
        );
        expect(title.fontWeight, FontWeight.w500);
        expect(
          tester.getSize(find.text('First')).height,
          trigger.px('lineHeight'),
        );
        expect(
          tester
              .getSize(
                find
                    .ancestor(
                      of: find.text('First'),
                      matching: find.byType(DecoratedBox),
                    )
                    .first,
              )
              .height,
          trigger.size.height,
        );

        // .accordion__indicator: size-4 text-muted.
        expect(spec.trailingIcon.spec.size, indicator.size.width);
        expectCssColor(
          spec.trailingIcon.spec.color!,
          indicator.styles['color']!,
        );

        // .accordion__body-inner: px-4 pb-4 text-muted in text-sm.
        expect(
          spec.content.spec.padding,
          EdgeInsets.fromLTRB(
            body.px('paddingLeft'),
            body.px('paddingTop'),
            body.px('paddingRight'),
            body.px('paddingBottom'),
          ),
        );
        final text = DefaultTextStyle.of(
          tester.element(find.text('Panel text')),
        );
        expect(text.style.fontSize, body.px('fontSize'));
        expectCssColor(text.style.color!, body.styles['color']!);
      });

      testWidgets('${variant.name} item rule is the upstream color in $mode', (
        tester,
      ) async {
        await tester.pumpHeroUi(_accordion(variant: variant), mode: mode);
        await tester.pumpAndSettle();
        final rule = heroUiCase('accordion-$id-closed-separator', mode: mode);
        final border =
            (_spec(tester).container.spec.foregroundDecoration!
                        as BoxDecoration)
                    .border!
                as Border;
        expect(border.bottom.width, rule.size.height);
        expectCssColor(border.bottom.color, rule.styles['backgroundColor']!);
      });

      testWidgets(
        '${variant.name} hover fills a collapsed trigger only in $mode',
        (tester) async {
          await tester.pumpHeroUi(_accordion(variant: variant), mode: mode);
          await tester.pumpAndSettle();
          final hover = heroUiCase(
            'accordion-$id-hover-trigger',
            mode: mode,
            state: true,
          );
          expect(_trigger(_spec(tester)).color, isNull);

          await tester.hoverCenter(find.text('First'));
          expectCssColor(
            _trigger(_spec(tester)).color!,
            hover.styles['backgroundColor']!,
          );

          await tester.tap(find.text('First'));
          await tester.pumpAndSettle();
          expect(_trigger(_spec(tester)).color, isNull, reason: 'expanded');
        },
        variant: desktopOnly,
      );
    }

    testWidgets('the surface group paints one card around its items in $mode', (
      tester,
    ) async {
      final root = heroUiCase('accordion-surface-root', mode: mode);
      await tester.pumpHeroUi(
        _accordion(variant: .surface, width: root.size.width),
        mode: mode,
      );
      await tester.pumpAndSettle();

      // .accordion--surface: bg-surface and min(32px, var(--radius-3xl)).
      final card = _card(tester);
      final decoration = card.decoration! as BoxDecoration;
      expectCssColor(decoration.color!, root.styles['backgroundColor']!);
      expect(
        decoration.borderRadius,
        BorderRadius.circular(root.px('borderRadius')),
      );
      expect(card.clipBehavior, Clip.antiAlias);

      // The items sit flush inside it, so the card reads as one piece.
      final first = tester.getRect(_item(0));
      final last = tester.getRect(_item(2));
      expect(tester.getRect(_item(1)).top, first.bottom);
      final cardRect = tester.getRect(_cardFinder);
      expect(cardRect.top, first.top);
      expect(cardRect.bottom, last.bottom);
    });

    testWidgets('the default group paints nothing in $mode', (tester) async {
      await tester.pumpHeroUi(_accordion(), mode: mode);
      await tester.pumpAndSettle();
      final card = _card(tester);
      expect(card.decoration, isNull);
      expect(card.clipBehavior, Clip.none);
      expect(
        heroUiCase('accordion-default-root', mode: mode).styles,
        isNot(contains('backgroundColor')),
      );
    });

    testWidgets('keyboard focus rings the trigger without moving it in $mode', (
      tester,
    ) async {
      await tester.pumpHeroUi(_accordion(), mode: mode);
      await tester.pumpAndSettle();
      final before = tester.getRect(find.text('First'));
      expect(_triggerBorder(_spec(tester)).top.color.a, 0);
      expect(_triggerBorder(_spec(tester)).top.width, HeroUiTokens.focusWidth);

      await tester.focusWithTab();
      // accordion-default-focus-trigger: a background gap, then the focus
      // ring. The recipe draws the focus colour as a ring-width inside border.
      final layers = cssRemixShadows(
        heroUiCase(
          'accordion-default-focus-trigger',
          mode: mode,
          state: true,
        ).styles['boxShadow']!,
      );
      expect(
        _triggerBorder(_spec(tester)).top.color,
        isSameColorAs(layers.last.color, threshold: _colorTolerance),
      );
      expect(
        _triggerBorder(_spec(tester)).top.width,
        layers.last.spreadRadius - layers.first.spreadRadius,
      );
      expect(tester.getRect(find.text('First')), before);
    });

    testWidgets('disabled dims the trigger in $mode', (tester) async {
      await tester.pumpHeroUi(_accordion(enabled: false), mode: mode);
      await tester.pumpAndSettle();
      final disabled = heroUiCase('accordion-disabled-trigger', mode: mode);
      expect(
        tester.opacityAbove(find.text('First')),
        double.parse(disabled.styles['opacity']!),
      );
    });

    testWidgets('expanding turns the indicator over in $mode', (tester) async {
      await tester.pumpHeroUi(_accordion(), mode: mode);
      await tester.pumpAndSettle();
      Transform? turned() {
        final found = find.descendant(
          of: find.byType(StyledIcon),
          matching: find.byType(Transform),
        );
        return found.evaluate().isEmpty ? null : tester.widget(found.first);
      }

      expect(turned(), isNull);
      await tester.tap(find.text('First'));
      await tester.pumpAndSettle();
      // .accordion__indicator[data-expanded]: -rotate-180.
      final turn = _rotation(
        heroUiCase('accordion-default-open-indicator', mode: mode),
      );
      expect(turned()!.transform.entry(0, 0), closeTo(math.cos(turn), 1e-9));
      expect(turned()!.transform.entry(1, 0), closeTo(math.sin(turn), 1e-9));
    });
  }

  testWidgets('the column narrows to the 375px viewport', (tester) async {
    final root = heroUiCase('accordion-default-root', width: 375);
    await tester.pumpHeroUi(
      _accordion(expanded: ['one'], width: root.size.width),
      width: 375,
    );
    await tester.pumpAndSettle();
    expect(tester.getSize(_cardFinder), root.size);
    expect(
      tester.getSize(_item(0)),
      heroUiCase('accordion-default-open-item', width: 375).size,
    );
  });

  testWidgets('a disabled trigger ignores hover and taps', (tester) async {
    await tester.pumpHeroUi(_accordion(enabled: false));
    await tester.pumpAndSettle();
    await tester.hoverCenter(find.text('First'));
    expect(_trigger(_spec(tester)).color, isNull);

    await tester.tap(find.text('First'));
    await tester.pumpAndSettle();
    expect(find.text('Panel text'), findsNothing);
  }, variant: desktopOnly);

  testWidgets('tapping a trigger opens and closes its panel through Remix', (
    tester,
  ) async {
    await tester.pumpHeroUi(_accordion());
    await tester.pumpAndSettle();
    expect(find.text('Panel text'), findsNothing);

    await tester.tap(find.text('First'));
    await tester.pumpAndSettle();
    expect(find.text('Panel text'), findsOneWidget);

    await tester.tap(find.text('First'));
    await tester.pumpAndSettle();
    expect(find.text('Panel text'), findsNothing);
  });

  testWidgets('a caller style wins over the recipe', (tester) async {
    const override = Color(0xFF00FF00);
    await tester.pumpHeroUi(
      _accordion(
        style: AccordionStyler().container(BoxStyler().color(override)),
      ),
    );
    await tester.pumpAndSettle();
    expect(_decoration(_spec(tester).container)!.color, override);
  });

  testWidgets('a caller group style wins over the card', (tester) async {
    const override = Color(0xFF00FF00);
    await tester.pumpHeroUi(
      _accordion(variant: .surface, groupStyle: BoxStyler().color(override)),
    );
    await tester.pumpAndSettle();
    expect((_card(tester).decoration! as BoxDecoration).color, override);
  });
}
