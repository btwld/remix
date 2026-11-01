import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/remix.dart';

import '../../helpers/test_helpers.dart';

void main() {
  const label = 'Save notification preferences and account delivery settings';
  for (final direction in TextDirection.values) {
    for (final customBuilder in [false, true]) {
      testWidgets('a bounded label preserves icons and loading geometry '
          '$direction customBuilder=$customBuilder', (tester) async {
        var loading = false;
        var pressed = false;
        late StateSetter update;
        await tester.pumpRemixApp(
          Directionality(
            textDirection: direction,
            child: StatefulBuilder(
              builder: (context, setState) {
                update = setState;
                return RemixButton(
                  label: label,
                  leadingIcon: const IconData(0xe000),
                  trailingIcon: const IconData(0xe001),
                  loading: loading,
                  onPressed: () => pressed = true,
                  textBuilder: customBuilder
                      ? (context, spec, text) =>
                            StyledText(text, styleSpec: StyleSpec(spec: spec))
                      : null,
                  style: ButtonStyler()
                      .width(240)
                      .height(40)
                      .spacing(8)
                      .icon(.size(16))
                      .label(
                        .fontSize(14)
                            .maxLines(1)
                            .softWrap(false)
                            .overflow(TextOverflow.ellipsis),
                      ),
                );
              },
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        final before = tester.getRect(find.byType(RemixButton));
        final paragraph = tester.renderObject<RenderParagraph>(
          find.text(label),
        );
        expect(paragraph.didExceedMaxLines, isTrue);
        for (final icon in find.byType(Icon).evaluate()) {
          final rect = tester.getRect(find.byWidget(icon.widget));
          expect(rect.width, 16);
          expect(rect.left, greaterThanOrEqualTo(before.left));
          expect(rect.right, lessThanOrEqualTo(before.right));
        }
        update(() => loading = true);
        await tester.pump(const Duration(milliseconds: 100));
        expect(tester.takeException(), isNull);
        expect(tester.getRect(find.byType(RemixButton)), before);
        await tester.tap(find.byType(RemixButton));
        expect(pressed, isFalse);
        update(() => loading = false);
        await tester.pumpAndSettle();
        expect(tester.getRect(find.byType(RemixButton)), before);
        await tester.tap(find.byType(RemixButton));
        expect(pressed, isTrue);
      });
    }
  }
}
