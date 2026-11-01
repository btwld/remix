import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registry_source/heroui.dart';
import 'package:remix_ui_fonts/remix_ui_fonts.dart';

import 'heroui.dart';

const longHeroUiAction =
    'Speichern und Benachrichtigungseinstellungen aktualisieren';
const longHeroUiLabel =
    'Email delivery preferences and important account notifications';
const longHeroUiHint =
    'Beschreiben Sie Ihr Anliegen so genau wie möglich, damit unser '
    'Support-Team schnell weiterhelfen kann';

Future<void> loadHeroUiGeist() async {
  final loader = FontLoader(RemixFonts.geist);
  for (final weight in ['Regular', 'Medium', 'SemiBold', 'Bold']) {
    loader.addFont(
      rootBundle.load(
        'packages/remix_ui_fonts/lib/fonts/geist/Geist-$weight.ttf',
      ),
    );
  }
  await loader.load();
}

Future<void> pumpHeroUiLongContent(
  WidgetTester tester,
  Widget child, {
  required double width,
  required String mode,
}) async {
  await tester.pumpHeroUi(
    Padding(padding: const EdgeInsets.all(24), child: child),
    width: width,
    mode: mode,
    theme: mode == 'light'
        ? const HeroUiThemeData.light(fontFamily: RemixFonts.geist)
        : const HeroUiThemeData.dark(fontFamily: RemixFonts.geist),
  );
  await tester.pumpAndSettle();
}

RenderParagraph heroUiParagraph(WidgetTester tester, String label) =>
    tester.renderObject<RenderParagraph>(find.text(label));

void expectHeroUiTextInside(WidgetTester tester, Finder text, Rect bounds) {
  final rect = tester.getRect(text);
  expect(rect.left, greaterThanOrEqualTo(bounds.left - .01));
  expect(rect.right, lessThanOrEqualTo(bounds.right + .01));
  expect(rect.top, greaterThanOrEqualTo(bounds.top - .01));
  expect(rect.bottom, lessThanOrEqualTo(bounds.bottom + .01));
}

/// Expects every glyph of [label] to be painted inside its own paragraph.
///
/// A fixed-height recipe can hand its label a box shorter than the lines the
/// text lays out: the paragraph's rect stays inside the component while the
/// lines past the first are clipped away. Glyph boxes expose that, where
/// [expectHeroUiTextInside] cannot.
void expectHeroUiGlyphsInside(WidgetTester tester, String label) {
  final paragraph = heroUiParagraph(tester, label);
  final boxes = paragraph.getBoxesForSelection(
    TextSelection(baseOffset: 0, extentOffset: label.length),
  );
  expect(boxes, isNotEmpty, reason: 'no glyphs for "$label"');
  for (final box in boxes) {
    expect(
      box.bottom,
      lessThanOrEqualTo(paragraph.size.height + .01),
      reason: 'glyph below the paragraph of "$label"',
    );
    expect(
      box.right,
      lessThanOrEqualTo(paragraph.size.width + .01),
      reason: 'glyph beyond the paragraph of "$label"',
    );
  }
}
