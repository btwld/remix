import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registry_source/fortal.dart';
import 'package:remix/remix.dart';

void main() {
  Widget host(ValueNotifier<String?> value) => FortalTheme(
    child: WidgetsApp(
      color: const Color(0xFFFFFFFF),
      builder: (context, _) => Overlay(
        initialEntries: [
          OverlayEntry(
            builder: (context) => Align(
              alignment: Alignment.topCenter,
              child: SizedBox(
                width: 240,
                child: ValueListenableBuilder(
                  valueListenable: value,
                  builder: (context, selected, _) => FortalSelect<String>(
                    trigger: const RemixSelectTrigger(placeholder: 'Choose'),
                    items: const [
                      RemixSelectItem(value: 'a', label: 'Apple'),
                      RemixSelectItem(value: 'b', label: 'Banana'),
                    ],
                    selectedValue: selected,
                    onChanged: (next) => value.value = next,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );

  double opacityAbove(WidgetTester tester, Finder finder) => tester
      .widgetList<Opacity>(
        find.ancestor(of: finder, matching: find.byType(Opacity)),
      )
      .fold(1.0, (product, widget) => product * widget.opacity);

  testWidgets('the panel opens over 200ms and closes in 100ms', (tester) async {
    final value = ValueNotifier<String?>(null);
    await tester.pumpWidget(host(value));
    await tester.tap(find.text('Choose'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 20));
    final early = opacityAbove(tester, find.text('Banana'));
    expect(early, greaterThan(0));
    expect(early, lessThan(1));
    await tester.pump(const Duration(milliseconds: 200));
    expect(opacityAbove(tester, find.text('Banana')), 1);

    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 60));
    expect(find.text('Banana'), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 60));
    expect(find.text('Banana'), findsNothing);
  });

  testWidgets('a new value rolls in while the old one leaves', (tester) async {
    final value = ValueNotifier<String?>('a');
    await tester.pumpWidget(host(value));
    value.value = 'b';
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 80));
    expect(find.text('Apple'), findsOneWidget);
    final arriving = opacityAbove(tester, find.text('Banana'));
    expect(arriving, greaterThan(0));
    expect(arriving, lessThan(1));
    await tester.pumpAndSettle();
    expect(find.text('Apple'), findsNothing);
    expect(opacityAbove(tester, find.text('Banana')), 1);
  });

  testWidgets('items take the muted fill under the pointer', (tester) async {
    late SelectMenuItemSpec hovered;
    late Color gray3;
    await tester.pumpWidget(
      FortalTheme(
        child: WidgetStateProvider(
          states: const {WidgetState.hovered},
          child: Builder(
            builder: (context) {
              hovered = fortalSelectMenuItemStyle().build(context).spec;
              gray3 = FortalTokens.gray3.resolve(context);
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
    final box = hovered.container.spec.box!.spec;
    expect((box.decoration! as BoxDecoration).color, gray3);
    expect(box.constraints!.minHeight, 36);
  });
}
