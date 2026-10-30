import 'package:flutter_test/flutter_test.dart';

import '../lib/main.dart';

void main() {
  testWidgets('official and additive registry adapters compose', (
    tester,
  ) async {
    await tester.pumpWidget(const OwnershipApp());
    expect(find.text('Official'), findsOneWidget);
    expect(find.text('Add-on'), findsOneWidget);
    await tester.tap(find.text('Add-on'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
}
