import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/remix.dart';

import 'combobox_test_host.dart';

void main() {
  const disabledColor = Color(0xFF999999);

  Widget combobox(List<String> selected) => RemixCombobox<String>(
    optionsBuilder: (_) => suggestions,
    isOptionDisabled: (fruit) => fruit == 'Apricot',
    onSelected: selected.add,
    style: testComboboxStyle().option(
      ComboboxOptionStyler().onDisabled(
        ComboboxOptionStyler().label(TextStyler().color(disabledColor)),
      ),
    ),
  );

  Color? labelColor(WidgetTester tester, String fruit) => tester
      .widget<RichText>(
        find.descendant(of: find.text(fruit), matching: find.byType(RichText)),
      )
      .text
      .style
      ?.color;

  testWidgets('a disabled suggestion stays visible in its disabled style', (
    tester,
  ) async {
    await tester.pumpWidget(comboboxHost(combobox([])));
    await openCombobox(tester);

    expect(find.text('Apple'), findsOneWidget);
    expect(find.text('Apricot'), findsOneWidget);
    expect(find.text('Avocado'), findsOneWidget);
    expect(labelColor(tester, 'Apricot'), disabledColor);
    expect(labelColor(tester, 'Avocado'), isNot(disabledColor));
  });

  testWidgets('keyboard navigation skips a disabled suggestion', (
    tester,
  ) async {
    final selected = <String>[];
    await tester.pumpWidget(comboboxHost(combobox(selected)));
    await openCombobox(tester);

    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();

    expect(selected, ['Avocado']);
    expect(
      tester.widget<EditableText>(find.byType(EditableText)).controller.text,
      'Avocado',
    );
  });

  testWidgets('a disabled suggestion ignores taps', (tester) async {
    final selected = <String>[];
    await tester.pumpWidget(comboboxHost(combobox(selected)));
    await openCombobox(tester);

    await tester.tap(find.text('Apricot'));
    await tester.pumpAndSettle();

    expect(selected, isEmpty);
    expect(find.text('Apricot'), findsOneWidget);
  });

  test('the styler call forwards isOptionDisabled', () {
    final isOptionDisabled = (String fruit) => fruit == 'Apricot';
    final widget = ComboboxStyler()<String>(
      optionsBuilder: (_) => suggestions,
      isOptionDisabled: isOptionDisabled,
    );
    expect(widget.isOptionDisabled, same(isOptionDisabled));
  });
}
