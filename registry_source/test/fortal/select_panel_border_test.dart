import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registry_source/fortal.dart';

void main() {
  for (final mode in [FortalThemeMode.light, FortalThemeMode.dark]) {
    testWidgets('Select panel is bounded and token bordered in ${mode.name}', (
      tester,
    ) async {
      await tester.pumpWidget(
        FortalTheme(
          mode: mode,
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Builder(
              builder: (context) {
                final panel = fortalSelectStyle()
                    .build(context)
                    .spec
                    .content
                    .spec;
                expect(panel.container.spec.constraints?.maxHeight, 320);
                final decoration =
                    panel.container.spec.decoration as BoxDecoration;
                expect(
                  decoration.border,
                  Border.all(color: FortalTokens.gray7.resolve(context)),
                );
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      );
    });
  }
}
