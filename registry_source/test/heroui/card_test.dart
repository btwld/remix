import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registry_source/src/heroui/components/card.dart';
import 'package:registry_source/src/heroui/components/typography.dart';
import 'package:registry_source/src/heroui/theme/theme.dart';
import 'package:remix/remix.dart';

import '../helpers/heroui.dart';

const _title = 'Title';
const _description = 'Subtitle';

String _id(HeroUiCardVariant variant) =>
    variant == .defaultCard ? 'default' : variant.name;

/// The card of the upstream fixture: a header, content, and footer in a
/// column spaced by `gap-3`.
Widget _card(
  HeroUiCardVariant variant, {
  CardStyler style = const CardStyler.create(),
}) => SizedBox(
  width: 280,
  child: HeroUiCard(
    variant: variant,
    style: style,
    child: const Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 12,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeroUiCardTitle(_title),
            HeroUiCardDescription(_description),
          ],
        ),
        Text('Body'),
        Text('Footer'),
      ],
    ),
  ),
);

Future<CardSpec> _pump(
  WidgetTester tester,
  HeroUiCardVariant variant, {
  String mode = 'light',
  CardStyler style = const CardStyler.create(),
}) async {
  await tester.pumpHeroUi(_card(variant, style: style), mode: mode);
  await tester.pumpAndSettle();
  return tester.resolvedSpecOf<CardSpec>(find.text(_title));
}

Color? _fill(CardSpec spec) => boxFill(spec.container);

void main() {
  test('variants follow HeroUI', () {
    expect(HeroUiCardVariant.values.map((v) => v.name), [
      'defaultCard',
      'secondary',
      'tertiary',
      'transparent',
    ]);
  });

  for (final mode in ['light', 'dark']) {
    testWidgets('every variant matches upstream in $mode', (tester) async {
      for (final variant in HeroUiCardVariant.values) {
        final spec = await _pump(tester, variant, mode: mode);
        final upstream = heroUiCase('card-${_id(variant)}', mode: mode);
        final reason = variant.name;

        // The fixture's header, content, and footer fill 148px between the
        // 16px padding and 12px gaps.
        expect(
          tester.getSize(find.byType(HeroUiCard)),
          upstream.size,
          reason: reason,
        );
        expect(
          spec.container.spec.padding,
          EdgeInsets.all(upstream.px('paddingLeft')),
          reason: reason,
        );
        final decoration = spec.container.spec.decoration as BoxDecoration?;
        expect(
          decoration?.borderRadius,
          BorderRadius.circular(upstream.px('borderRadius')),
          reason: reason,
        );
        final fill = upstream.styles['backgroundColor'];
        if (fill == null) {
          expect(_fill(spec), isNull, reason: reason);
        } else {
          expectCssColor(_fill(spec)!, fill, reason: reason);
        }
        expectShadows(
          behindShadows(spec.containerEffects),
          cssShadows(upstream.styles['boxShadow'] ?? ''),
        );
      }
    });

    testWidgets('the header text matches the card title and description in '
        '$mode', (tester) async {
      await _pump(tester, .defaultCard, mode: mode);
      final title = tester.widget<Text>(find.text(_title)).style!;
      final description = tester.widget<Text>(find.text(_description)).style!;

      // card.css `.card__title`: text-sm leading-6 font-medium text-foreground.
      expect(title.fontSize, 14);
      expect(title.fontSize! * title.height!, 24);
      expect(title.fontWeight, FontWeight.w500);
      expect(title.color, heroUiToken(HeroUiTokens.foreground, mode));
      // `.card__description`: text-sm leading-5 text-muted.
      expect(description.fontSize, 14);
      expect(description.fontSize! * description.height!, 20);
      expect(description.color, heroUiToken(HeroUiTokens.muted, mode));
    });
  }

  testWidgets('the title is a medium body-sm typography run', (tester) async {
    await _pump(tester, .defaultCard);
    final title = tester.widget<Text>(find.text(_title)).style!;

    await tester.pumpHeroUi(
      const HeroUiTypography(_title, type: .bodySm, weight: .medium),
    );
    final typography = tester.widget<Text>(find.text(_title)).style!;
    expect(title.fontSize, typography.fontSize);
    expect(title.height, typography.height);
    expect(title.fontWeight, typography.fontWeight);
    expect(title.color, typography.color);
    expect(title.letterSpacing, typography.letterSpacing);
    expect(title.fontFamily, typography.fontFamily);
  });

  testWidgets('a caller style wins over the recipe', (tester) async {
    const override = Color(0xFF00FF00);
    final spec = await _pump(
      tester,
      .defaultCard,
      style: CardStyler().color(override).padding(.all(24)),
    );
    expect(_fill(spec), override);
    expect(spec.container.spec.padding, const EdgeInsets.all(24));
  });

  testWidgets('a caller style wins over the title and description', (
    tester,
  ) async {
    const override = Color(0xFF00FF00);
    await tester.pumpHeroUi(
      Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          HeroUiCardTitle(_title, style: TextStyler().color(override)),
          HeroUiCardDescription(
            _description,
            style: TextStyler().color(override),
          ),
        ],
      ),
    );
    expect(tester.widget<Text>(find.text(_title)).style!.color, override);
    expect(tester.widget<Text>(find.text(_description)).style!.color, override);
  });
}
