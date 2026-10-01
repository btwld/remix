import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:playground/main.dart' as playground;
import 'package:playground/ui/ui.dart';
import 'package:remix_ui_icons/remix_ui_icons.dart';

/// Covers the one edit this app makes to its installed `icons` item.
///
/// `tool/check_open_code_dogfood.dart` declares `apps/playground/icons` as
/// customized and fails if the file matches the template again, but it cannot
/// see *which* edit is there. These tests pin the alias and its one use.
void main() {
  test('the app-owned back alias resolves to the left arrow', () {
    expect(PlaygroundIcons.back, RemixIcons.arrowLeft);
  });

  testWidgets('the component page Back button shows the back alias', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(2400, 1600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    playground.main();
    await tester.pump();

    // The index page has no Back button, so the alias is not on screen yet.
    expect(find.text('Back'), findsNothing);

    await tester.tap(find.text('avatar'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 350));

    expect(find.text('Back'), findsOneWidget);
    expect(
      find.byWidgetPredicate(
        (widget) => widget is Icon && widget.icon == PlaygroundIcons.back,
      ),
      findsOneWidget,
    );
    await tester.pumpWidget(const SizedBox.shrink());
  });
}
