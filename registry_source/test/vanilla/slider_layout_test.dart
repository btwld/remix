import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registry_source/vanilla.dart';
import 'package:remix/remix.dart';

import 'support.dart';

void main() {
  for (final theme in vanillaThemes) {
    testWidgets(
      '${theme.name}: both recipes expose a 48px interaction height',
      (tester) async {
        final changes = <double>[];
        await tester.pumpWidget(
          VanillaTheme(
            theme: theme.data,
            child: hostOf(
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 240,
                      child: VanillaSlider(value: 0.5, onChanged: changes.add),
                    ),
                    SizedBox(
                      width: 240,
                      child: VanillaRangeSlider(
                        values: const [0.25, 0.75],
                        onChanged: (_) {},
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
        final single = tester.getRect(find.byType(RemixSlider));
        expect(single.height, 48);
        expect(tester.getSize(find.byType(RemixRangeSlider)).height, 48);
        await tester.tapAt(single.topRight + const Offset(-1, 1));
        await tester.pumpAndSettle();
        expect(changes, [1]);
      },
    );
  }
}
