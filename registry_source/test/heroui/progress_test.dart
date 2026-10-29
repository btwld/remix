import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registry_source/src/heroui/components/progress.dart';
import 'package:registry_source/src/heroui/theme/theme.dart';
import 'package:remix/remix.dart';

import '../helpers/heroui.dart';

/// The upstream fixture's value: the fill is 60% of the track.
const _value = .6;

String _id(HeroUiColor color) =>
    color == .defaultColor ? 'default' : color.name;

Widget _progress({
  HeroUiProgressSize size = .md,
  HeroUiColor color = .accent,
  ProgressStyler style = const ProgressStyler.create(),
}) => SizedBox(
  // The upstream fixture's column.
  width: heroUiCase('progress-accent-md-track').size.width,
  child: HeroUiProgress(size: size, color: color, style: style, value: _value),
);

ProgressSpec _spec(WidgetTester tester) => tester
    .widget<StyleSpecProvider<ProgressSpec>>(
      find.byType(StyleSpecProvider<ProgressSpec>),
    )
    .spec
    .spec;

BoxDecoration _decoration(StyleSpec<BoxSpec> box) =>
    box.spec.decoration! as BoxDecoration;

/// The painted fill, found by its color, measured as a rect.
Size _fillSize(WidgetTester tester) {
  final color = _decoration(_spec(tester).indicator).color;
  return tester.getSize(
    find
        .descendant(
          of: find.byType(RemixProgress),
          matching: find.byWidgetPredicate(
            (widget) =>
                widget is DecoratedBox &&
                (widget.decoration as BoxDecoration?)?.color == color,
          ),
        )
        .first,
  );
}

/// Browser sizes are fractional (the fill is 60% of 327).
void _expectSize(Size actual, Size expected) {
  expect(actual.width, closeTo(expected.width, .05));
  expect(actual.height, closeTo(expected.height, .05));
}

void main() {
  test('sizes and colors follow HeroUI', () {
    expect(HeroUiProgressSize.values.map((size) => size.name), [
      'sm',
      'md',
      'lg',
    ]);
    expect(HeroUiColor.values.map((color) => color.name), [
      'defaultColor',
      'accent',
      'success',
      'warning',
      'danger',
    ]);
  });

  for (final mode in ['light', 'dark']) {
    for (final size in HeroUiProgressSize.values) {
      testWidgets('${size.name} matches the upstream bar in $mode', (
        tester,
      ) async {
        await tester.pumpHeroUi(_progress(size: size), mode: mode);
        await tester.pumpAndSettle();
        final spec = _spec(tester);
        final track = heroUiCase(
          'progress-accent-${size.name}-track',
          mode: mode,
        );
        final fill = heroUiCase(
          'progress-accent-${size.name}-fill',
          mode: mode,
        );

        // h-1 rounded-xs, h-2 rounded-sm, h-3 rounded-md; full width.
        expect(tester.getSize(find.byType(RemixProgress)), track.size);
        // The container rounds and clips the track and the fill.
        expect(
          _decoration(spec.container).borderRadius,
          BorderRadius.circular(track.px('borderRadius')),
        );
        expect(
          _decoration(spec.indicator).borderRadius,
          BorderRadius.circular(fill.px('borderRadius')),
        );
        expectCssColor(
          _decoration(spec.track).color!,
          track.styles['backgroundColor']!,
        );
        _expectSize(_fillSize(tester), fill.size);
      });
    }

    testWidgets('colors fill the bar in $mode', (tester) async {
      for (final color in HeroUiColor.values) {
        await tester.pumpHeroUi(_progress(color: color), mode: mode);
        await tester.pumpAndSettle();
        final fill = heroUiCase('progress-${_id(color)}-md-fill', mode: mode);
        expectCssColor(
          _decoration(_spec(tester).indicator).color!,
          fill.styles['backgroundColor']!,
          reason: color.name,
        );
      }
    });
  }

  testWidgets('the bar narrows with the 375px viewport', (tester) async {
    final track = heroUiCase('progress-accent-md-track', width: 375);
    await tester.pumpHeroUi(
      SizedBox(
        width: track.size.width,
        child: const HeroUiProgress(value: _value),
      ),
      width: 375,
    );
    await tester.pumpAndSettle();
    expect(tester.getSize(find.byType(RemixProgress)), track.size);
    _expectSize(
      _fillSize(tester),
      heroUiCase('progress-accent-md-fill', width: 375).size,
    );
  });

  testWidgets('the bar is a progress bar for assistive technology', (
    tester,
  ) async {
    await tester.pumpHeroUi(
      const HeroUiProgress(value: _value, semanticsLabel: 'Uploading'),
    );
    final semantics = tester.getSemantics(find.bySemanticsLabel('Uploading'));
    expect(semantics.getSemanticsData().value, '60');
  });

  testWidgets('a caller style wins over the recipe', (tester) async {
    const override = Color(0xFF00FF00);
    await tester.pumpHeroUi(
      _progress(style: ProgressStyler().indicatorColor(override)),
    );
    await tester.pumpAndSettle();
    expect(_decoration(_spec(tester).indicator).color, override);
  });
}
