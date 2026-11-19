import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registry_source/vanilla.dart';
import 'package:remix/remix.dart';

import 'support.dart';

/// shadcn/ui `examples/typography-inline-code.tsx`: a `<code>` with
/// `rounded bg-muted px-[0.3rem] py-[0.2rem] font-mono text-sm
/// font-semibold`.
void main() {
  Future<void> pump(
    WidgetTester tester,
    Widget child, {
    VanillaThemeData theme = const VanillaThemeData.light(),
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
            child: Center(child: child),
          ),
        ),
      ),
    );
  }

  /// The chip around [text].
  Finder chip(String text) =>
      find.ancestor(of: find.text(text), matching: find.byType(Box)).first;

  BoxDecoration chipDecoration(WidgetTester tester, String text) =>
      tester.widget<Box>(chip(text)).styleSpec!.spec.decoration!
          as BoxDecoration;

  TextStyle label(WidgetTester tester, String text) =>
      tester.widget<Text>(find.text(text)).style!;

  testWidgets('the chip is the 20px line with 2px above and 4px beside', (
    tester,
  ) async {
    await pump(tester, const VanillaCode('pubspec.yaml'));
    final box = tester.getRect(chip('pubspec.yaml'));
    final text = tester.getRect(find.text('pubspec.yaml'));

    expect(box.height, 24);
    expect(text.height, 20);
    expect(text.top - box.top, 2);
    expect(text.left - box.left, 4);
    expect(box.right - text.right, 4);
  });

  for (final theme in vanillaThemes) {
    testWidgets('monospace semibold foreground on muted (${theme.name})', (
      tester,
    ) async {
      await pump(tester, const VanillaCode('main.dart'), theme: theme.data);
      final style = label(tester, 'main.dart');

      expect(style.fontFamily, theme.data.monoFontFamily);
      expect(style.fontSize, 14);
      expect(style.fontWeight, FontWeight.w600);
      expect(style.color, theme.data.foreground);
      expect(chipDecoration(tester, 'main.dart').color, theme.data.muted);
      expect(
        contrastRatio(theme.data.foreground, theme.data.muted),
        greaterThanOrEqualTo(4.5),
      );
    });
  }

  group('the corners follow the theme radius, at most 4px', () {
    for (final (radius, corner) in const [
      (10.0, 4.0),
      (6.0, 2.0),
      (0.0, 0.0),
    ]) {
      testWidgets('radius $radius', (tester) async {
        await pump(
          tester,
          const VanillaCode('x'),
          theme: const VanillaThemeData.light().copyWith(
            radius: Radius.circular(radius),
          ),
        );

        expect(
          chipDecoration(tester, 'x').borderRadius,
          BorderRadius.all(Radius.circular(corner)),
        );
      });
    }
  });

  testWidgets('the chip grows with the text instead of clipping it', (
    tester,
  ) async {
    await pump(tester, const VanillaCode('main.dart'), textScale: 2);
    final box = tester.getRect(chip('main.dart'));

    expect(box.height, 44);
    expect(tester.takeException(), isNull);
  });

  testWidgets('it sits inside a paragraph as a widget span', (tester) async {
    await pump(
      tester,
      const SizedBox(
        width: 400,
        child: Text.rich(
          TextSpan(
            text: 'Install ',
            children: [
              WidgetSpan(
                alignment: PlaceholderAlignment.middle,
                child: VanillaCode('remix'),
              ),
              TextSpan(text: ' first.'),
            ],
          ),
        ),
      ),
    );

    expect(tester.getSize(chip('remix')).height, 24);
    expect(tester.takeException(), isNull);
  });

  testWidgets('code is plain text to assistive technology', (tester) async {
    final semantics = tester.ensureSemantics();
    await pump(tester, const VanillaCode('main.dart'));

    expect(
      tester.getSemantics(find.text('main.dart')),
      matchesSemantics(label: 'main.dart', textDirection: TextDirection.ltr),
    );
    semantics.dispose();
  });

  testWidgets('the caller style merges last, chip and text alike', (
    tester,
  ) async {
    await pump(
      tester,
      VanillaCode(
        'x',
        style: TextStyler()
            .fontWeight(FontWeight.w400)
            .wrap(.box(BoxStyler().color(const Color(0xFF0000FF)))),
      ),
    );

    expect(label(tester, 'x').fontWeight, FontWeight.w400);
    expect(chipDecoration(tester, 'x').color, const Color(0xFF0000FF));
    expect(tester.getSize(chip('x')).height, 24);
  });
}
