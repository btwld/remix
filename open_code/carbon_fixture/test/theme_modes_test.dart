import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:open_code_fixture/ui/ui.dart';

void main() {
  late AcmeTheme active;
  late Color background;

  Widget probe() => Builder(
    builder: (context) {
      active = AcmeScope.themeOf(context);
      background = AcmeTokens.background.resolve(context);
      return const SizedBox.shrink();
    },
  );

  Widget host({required AcmeTheme theme, AcmeThemeOverrides? overrides}) =>
      Directionality(
        textDirection: TextDirection.ltr,
        child: AcmeScope(
          theme: theme,
          overrides: overrides ?? const AcmeThemeOverrides(),
          child: probe(),
        ),
      );

  testWidgets('the explicit Carbon theme updates an existing subtree', (
    tester,
  ) async {
    await tester.pumpWidget(host(theme: AcmeTheme.white));
    expect(active, AcmeTheme.white);
    expect(background, const Color(0xFFFFFFFF));

    await tester.pumpWidget(host(theme: AcmeTheme.g100));
    expect(active, AcmeTheme.g100);
    expect(background, const Color(0xFF161616));
  });

  testWidgets('typed overrides replace tokens without mutating the theme', (
    tester,
  ) async {
    const replacement = Color(0xFF123456);
    await tester.pumpWidget(
      host(
        theme: AcmeTheme.g10,
        overrides: AcmeThemeOverrides(
          colors: {AcmeTokens.background: replacement},
        ),
      ),
    );

    expect(active, AcmeTheme.g10);
    expect(background, replacement);
    expect(
      buildAcmeTokenMap(AcmeTheme.g10)[AcmeTokens.background],
      const Color(0xFFF4F4F4),
    );
  });
}
