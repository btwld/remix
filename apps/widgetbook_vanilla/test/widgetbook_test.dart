import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:widgetbook_vanilla/components/button.dart';
import 'package:widgetbook_vanilla/components/checkbox.dart';
import 'package:widgetbook_vanilla/ui/ui.dart';

void main() {
  testWidgets('button use case renders inside VanillaTheme', (tester) async {
    await tester.pumpWidget(
      WidgetsApp(
        color: const Color(0xFFFFFFFF),
        pageRouteBuilder: <T>(settings, builder) => PageRouteBuilder<T>(
          settings: settings,
          pageBuilder: (context, _, _) => builder(context),
        ),
        home: VanillaTheme(child: Builder(builder: buildVanillaButtonUseCase)),
      ),
    );

    expect(find.text('Button'), findsWidgets);
    expect(tester.takeException(), isNull);
  });

  testWidgets('checkbox use case renders inside VanillaTheme', (tester) async {
    await tester.pumpWidget(
      WidgetsApp(
        color: const Color(0xFFFFFFFF),
        pageRouteBuilder: <T>(settings, builder) => PageRouteBuilder<T>(
          settings: settings,
          pageBuilder: (context, _, _) => builder(context),
        ),
        home: VanillaTheme(
          child: Builder(builder: buildVanillaCheckboxUseCase),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
  });
}
