import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registry_source/src/heroui/components/separator.dart';
import 'package:remix/remix.dart';

import '../helpers/heroui.dart';

String _id(HeroUiSeparatorVariant variant) =>
    variant == .defaultSeparator ? 'default' : variant.name;

/// The fixture draws horizontal separators 160px wide and vertical ones in a
/// 32px row.
Widget _separator(
  HeroUiSeparatorVariant variant,
  Axis orientation, {
  DividerStyler style = const DividerStyler.create(),
}) => switch (orientation) {
  Axis.horizontal => SizedBox(
    width: 160,
    child: HeroUiSeparator(
      variant: variant,
      orientation: orientation,
      style: style,
    ),
  ),
  Axis.vertical => SizedBox(
    height: 32,
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        HeroUiSeparator(
          variant: variant,
          orientation: orientation,
          style: style,
        ),
      ],
    ),
  ),
};

Future<DividerSpec> _pump(
  WidgetTester tester,
  HeroUiSeparatorVariant variant,
  Axis orientation, {
  String mode = 'light',
  DividerStyler style = const DividerStyler.create(),
}) async {
  await tester.pumpHeroUi(
    _separator(variant, orientation, style: style),
    mode: mode,
  );
  await tester.pumpAndSettle();
  return tester.resolvedSpecOf<DividerSpec>(
    find
        .descendant(
          of: find.byType(HeroUiSeparator),
          matching: find.byType(Container),
        )
        .first,
  );
}

void main() {
  test('variants follow HeroUI', () {
    expect(HeroUiSeparatorVariant.values.map((v) => v.name), [
      'defaultSeparator',
      'secondary',
      'tertiary',
    ]);
  });

  for (final mode in ['light', 'dark']) {
    testWidgets('every variant and orientation matches upstream in $mode', (
      tester,
    ) async {
      for (final variant in HeroUiSeparatorVariant.values) {
        for (final orientation in Axis.values) {
          final name = orientation.name;
          final reason = '${variant.name} $name';
          final spec = await _pump(tester, variant, orientation, mode: mode);
          final upstream = heroUiCase(
            'separator-$name-${_id(variant)}',
            mode: mode,
          );

          expect(
            tester.getSize(find.byType(HeroUiSeparator)),
            upstream.size,
            reason: reason,
          );
          final decoration = spec.container.spec.decoration! as BoxDecoration;
          expectCssColor(
            decoration.color!,
            upstream.styles['backgroundColor']!,
            reason: reason,
          );
          expect(
            decoration.borderRadius,
            BorderRadius.circular(upstream.px('borderRadius')),
            reason: reason,
          );
        }
      }
    });
  }

  testWidgets('a vertical separator keeps the upstream minimum length', (
    tester,
  ) async {
    final spec = await _pump(tester, .defaultSeparator, Axis.vertical);
    expect(
      spec.container.spec.constraints!.minHeight,
      heroUiCase('separator-vertical-default').px('minHeight'),
    );
  });

  testWidgets('a caller style wins over the recipe', (tester) async {
    const override = Color(0xFF00FF00);
    final spec = await _pump(
      tester,
      .defaultSeparator,
      Axis.horizontal,
      style: DividerStyler().color(override),
    );
    expect((spec.container.spec.decoration! as BoxDecoration).color, override);
  });
}
