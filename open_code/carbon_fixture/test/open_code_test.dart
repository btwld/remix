import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:open_code_fixture/main.dart';
import 'package:open_code_fixture/ui/ui.dart';

void main() {
  test('installed Carbon themes retain pinned button values', () {
    for (final theme in AcmeTheme.values) {
      final tokens = buildAcmeTokenMap(theme);
      expect(tokens[AcmeTokens.focus], const Color(0xFF0F62FE));
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
}
