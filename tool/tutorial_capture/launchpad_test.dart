import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import '../lib/main.dart';
import 'capture.dart';

const scene = String.fromEnvironment('TUTORIAL_SCENE');

void main() {
  setUpAll(loadManifestFonts);

  testWidgets('captures the Launchpad $scene scene', (tester) async {
    await pumpScene(tester, const SampleApp());
    switch (scene) {
      case 'launchpad':
        break;
      case 'saved':
        await tester.enterText(find.byType(EditableText), 'Launchpad Studio');
        await tester.tap(find.text('Send a weekly summary'));
        await tester.tap(find.text('Save changes'));
        await tester.pump(const Duration(milliseconds: 1600));
        await tester.pumpAndSettle();
        expect(
          find.textContaining('Save count: 1. Summary: off.'),
          findsOneWidget,
        );
      case 'dark':
        await tester.tap(find.text('Use dark theme'));
        await tester.pumpAndSettle();
        expect(find.text('Use light theme'), findsOneWidget);
      default:
        fail('Unknown TUTORIAL_SCENE "$scene"');
    }
    await writeCapture(tester);
  });
}
