import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registry_source/src/heroui/icons.dart';
import 'package:remix_ui_icons/remix_ui_icons.dart';

void main() {
  testWidgets('HeroUiIcons are rendering-compatible RemixIcons aliases', (
    tester,
  ) async {
    expect(identical(HeroUiIcons.check, RemixIcons.check), isTrue);
    expect(identical(HeroUiIcons.hamburgerMenu, RemixIcons.menu), isTrue);
    expect(HeroUiIcons.dashboard.fontFamily, 'RemixIcons');
    expect(HeroUiIcons.dashboard.fontPackage, 'remix_ui_icons');

    await tester.pumpWidget(
      const Directionality(
        textDirection: TextDirection.ltr,
        child: Icon(HeroUiIcons.dashboard),
      ),
    );

    expect(find.byIcon(RemixIcons.dashboard), findsOneWidget);
  });
}
