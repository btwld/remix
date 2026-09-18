import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registry_source/carbon.dart';

void main() {
  test('white and g10 expose pinned Carbon button values', () {
    for (final theme in CarbideTheme.values) {
      final tokens = buildCarbideTokenMap(theme);

      expect(tokens[CarbideTokens.focus], const Color(0xFF0F62FE));
      expect(tokens[CarbideTokens.focusInset], const Color(0xFFFFFFFF));
      expect(
        tokens[CarbideComponentTokens.buttonPrimary],
        const Color(0xFF0F62FE),
      );
      expect(
        tokens[CarbideComponentTokens.buttonDisabled],
        const Color(0xFFC6C6C6),
      );
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
