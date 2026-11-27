import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show LogicalKeyboardKey;
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/remix.dart';

import '../../helpers/test_helpers.dart';

const _closed = Color(0xFF000001);
const _open = Color(0xFF0000FF);

Widget _fade(
  BuildContext context,
  RemixPanelTransitionInfo info,
  Widget panel,
) => FadeTransition(opacity: info.animation, child: panel);

RemixMenu<String> _menu({
  MenuController? controller,
  RemixPanelTransition? transition,
  RemixMenuTrigger trigger = const RemixMenuTrigger(label: 'Options'),
}) {
  var style = MenuStyler().trigger(
    MenuTriggerStyler()
        .label(TextStyler().color(_closed))
        .onSelected(MenuTriggerStyler().label(TextStyler().color(_open))),
  );
  if (transition != null) style = style.panelTransition(transition);
  return RemixMenu<String>(
    controller: controller,
    trigger: trigger,
    items: const [RemixMenuItem(value: 'copy', label: 'Copy')],
    style: style,
  );
}

Color? _labelColor(WidgetTester tester) =>
    tester.widget<Text>(find.text('Options')).style?.color;

void main() {
  testWidgets('the trigger resolves as selected while the menu is open', (
    tester,
  ) async {
    await tester.pumpRemixApp(_menu());
    expect(_labelColor(tester), _closed);

    await tester.tap(find.text('Options'));
    await tester.pumpAndSettle();
    expect(find.text('Copy'), findsOneWidget);
    expect(_labelColor(tester), _open);

    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pumpAndSettle();
    expect(find.text('Copy'), findsNothing);
    expect(_labelColor(tester), _closed);
  });

  testWidgets('the open state ends when the exit transition starts', (
    tester,
  ) async {
    final controller = MenuController();
    await tester.pumpRemixApp(
      _menu(
        controller: controller,
        transition: const RemixPanelTransition(
          duration: Duration(milliseconds: 200),
          builder: _fade,
        ),
      ),
    );

    controller.open();
    await tester.pumpAndSettle();
    expect(_labelColor(tester), _open);

    controller.close();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
    expect(find.text('Copy'), findsOneWidget, reason: 'the exit is playing');
    expect(_labelColor(tester), _closed);
  });

  testWidgets('a builder trigger receives the open state too', (tester) async {
    await tester.pumpRemixApp(
      _menu(
        trigger: RemixMenuTrigger.builder(
          label: 'Options',
          builder: (context, state, child) => child!,
        ),
      ),
    );

    await tester.tap(find.text('Options'));
    await tester.pumpAndSettle();
    expect(_labelColor(tester), _open);
  });
}
