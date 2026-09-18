import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registry_source/carbon.dart';

void main() {
  test('all four themes expose pinned Carbon values', () {
    const backgrounds = {
      CarbideTheme.white: Color(0xFFFFFFFF),
      CarbideTheme.g10: Color(0xFFF4F4F4),
      CarbideTheme.g90: Color(0xFF262626),
      CarbideTheme.g100: Color(0xFF161616),
    };
    for (final theme in CarbideTheme.values) {
      final tokens = buildCarbideTokenMap(theme);

      expect(tokens[CarbideTokens.background], backgrounds[theme]);
      expect(
        tokens[CarbideTokens.focus],
        theme.isDark ? const Color(0xFFFFFFFF) : const Color(0xFF0F62FE),
      );
      expect(
        tokens[CarbideComponentTokens.buttonPrimary],
        const Color(0xFF0F62FE),
      );
      expect(tokens[CarbideTokens.spacing05], 16.0);
      expect(tokens[CarbideTokens.bodyCompact01], isA<TextStyle>());
    }
  });

  testWidgets('scope exposes its selected theme', (tester) async {
    late BuildContext scopedContext;
    await tester.pumpWidget(
      CarbideScope(
        theme: CarbideTheme.g100,
        child: Builder(
          builder: (context) {
            scopedContext = context;
            return const SizedBox.shrink();
          },
        ),
      ),
    );

    expect(CarbideScope.themeOf(scopedContext), CarbideTheme.g100);
  });
}
