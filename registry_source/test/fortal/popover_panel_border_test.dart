import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registry_source/fortal.dart';

void main() {
  for (final mode in [FortalThemeMode.light, FortalThemeMode.dark]) {
    testWidgets('Popover has its token border in ${mode.name}', (tester) async {
      await tester.pumpWidget(
        FortalTheme(
          mode: mode,
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Builder(
              builder: (context) {
                final panel = fortalPopoverStyle().build(context).spec;
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
