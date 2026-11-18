import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registry_source/vanilla.dart';
import 'package:remix/remix.dart';

import 'support.dart';

/// shadcn/ui `kbd.tsx`: a `Kbd` is `h-5 min-w-5 rounded-sm bg-muted px-1
/// text-xs font-medium text-muted-foreground`, turned `bg-background/20
/// text-background` inside tooltip content, and a `KbdGroup` sets keys
/// `gap-1` apart.
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
              child: Center(child: child),
            ),
          ),
        ),
      ),
    );
  }

  /// The key cap around [key]'s label.
  Finder cap(String key) =>
      find.ancestor(of: find.text(key), matching: find.byType(Box)).first;

  BoxDecoration capDecoration(WidgetTester tester, String key) =>
      tester.widget<Box>(cap(key)).styleSpec!.spec.decoration! as BoxDecoration;

  TextStyle label(WidgetTester tester, String key) =>
      tester.widget<Text>(find.text(key)).style!;

  testWidgets('a one-character key is a 20px square', (tester) async {
    await pump(tester, const VanillaKbd('K'));

    expect(tester.getSize(cap('K')), const Size.square(20));
    expect(tester.getCenter(find.text('K')), tester.getCenter(cap('K')));
  });

  testWidgets('a glyph narrower than the cap is centered in it', (
    tester,
  ) async {
    // A 6px glyph leaves the 20px minimum width with room to spare.
    await pump(tester, VanillaKbd('K', style: TextStyler().fontSize(6)));
    final paragraph = tester.renderObject<RenderParagraph>(find.text('K'));
    final glyph = paragraph
        .getBoxesForSelection(
          const TextSelection(baseOffset: 0, extentOffset: 1),
        )
        .single
        .toRect()
        .shift(paragraph.localToGlobal(Offset.zero));

    expect(tester.getSize(cap('K')).width, 20);
    expect(glyph.width, 6);
    expect(glyph.center.dx, tester.getCenter(cap('K')).dx);
  });

  testWidgets('a longer key widens the cap and keeps 4px beside it', (
    tester,
  ) async {
    await pump(tester, const VanillaKbd('Ctrl'));
    final box = tester.getRect(cap('Ctrl'));
    final text = tester.getRect(find.text('Ctrl'));

    expect(box.height, 20);
    expect(text.left - box.left, 4);
    expect(box.right - text.right, 4);
    expect(text.top - box.top, 2);
  });

  for (final theme in vanillaThemes) {
    testWidgets('the cap is muted with muted text (${theme.name})', (
      tester,
    ) async {
      await pump(tester, const VanillaKbd('K'), theme: theme.data);
      final decoration = capDecoration(tester, 'K');

      expect(decoration.color, theme.data.muted);
      expect(
        decoration.borderRadius,
        BorderRadius.all(tokenOf(theme.data, VanillaTokens.radiusSm)),
      );
      expect(label(tester, 'K').color, theme.data.mutedForeground);
      expect(label(tester, 'K').fontWeight, FontWeight.w500);
      expect(label(tester, 'K').fontSize, 12);
    });

    testWidgets('a tooltip key takes the inverted colors (${theme.name})', (
      tester,
    ) async {
      await pump(tester, const VanillaKbd.tooltip('S'), theme: theme.data);
      final dark = theme.data.brightness == Brightness.dark;

      expect(
        capDecoration(tester, 'S').color,
        tint(theme.data.background, dark ? 0.1 : 0.2),
      );
      expect(label(tester, 'S').color, theme.data.background);
    });

    testWidgets('both colorings clear 4.5:1 on their surface (${theme.name})', (
      tester,
    ) async {
      final data = theme.data;
      final dark = data.brightness == Brightness.dark;
      final tooltipCap = Color.alphaBlend(
        tint(data.background, dark ? 0.1 : 0.2),
        data.foreground,
      );

      expect(
        contrastRatio(data.mutedForeground, data.muted),
        greaterThanOrEqualTo(4.5),
      );
      expect(
        contrastRatio(data.background, tooltipCap),
        greaterThanOrEqualTo(4.5),
      );
    });
  }

  testWidgets('the cap grows with the text instead of clipping it', (
    tester,
  ) async {
    await pump(tester, const VanillaKbd('Ctrl'), textScale: 2);
    final box = tester.getRect(cap('Ctrl'));
    final text = tester.getRect(find.text('Ctrl'));

    expect(box.height, 36);
    expect(box.contains(text.topLeft) && box.contains(text.bottomRight), true);
    expect(tester.takeException(), isNull);
  });

  testWidgets('a group sets its keys 4px apart, mirrored in RTL', (
    tester,
  ) async {
    const group = VanillaKbdGroup(
      children: [VanillaKbd('Ctrl'), VanillaKbd('B')],
    );
    await pump(tester, group);
    expect(
      tester.getRect(cap('B')).left - tester.getRect(cap('Ctrl')).right,
      4,
    );
    expect(tester.getSize(find.byType(VanillaKbdGroup)).height, 20);

    await pump(tester, group, direction: TextDirection.rtl);
    expect(
      tester.getRect(cap('Ctrl')).left - tester.getRect(cap('B')).right,
      4,
    );
  });

  testWidgets('a key is plain text to assistive technology', (tester) async {
    final semantics = tester.ensureSemantics();
    await pump(tester, const VanillaKbd('K'));

    // No button and no keyboard-key trait: an HTML `kbd` has no role.
    expect(
      tester.getSemantics(find.text('K')),
      matchesSemantics(label: 'K', textDirection: TextDirection.ltr),
    );
    semantics.dispose();
  });

  testWidgets('a symbol key can be named through its style', (tester) async {
    final semantics = tester.ensureSemantics();
    await pump(
      tester,
      VanillaKbd('⌘', style: TextStyler().semanticsLabel('Command')),
    );

    expect(find.bySemanticsLabel('Command'), findsOneWidget);
    semantics.dispose();
  });

  testWidgets('a group reads as one phrase', (tester) async {
    final semantics = tester.ensureSemantics();
    await pump(
      tester,
      const VanillaKbdGroup(
        children: [VanillaKbd('Ctrl'), Text('+'), VanillaKbd('B')],
      ),
    );

    final node = tester.getSemantics(find.byType(VanillaKbdGroup));
    expect(node.label, 'Ctrl\n+\nB');
    expect(node.getSemanticsData().flagsCollection.isButton, isFalse);
    semantics.dispose();
  });

  testWidgets('the caller style merges last, cap and label alike', (
    tester,
  ) async {
    await pump(
      tester,
      VanillaKbd(
        'K',
        style: TextStyler()
            .color(const Color(0xFFFF0000))
            .wrap(.box(BoxStyler().color(const Color(0xFF0000FF)))),
      ),
    );

    expect(label(tester, 'K').color, const Color(0xFFFF0000));
    expect(capDecoration(tester, 'K').color, const Color(0xFF0000FF));
    // The rest of the cap is the recipe's.
    expect(tester.getSize(cap('K')), const Size.square(20));
  });

  test('the shipped variants are the muted cap and the tooltip cap', () {
    expect(VanillaKbdVariant.values, [
      VanillaKbdVariant.muted,
      VanillaKbdVariant.tooltip,
    ]);
    expect(const VanillaKbd.tooltip('S').variant, VanillaKbdVariant.tooltip);
    expect(const VanillaKbd('S').variant, VanillaKbdVariant.muted);
  });
}
