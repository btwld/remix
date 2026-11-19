import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registry_source/vanilla.dart';
import 'package:remix/remix.dart';

import 'support.dart';

/// shadcn/ui's Typography page (`examples/typography-*.tsx`): `p` is
/// `leading-7`, `lead` `text-xl text-muted-foreground`, `large` `text-lg
/// font-semibold`, `small` `text-sm leading-none font-medium`, `muted`
/// `text-sm text-muted-foreground`, and `blockquote` `border-l-2 pl-6
/// italic`.
void main() {
  Future<void> pump(
    WidgetTester tester,
    Widget child, {
    VanillaThemeData theme = const VanillaThemeData.light(),
    TextDirection direction = TextDirection.ltr,
    double textScale = 1,
  }) async {
    await tester.pumpWidget(
      WidgetsApp(
        color: const Color(0xFFFFFFFF),
        builder: (context, _) => VanillaTheme(
          theme: theme,
          child: MediaQuery(
            data: MediaQuery.of(
              context,
            ).copyWith(textScaler: TextScaler.linear(textScale)),
            child: Directionality(
              textDirection: direction,
              child: Center(child: SizedBox(width: 320, child: child)),
            ),
          ),
        ),
      ),
    );
  }

  TextStyle styleOf(WidgetTester tester, String text) =>
      tester.widget<Text>(find.text(text)).style!;

  final expected =
      <
        VanillaTextVariant,
        (double, double, FontWeight, Color Function(VanillaThemeData))
      >{
        .p: (16, 28, FontWeight.w400, (theme) => theme.foreground),
        .lead: (20, 28, FontWeight.w400, (theme) => theme.mutedForeground),
        .large: (18, 28, FontWeight.w600, (theme) => theme.foreground),
        .small: (14, 14, FontWeight.w500, (theme) => theme.foreground),
        .muted: (14, 20, FontWeight.w400, (theme) => theme.mutedForeground),
        .blockquote: (16, 24, FontWeight.w400, (theme) => theme.foreground),
      };

  test('every variant has a measured style', () {
    expect(expected.keys, VanillaTextVariant.values);
  });

  for (final theme in vanillaThemes) {
    for (final MapEntry(key: variant, value: values) in expected.entries) {
      testWidgets('${variant.name} (${theme.name})', (tester) async {
        final (size, line, weight, color) = values;
        await pump(
          tester,
          VanillaText('Text', variant: variant),
          theme: theme.data,
        );
        final style = styleOf(tester, 'Text');

        expect(style.fontSize, size);
        expect(style.fontSize! * style.height!, closeTo(line, 1e-9));
        expect(tester.getSize(find.text('Text')).height, line);
        expect(style.fontWeight, weight);
        expect(style.color, color(theme.data));
        expect(style.fontFamily, theme.data.fontFamily);
        expect(
          style.fontStyle,
          variant == .blockquote ? FontStyle.italic : isNot(FontStyle.italic),
        );
        expect(
          contrastRatio(color(theme.data), theme.data.background),
          greaterThanOrEqualTo(4.5),
        );
      });
    }
  }

  testWidgets('a paragraph keeps its 28px line at 200% text', (tester) async {
    await pump(tester, const VanillaText.p('Text'), textScale: 2);

    expect(tester.getSize(find.text('Text')).height, 56);
  });

  for (final direction in TextDirection.values) {
    testWidgets('a blockquote rules its start edge (${direction.name})', (
      tester,
    ) async {
      await pump(
        tester,
        const VanillaText.blockquote('Quote'),
        direction: direction,
      );
      final box = find
          .ancestor(of: find.text('Quote'), matching: find.byType(Box))
          .first;
      final decoration =
          tester.widget<Box>(box).styleSpec!.spec.decoration! as BoxDecoration;
      final border = decoration.border! as BorderDirectional;
      final outer = tester.getRect(box);
      final text = tester.getRect(find.text('Quote'));
      const theme = VanillaThemeData.light();

      expect(border.start, BorderSide(color: theme.border, width: 2));
      expect(border.end, BorderSide.none);
      expect(
        direction == TextDirection.ltr
            ? text.left - outer.left
            : outer.right - text.right,
        26,
      );
    });
  }

  testWidgets('text is plain text to assistive technology', (tester) async {
    final semantics = tester.ensureSemantics();
    await pump(tester, const VanillaText.lead('A short introduction.'));

    expect(
      tester.getSemantics(find.text('A short introduction.')),
      matchesSemantics(
        label: 'A short introduction.',
        textDirection: TextDirection.ltr,
      ),
    );
    semantics.dispose();
  });

  testWidgets('the caller style merges last', (tester) async {
    await pump(
      tester,
      VanillaText.muted(
        'A long line of secondary text that will not fit in its box',
        style: TextStyler()
            .maxLines(1)
            .overflow(.ellipsis)
            .color(const Color(0xFFFF0000)),
      ),
    );
    final text = tester.widget<Text>(find.byType(Text));

    expect(text.maxLines, 1);
    expect(text.style?.color, const Color(0xFFFF0000));
    expect(text.style?.fontSize, 14);
    expect(tester.getSize(find.byType(Text)).height, 20);
  });
}
