import 'package:flutter_test/flutter_test.dart';

import '../lib/main.dart';
import 'capture.dart';

void main() {
  setUpAll(loadManifestFonts);

  testWidgets('captures the first-render AcmeApp', (tester) async {
    await pumpScene(tester, const AcmeApp());
    expect(find.text('Continue'), findsOneWidget);
    await writeCapture(tester);
  });
}
