import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registry_source/vanilla.dart';
import 'package:remix/remix.dart';

import '../../vanilla/support.dart';

void main() {
  // Browsers treat a focused text input as `:focus-visible` even after a
  // click, so shadcn's input rings on click.
  testWidgets(
    'a mouse click into a Vanilla text field shows the focus ring',
    (tester) async {
      await tester.pumpWidget(
        VanillaTheme(
          theme: const VanillaThemeData.light(),
          // EditableText needs an Overlay, which the minimal host lacks.
          child: hostOf(
            Overlay(
              initialEntries: [
                OverlayEntry(
                  builder: (_) => Center(
                    child: SizedBox(
                      width: 240,
                      child: RemixTextField(style: vanillaTextFieldStyle()),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
      double ringWidth() =>
          tester
              .widget<StyleSpecProvider<TextFieldSpec>>(
                find.byType(StyleSpecProvider<TextFieldSpec>).first,
              )
              .spec
              .spec
              .containerEffects
              ?.outline
              .width ??
          0;
      expect(ringWidth(), 0);

      await tester.tap(
        find.byType(EditableText),
        kind: PointerDeviceKind.mouse,
      );
      await tester.pumpAndSettle();
      expect(ringWidth(), greaterThan(0));
    },
    variant: const TargetPlatformVariant({TargetPlatform.macOS}),
  );
}
