import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:playground/ui/ui.dart';
import 'package:remix/remix.dart';
import 'package:remix_ui_fonts/remix_ui_fonts.dart';

/// Covers the application-owned theme this app installs from the default
/// registry preset.
///
/// The previews render the installed components, but nothing renders the
/// theme values themselves. `dart analyze` proves the theme compiles and
/// `tool/check_open_code_dogfood.dart` proves it still matches the templates,
/// but neither one runs it.
void main() {
  test('every declared token has a value in both brightnesses', () {
    for (final data in const [
      PlaygroundThemeData.light(),
      PlaygroundThemeData.dark(),
    ]) {
      final tokens = data.tokens;

      // Deliberately no token count here. `open_code/fixture` owns that pin for
      // a freshly generated consumer; duplicating the number would mean two
      // places to edit for one added token.
      expect(tokens.keys.toSet(), <MixToken<Object?>>{
        ...PlaygroundTokens.colors,
        ...PlaygroundTokens.radii,
        ...PlaygroundTokens.textStyles,
      });
      for (final token in PlaygroundTokens.colors) {
        expect(tokens[token], isA<Color>(), reason: token.name);
      }
      expect(tokens[PlaygroundTokens.radiusLg], data.radius);
    }
  });

  test('the theme is the stock Vanilla template', () {
    // This app declares no theme edit, so the dogfood check already requires
    // the installed theme to match the template byte for byte. These are the
    // stock values themselves, which also fail if the check is ever taught to
    // allow a theme edit here.
    const light = PlaygroundThemeData.light();

    expect(light.primary, const Color(0xFF171717));
    expect(light.primaryForeground, const Color(0xFFFAFAFA));
    expect(light.ring, const Color(0xFFA1A1A1));
    expect(light.radius, const Radius.circular(10));
    expect(light.fontFamily, RemixFonts.geist);
    expect(light.monoFontFamily, RemixFonts.geistMono);
  });

  testWidgets('the scope resolves tokens for stylers below it', (tester) async {
    late BuildContext inner;
    await tester.pumpWidget(
      PlaygroundThemeScope(
        mode: PlaygroundThemeMode.light,
        child: Builder(
          builder: (context) {
            inner = context;
            return const SizedBox();
          },
        ),
      ),
    );

    // Both halves of the scope, because the two are installed together and a
    // styler that resolves below it reads the Mix side, not the inherited one.
    expect(
      MixScope.tokenOf(PlaygroundTokens.primary, inner),
      const Color(0xFF171717),
    );
    expect(PlaygroundTheme.of(inner).primary, const Color(0xFF171717));
  });
}
