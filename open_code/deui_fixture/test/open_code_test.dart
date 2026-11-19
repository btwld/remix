import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:open_code_fixture/main.dart';
import 'package:open_code_fixture/ui/ui.dart';

void main() {
  group('installed Deui theme', () {
    Color paint(AcmeThemeData theme, token) => theme.tokens[token]! as Color;

    test('keeps deui light values', () {
      const theme = AcmeThemeData.light();
      expect(paint(theme, AcmeTokens.background), const Color(0xFFFCFCFC));
      expect(paint(theme, AcmeTokens.surfaceSecondary), const Color(0xFFF5F5F5));
      expect(paint(theme, AcmeTokens.overlay), const Color(0xFFF5F5F5));
      expect(paint(theme, AcmeTokens.foreground), const Color(0xFF0B0B0B));
      expect(paint(theme, AcmeTokens.muted), const Color(0xFF636363));
      expect(paint(theme, AcmeTokens.accent), const Color(0xFF0276DB));
      expect(paint(theme, AcmeTokens.highlight), const Color(0xFF00BEBF));
      expect(paint(theme, AcmeTokens.success), const Color(0xFF00BD6C));
      expect(paint(theme, AcmeTokens.warning), const Color(0xFFF5A500));
      expect(paint(theme, AcmeTokens.danger), const Color(0xFFEE343B));
      expect(theme.radius, 12);
    });

    test('keeps deui dark values', () {
      const theme = AcmeThemeData.dark();
      expect(paint(theme, AcmeTokens.background), const Color(0xFF151515));
      expect(paint(theme, AcmeTokens.surfaceSecondary), const Color(0xFF1C1C1C));
      expect(paint(theme, AcmeTokens.foreground), const Color(0xFFF2F2F2));
      expect(paint(theme, AcmeTokens.muted), const Color(0xFF868686));
      expect(paint(theme, AcmeTokens.highlight), const Color(0xFF00DADB));
    });
  });

  for (final mode in AcmeThemeMode.values) {
    testWidgets('the gallery builds every recipe in ${mode.name} mode', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(1200, 1600);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(AcmeApp(mode: mode));
      await tester.pump();
      expect(find.byType(AcmeGallery), findsOneWidget);
      expect(find.byType(AcmeButton), findsWidgets);
      expect(tester.takeException(), isNull);
    });
  }
}
