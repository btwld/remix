import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import '../lib/main.dart';

void main() {
  testWidgets('the installed icon alias renders', (tester) async {
    await tester.pumpWidget(const AcmeIconsApp());
    expect(find.byType(Icon), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
