import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/remix.dart';

import 'combobox_test_host.dart';

void main() {
  const labelColor = Color(0xFF445566);

  Widget combobox({WidgetBuilder? emptyBuilder}) => RemixCombobox<String>(
    optionsBuilder: (query) => suggestions.where(
      (fruit) => fruit.toLowerCase().startsWith(query.text.toLowerCase()),
    ),
    emptyBuilder: emptyBuilder,
    style: testComboboxStyle().option(
      ComboboxOptionStyler().label(TextStyler().color(labelColor)),
    ),
  );

  testWidgets('emptyBuilder fills the panel while results are empty', (
    tester,
  ) async {
    await tester.pumpWidget(
      comboboxHost(combobox(emptyBuilder: (context) => const Text('No fruit'))),
    );
    await openCombobox(tester, 'ap');
    expect(find.text('Apple'), findsOneWidget);
    expect(find.text('No fruit'), findsNothing);

    await tester.enterText(find.byType(EditableText), 'zz');
    await tester.pumpAndSettle();
    expect(find.text('No fruit'), findsOneWidget);
    expect(find.text('Apple'), findsNothing);

    await tester.enterText(find.byType(EditableText), 'av');
    await tester.pumpAndSettle();
    expect(find.text('No fruit'), findsNothing);
    expect(find.text('Avocado'), findsOneWidget);
  });

  testWidgets('empty content inherits the suggestion label style', (
    tester,
  ) async {
    await tester.pumpWidget(
      comboboxHost(combobox(emptyBuilder: (context) => const Text('No fruit'))),
    );
    await openCombobox(tester, 'zz');

    final text = tester.widget<RichText>(
      find.descendant(
        of: find.text('No fruit'),
        matching: find.byType(RichText),
      ),
    );
    expect(text.text.style?.color, labelColor);
  });

  testWidgets('empty content is exposed to assistive technology', (
    tester,
  ) async {
    final handle = tester.ensureSemantics();
    await tester.pumpWidget(
      comboboxHost(combobox(emptyBuilder: (context) => const Text('No fruit'))),
    );
    await openCombobox(tester, 'zz');

    expect(find.bySemanticsLabel('No fruit'), findsOneWidget);
    expect(tester.takeException(), isNull);
    handle.dispose();
  });

  testWidgets('without emptyBuilder no results closes the panel', (
    tester,
  ) async {
    await tester.pumpWidget(comboboxHost(combobox()));
    await openCombobox(tester, 'ap');
    expect(find.text('Apple'), findsOneWidget);

    await tester.enterText(find.byType(EditableText), 'zz');
    await tester.pumpAndSettle();
    expect(find.byType(RemixCombobox<String>), findsOneWidget);
    expect(find.text('Apple'), findsNothing);
    expect(find.byType(SingleChildScrollView), findsNothing);
  });

  test('the styler call forwards emptyBuilder', () {
    final emptyBuilder = (BuildContext context) => const Text('No fruit');
    final widget = ComboboxStyler()<String>(
      optionsBuilder: (_) => suggestions,
      emptyBuilder: emptyBuilder,
    );
    expect(widget.emptyBuilder, same(emptyBuilder));
  });
}
