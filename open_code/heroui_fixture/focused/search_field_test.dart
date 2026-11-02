import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:open_code_fixture/main.dart';
import 'package:remix_ui_icons/remix_ui_icons.dart';

void main() {
  testWidgets('installed search field shows its label and clears its text', (
    tester,
  ) async {
    String text() =>
        tester.widget<EditableText>(find.byType(EditableText)).controller.text;

    await tester.pumpWidget(const AcmeSearchApp());
    expect(find.text('Search projects'), findsOneWidget);
    expect(find.byIcon(RemixIcons.search), findsOneWidget);
    expect(find.byIcon(RemixIcons.close), findsNothing);

    await tester.enterText(find.byType(EditableText), 'Remix');
    await tester.pump();
    expect(text(), 'Remix');

    await tester.tap(find.byIcon(RemixIcons.close));
    await tester.pump();
    expect(text(), isEmpty);
    expect(find.byIcon(RemixIcons.close), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
