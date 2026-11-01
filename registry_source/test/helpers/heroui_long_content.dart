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
