import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/remix.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_vanilla/components/calendar_labels.dart';
import 'package:widgetbook_vanilla/components/checkbox.dart';
import 'package:widgetbook_vanilla/components/select.dart';
import 'package:widgetbook_vanilla/components/switch.dart';
import 'package:widgetbook_vanilla/components/toggle.dart';
import 'package:widgetbook_vanilla/main.directories.g.dart';
import 'package:widgetbook_vanilla/ui/ui.dart';

void main() {
  test(
    'calendar scenes localize Arabic dates and collapse a one-day range',
    () {
      final day = DateTime(2026, 11, 24);
      expect(formatCalendarSceneDate(day, rtl: true), '٢٤ نوفمبر ٢٠٢٦');
      expect(
        formatCalendarSceneRange(CivilDateRange(start: day, end: day)),
        formatCalendarSceneDate(day),
      );
      final range = formatCalendarSceneRange(
        CivilDateRange(
          start: DateTime(2026, 11, 10),
          end: DateTime(2026, 11, 13),
        ),
        rtl: true,
      );
      expect(range, '١٠ نوفمبر ٢٠٢٦ – ١٣ نوفمبر ٢٠٢٦');
      expect(RegExp('[0-9/]').hasMatch(range), isFalse);
    },
  );

  final useCases = _collectUseCases(directories);

  test('catalog registers all 48 Vanilla component use cases', () {
    expect(useCases, hasLength(48));
  });

  for (final entry in useCases) {
    testWidgets('${entry.componentName} / ${entry.useCase.name} renders', (
      tester,
    ) async {
      await _pumpUseCase(tester, entry.useCase.builder);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('interactive use cases persist state across taps', (
    tester,
  ) async {
    await _pumpUseCase(tester, buildVanillaCheckboxUseCase);
    expect(
      tester.widget<RemixCheckbox>(find.byType(RemixCheckbox)).selected,
      isTrue,
    );
    await tester.tap(find.byType(RemixCheckbox));
    await tester.pumpAndSettle();
    expect(
      tester.widget<RemixCheckbox>(find.byType(RemixCheckbox)).selected,
      isFalse,
    );

    await _pumpUseCase(tester, buildVanillaSwitchUseCase);
    expect(
      tester.widget<RemixSwitch>(find.byType(RemixSwitch)).selected,
      isTrue,
    );
    await tester.tap(find.byType(RemixSwitch));
    await tester.pumpAndSettle();
    expect(
      tester.widget<RemixSwitch>(find.byType(RemixSwitch)).selected,
      isFalse,
    );

    await _pumpUseCase(tester, buildVanillaToggleUseCase);
    expect(
      tester.widget<RemixToggle>(find.byType(RemixToggle)).selected,
      isFalse,
    );
    await tester.tap(find.byType(RemixToggle));
    await tester.pumpAndSettle();
    expect(
      tester.widget<RemixToggle>(find.byType(RemixToggle)).selected,
      isTrue,
    );

    await _pumpUseCase(tester, buildVanillaSelectUseCase);
    expect(find.text('Fruit'), findsOneWidget);
    await tester.tap(find.byType(RemixSelect<String>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Apple').last);
    await tester.pumpAndSettle();
    expect(find.text('Apple'), findsOneWidget);
  });
}

Future<void> _pumpUseCase(WidgetTester tester, WidgetBuilder builder) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = const Size(1024, 768);
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  await tester.pumpWidget(
    WidgetsApp(
      color: const Color(0xFFFFFFFF),
      pageRouteBuilder: <T>(settings, pageBuilder) => PageRouteBuilder<T>(
        settings: settings,
        pageBuilder: (context, _, _) => pageBuilder(context),
      ),
      home: VanillaTheme(child: Builder(builder: builder)),
    ),
  );
  await tester.pump();
}

List<({String componentName, WidgetbookUseCase useCase})> _collectUseCases(
  List<WidgetbookNode> nodes,
) {
  final out = <({String componentName, WidgetbookUseCase useCase})>[];
  void walk(WidgetbookNode node, String parentName) {
    if (node is WidgetbookUseCase) {
      out.add((componentName: parentName, useCase: node));
      return;
    }
    final children = node.children;
    if (children == null) return;
    for (final child in children) {
      walk(child, node.name);
    }
  }

  for (final node in nodes) {
    walk(node, node.name);
  }
  return out;
}
