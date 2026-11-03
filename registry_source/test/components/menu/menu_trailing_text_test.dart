import 'package:flutter/gestures.dart' show PointerDeviceKind;
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registry_source/fortal.dart';
import 'package:registry_source/heroui.dart';
import 'package:registry_source/vanilla.dart';
import 'package:remix/remix.dart';

import '../../helpers/heroui.dart';

/// A shortcut or count reads as a marker beside the label, so each preset
/// paints it like the row's trailing icon, at rest and highlighted.
void main() {
  RemixMenu<String> menu(MenuStyler style) => RemixMenu<String>(
    style: style,
    trigger: const RemixMenuTrigger(label: 'Actions'),
    items: const [
      RemixMenuItem(value: 'refresh', label: 'Refresh', trailingText: '⌘R'),
    ],
  );

  Widget app(Widget child) => WidgetsApp(
    color: const Color(0xFFFFFFFF),
    pageRouteBuilder: <T>(settings, builder) => PageRouteBuilder<T>(
      settings: settings,
      pageBuilder: (context, _, _) => builder(context),
    ),
    home: Center(child: child),
  );

  Future<MenuItemSpec> openRow(WidgetTester tester) async {
    await tester.tap(find.text('Actions'));
    await tester.pumpAndSettle();
    return tester.resolvedSpecOf<MenuItemSpec>(find.text('Refresh'));
  }

  Future<MenuItemSpec> hoverRow(WidgetTester tester) async {
    final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await mouse.addPointer(location: tester.getCenter(find.text('Refresh')));
    addTearDown(mouse.removePointer);
    await tester.pumpAndSettle();
    return tester.resolvedSpecOf<MenuItemSpec>(find.text('Refresh'));
  }

  void expectLikeTrailingIcon(MenuItemSpec spec, String state) {
    expect(spec.trailingIcon.spec.color, isNotNull, reason: state);
    expect(
      spec.trailingText.spec.style?.color,
      spec.trailingIcon.spec.color,
      reason: state,
    );
  }

  testWidgets('Vanilla shortcuts are small and muted', (tester) async {
    await tester.pumpWidget(VanillaTheme(child: app(menu(vanillaMenuStyle()))));

    final rest = await openRow(tester);
    expectLikeTrailingIcon(rest, 'at rest');
    expect(
      rest.trailingText.spec.style?.fontSize,
      lessThan(rest.label.spec.style!.fontSize!),
    );
    expectLikeTrailingIcon(await hoverRow(tester), 'hovered');
  });

  for (final variant in FortalMenuVariant.values) {
    testWidgets('Fortal ${variant.name} shortcuts follow the trailing icon', (
      tester,
    ) async {
      await tester.pumpWidget(
        FortalTheme(
          mode: .light,
          child: app(menu(fortalMenuStyle(variant: variant))),
        ),
      );

      expectLikeTrailingIcon(await openRow(tester), 'at rest');
      expectLikeTrailingIcon(await hoverRow(tester), 'hovered');
    });
  }

  testWidgets('HeroUI shortcuts are small and muted', (tester) async {
    await tester.pumpHeroUi(menu(heroUiDropdownStyle()));

    final rest = await openRow(tester);
    expectLikeTrailingIcon(rest, 'at rest');
    expect(
      rest.trailingText.spec.style?.fontSize,
      lessThan(rest.label.spec.style!.fontSize!),
    );
    expectLikeTrailingIcon(await hoverRow(tester), 'hovered');
  });
}
