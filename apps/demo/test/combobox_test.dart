import 'package:demo/components/combobox.dart';
import 'package:demo/ui/ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:widgetbook/widgetbook.dart';

void main() {
  testWidgets('editing an accepted destination clears the selection status', (
    tester,
  ) async {
    final state = WidgetbookState(
      root: WidgetbookRoot(children: const []),
      queryParams: {},
    );
    addTearDown(state.dispose);
    await tester.pumpWidget(
      WidgetbookScope(
        state: state,
        child: const MaterialApp(
          home: FortalTheme(child: Builder(builder: buildComboboxUseCase)),
        ),
      ),
    );
    await tester.enterText(find.byType(EditableText), 'san');
    await tester.pumpAndSettle();
    const city = 'San Sebastián, Basque Country · Spain';
    await tester.tap(find.text(city));
    await tester.pumpAndSettle();
    expect(find.text('Selected: $city'), findsOneWidget);
    await tester.enterText(find.byType(EditableText), 'zzzz');
    await tester.pumpAndSettle();
    expect(find.text('Selected: $city'), findsNothing);
    expect(find.text('Choose a suggested destination.'), findsOneWidget);
  });
}
