import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registry_source/heroui.dart';
import 'package:remix/remix.dart';

import '../helpers/heroui.dart';

SpinnerSpec _spec(WidgetTester tester) => tester.resolvedSpecOf<SpinnerSpec>(
  find.descendant(
    of: find.byType(HeroUiSpinner),
    matching: find.byType(CustomPaint),
  ),
);

void main() {
  test('sizes and colors follow HeroUI', () {
    expect(HeroUiSpinnerSize.values.map((s) => s.name), [
      'sm',
      'md',
      'lg',
      'xl',
    ]);
    expect(HeroUiSpinnerColor.values.map((c) => c.name), [
      'accent',
      'current',
      'danger',
      'success',
      'warning',
    ]);
  });

  for (final size in HeroUiSpinnerSize.values) {
    testWidgets('${size.name} sits on the upstream ring', (tester) async {
      await tester.pumpHeroUi(HeroUiSpinner(size: size));
      await tester.pump(const Duration(milliseconds: 100));
      final upstream = heroUiCase('spinner-accent-${size.name}');
      expect(tester.getSize(find.byType(HeroUiSpinner)), upstream.size);
      // The icon's ring is 3/24 of its size thick; Remix's arc is twice the
      // stroke width.
      expect(_spec(tester).strokeWidth! * 2, upstream.size.width * 3 / 24);
    });
  }

  for (final mode in ['light', 'dark']) {
    testWidgets('colors resolve to their tokens in $mode; current inherits', (
      tester,
    ) async {
      for (final (color, token) in [
        (HeroUiSpinnerColor.accent, HeroUiTokens.accent),
        (HeroUiSpinnerColor.danger, HeroUiTokens.danger),
        (HeroUiSpinnerColor.success, HeroUiTokens.success),
        (HeroUiSpinnerColor.warning, HeroUiTokens.warning),
      ]) {
        await tester.pumpHeroUi(HeroUiSpinner(color: color), mode: mode);
        await tester.pump(const Duration(milliseconds: 100));
        final spec = _spec(tester);
        expect(
          spec.indicatorColor,
          heroUiToken(token, mode),
          reason: color.name,
        );
        expect(spec.duration, const Duration(milliseconds: 750));
      }

      await tester.pumpHeroUi(const HeroUiSpinner(color: .current), mode: mode);
      await tester.pump(const Duration(milliseconds: 100));
      expect(_spec(tester).indicatorColor, isNull);
    });

    testWidgets('the inline spinner is an sm ring in the given colour in '
        '$mode', (tester) async {
      // A pending control's `<Spinner color="current" size="sm"/>`.
      const color = Color(0xFF123456);
      await tester.pumpHeroUi(
        RemixSpinner(style: heroUiInlineSpinnerStyle(color)),
        mode: mode,
      );
      await tester.pump(const Duration(milliseconds: 100));
      final upstream = heroUiCase('spinner-accent-sm', mode: mode);
      final spec = tester.resolvedSpecOf<SpinnerSpec>(
        find.descendant(
          of: find.byType(RemixSpinner),
          matching: find.byType(CustomPaint),
        ),
      );

      expect(tester.getSize(find.byType(RemixSpinner)), upstream.size);
      expect(spec.size, upstream.size.width);
      expect(spec.strokeWidth! * 2, upstream.size.width * 3 / 24);
      expect(spec.duration, const Duration(milliseconds: 750));
      // `.current` skips the accent default, so the given colour is the only
      // colour the indicator can take.
      expect(spec.indicatorColor, color);
      expect(
        spec.indicatorColor,
        isNot(heroUiToken(HeroUiTokens.accent, mode)),
      );
    });
  }

  testWidgets('the inline spinner takes a theme colour', (tester) async {
    await tester.pumpHeroUi(
      RemixSpinner(style: heroUiInlineSpinnerStyle(HeroUiTokens.muted())),
      mode: 'dark',
    );
    await tester.pump(const Duration(milliseconds: 100));
    final spec = tester.resolvedSpecOf<SpinnerSpec>(
      find.descendant(
        of: find.byType(RemixSpinner),
        matching: find.byType(CustomPaint),
      ),
    );
    expect(spec.indicatorColor, heroUiToken(HeroUiTokens.muted, 'dark'));
  });

  testWidgets('a caller style wins over the recipe', (tester) async {
    await tester.pumpHeroUi(HeroUiSpinner(style: SpinnerStyler().size(50)));
    await tester.pump(const Duration(milliseconds: 100));
    expect(tester.getSize(find.byType(HeroUiSpinner)), const Size.square(50));
  });
}
