import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:open_code_fixture/main.dart';
import 'package:open_code_fixture/ui/ui.dart';

void main() {
  test('installed source retains all four pinned Carbon themes', () {
    const expected = {
      AcmeTheme.white: (
        background: Color(0xFFFFFFFF),
        focus: Color(0xFF0F62FE),
      ),
      AcmeTheme.g10: (background: Color(0xFFF4F4F4), focus: Color(0xFF0F62FE)),
      AcmeTheme.g90: (background: Color(0xFF262626), focus: Color(0xFFFFFFFF)),
      AcmeTheme.g100: (background: Color(0xFF161616), focus: Color(0xFFFFFFFF)),
    };

    expect(AcmeTheme.values, hasLength(4));
    for (final MapEntry(key: theme, value: values) in expected.entries) {
      final tokens = buildAcmeTokenMap(theme);
      expect(tokens[AcmeTokens.background], values.background);
      expect(tokens[AcmeTokens.focus], values.focus);
      expect(
        tokens[AcmeComponentTokens.buttonPrimary],
        const Color(0xFF0F62FE),
      );
    }
  });

  testWidgets('the application renders installed scope and button', (
    tester,
  ) async {
    await tester.pumpWidget(const AcmeApp());

    expect(find.byType(AcmeScope), findsOneWidget);
    expect(find.byType(AcmeButton), findsOneWidget);
    expect(find.text('Continue'), findsOneWidget);
    expect(tester.getSize(find.byType(AcmeButton)).height, 48.0);
    expect(tester.takeException(), isNull);
  });

  testWidgets('installed button supports explicit and contextual sizing', (
    tester,
  ) async {
    await tester.pumpWidget(
      WidgetsApp(
        color: const Color(0xFFFFFFFF),
        builder: (context, _) => AcmeScope(
          child: Center(
            child: AcmeButton(
              label: 'Explicit',
              size: AcmeSize.xl,
              onPressed: () {},
            ),
          ),
        ),
      ),
    );
    expect(tester.getSize(find.byType(AcmeButton)).height, 64.0);

    await tester.pumpWidget(
      WidgetsApp(
        color: const Color(0xFFFFFFFF),
        builder: (context, _) => AcmeScope(
          child: AcmeLayoutScope(
            size: AcmeSize.sm,
            child: Center(
              child: AcmeButton(label: 'Contextual', onPressed: () {}),
            ),
          ),
        ),
      ),
    );
    expect(tester.getSize(find.byType(AcmeButton)).height, 32.0);
  });
}
