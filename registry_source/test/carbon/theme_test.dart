import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registry_source/carbon.dart';

void main() {
  test('all four themes expose their pinned Carbon values', () {
    const expected = {
      CarbideTheme.white: (
        background: Color(0xFFFFFFFF),
        focus: Color(0xFF0F62FE),
        inset: Color(0xFFFFFFFF),
      ),
      CarbideTheme.g10: (
        background: Color(0xFFF4F4F4),
        focus: Color(0xFF0F62FE),
        inset: Color(0xFFFFFFFF),
      ),
      CarbideTheme.g90: (
        background: Color(0xFF262626),
        focus: Color(0xFFFFFFFF),
        inset: Color(0xFF161616),
      ),
      CarbideTheme.g100: (
        background: Color(0xFF161616),
        focus: Color(0xFFFFFFFF),
        inset: Color(0xFF161616),
      ),
    };

    for (final MapEntry(key: theme, value: values) in expected.entries) {
      final tokens = buildCarbideTokenMap(theme);
      expect(tokens[CarbideTokens.background], values.background);
      expect(tokens[CarbideTokens.focus], values.focus);
      expect(tokens[CarbideTokens.focusInset], values.inset);
      expect(tokens[CarbideTokens.spacing05], 16.0);
      expect(tokens[CarbideTokens.bodyCompact01], isA<TextStyle>());
    }
  });

  testWidgets('scope exposes its selected theme', (tester) async {
    late BuildContext scopedContext;
    await tester.pumpWidget(
      CarbideScope(
        theme: CarbideTheme.g10,
        child: Builder(
          builder: (context) {
            scopedContext = context;
            return const SizedBox.shrink();
          },
        ),
      ),
    );

    expect(CarbideScope.themeOf(scopedContext), CarbideTheme.g10);
  });
}
