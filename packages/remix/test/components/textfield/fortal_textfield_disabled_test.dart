import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/remix.dart';

import '../../helpers/test_helpers.dart';

void main() {
  test('fortal textfield source has no Colors.red debug disabled styling', () {
    // Drive real factories
    final surface = fortalTextFieldStyler(variant: .surface);
    final soft = fortalTextFieldStyler(variant: .soft);
    expect(surface, isA<RemixTextFieldStyler>());
    expect(soft, isA<RemixTextFieldStyler>());

    // Shipped source regression: disabled soft must not use Colors.red
    final file = File(
      'lib/src/components/textfield/fortal_textfield_styles.dart',
    );
    final src = file.readAsStringSync();
    expect(src.contains('Colors.red'), isFalse);
    expect(
      src.contains('backgroundColor(FortalTokens.colorSurface())'),
      isTrue,
    );
    expect(src.contains('backgroundColor(FortalTokens.accentA3())'), isTrue);
    expect(src.contains('.onDisabled'), isTrue);
  });

  testWidgets('fortal textfield disabled soft renders under FortalScope', (
    tester,
  ) async {
    await tester.pumpRemixApp(
      FortalScope(
        child: FortalTextField(
          variant: .soft,
          enabled: false,
          controller: TextEditingController(text: 'disabled'),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(FortalTextField), findsOneWidget);
    expect(find.byType(RemixTextField), findsOneWidget);
  });
}
