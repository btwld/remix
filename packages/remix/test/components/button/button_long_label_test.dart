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

  for (final direction in TextDirection.values) {
    for (final customBuilder in [false, true]) {
      testWidgets(
        'a max-axis button shrink-wraps an unbounded horizontal parent '
        '$direction customBuilder=$customBuilder',
        (tester) async {
          var loading = false;
          var presses = 0;
          late StateSetter update;
          await tester.pumpRemixApp(
            Directionality(
              textDirection: direction,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: StatefulBuilder(
                  builder: (context, setState) {
                    update = setState;
                    return RemixButton(
                      label: 'Save',
                      leadingIcon: const IconData(0xe000),
                      trailingIcon: const IconData(0xe001),
                      loading: loading,
                      onPressed: () => presses++,
                      textBuilder: customBuilder
                          ? (_, spec, text) => StyledText(
                              text,
                              styleSpec: StyleSpec(spec: spec),
                            )
                          : null,
                      style: ButtonStyler()
                          .mainAxisSize(.max)
                          .height(40)
                          .spacing(8)
                          .icon(.size(16))
                          .label(.fontSize(14)),
                    );
                  },
                ),
              ),
            ),
          );
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull);
          final button = find.byType(RemixButton);
          final before = tester.getRect(button);
          final text = tester.getRect(find.text('Save'));
          expect(before.width, closeTo(text.width + 48, 0.001));
          expect(before.height, 40);
          final icons = find.byType(Icon).evaluate().toList();
          final leading = tester.getRect(find.byWidget(icons[0].widget));
          final trailing = tester.getRect(find.byWidget(icons[1].widget));
          if (direction == TextDirection.ltr) {
            expect(leading.right, closeTo(text.left - 8, 0.001));
            expect(trailing.left, closeTo(text.right + 8, 0.001));
          } else {
            expect(leading.left, closeTo(text.right + 8, 0.001));
            expect(trailing.right, closeTo(text.left - 8, 0.001));
          }
          update(() => loading = true);
          await tester.pump(const Duration(milliseconds: 100));
          expect(tester.takeException(), isNull);
          expect(tester.getRect(button), before);
          await tester.tap(button);
          expect(presses, 0);
          update(() => loading = false);
          await tester.pumpAndSettle();
          expect(tester.getRect(button), before);
          await tester.tap(button);
          expect(presses, 1);
        },
      );
    }
  }

  testWidgets(
    'a max-axis button fills a bounded parent and constrains its label',
    (tester) async {
      await tester.pumpRemixApp(
        SizedBox(
          width: 240,
          child: RemixButton(
            label: label,
            leadingIcon: const IconData(0xe000),
            onPressed: () {},
            style: ButtonStyler()
                .mainAxisSize(.max)
                .iconAlignment(.end)
                .spacing(8)
                .icon(.size(16))
                .label(
                  .maxLines(1).softWrap(false).overflow(TextOverflow.ellipsis),
                ),
          ),
        ),
      );
      expect(tester.takeException(), isNull);
      final button = tester.getRect(find.byType(RemixButton));
      final text = tester.getRect(find.text(label));
      final icon = tester.getRect(find.byType(Icon));
      expect(button.width, 240);
      expect(
        tester
            .renderObject<RenderParagraph>(find.text(label))
            .didExceedMaxLines,
        isTrue,
      );
      expect(text.right, lessThanOrEqualTo(icon.left));
      expect(icon.right, lessThanOrEqualTo(button.right));
    },
  );

  for (final maxAxis in [false, true]) {
    for (final intrinsic in ['width', 'height', 'both']) {
      testWidgets(
        'button supports intrinsic $intrinsic with maxAxis=$maxAxis',
        (tester) async {
          var pressed = false;
          Widget button = RemixButton(
            label: 'Save',
            leadingIcon: const IconData(0xe000),
            onPressed: () => pressed = true,
            textBuilder: (_, spec, text) =>
                StyledText(text, styleSpec: StyleSpec(spec: spec)),
            style: ButtonStyler()
                .mainAxisSize(maxAxis ? .max : .min)
                .spacing(8)
                .icon(.size(16))
                .label(.fontSize(14)),
          );
          if (intrinsic != 'height') button = IntrinsicWidth(child: button);
          if (intrinsic != 'width') button = IntrinsicHeight(child: button);
          await tester.pumpRemixApp(button);
          expect(tester.takeException(), isNull);
          final rect = tester.getRect(find.byType(RemixButton));
          final text = tester.getRect(find.text('Save'));
          final icon = tester.getRect(find.byType(Icon));
          expect(rect.size.isFinite, isTrue);
          expect(rect.width, greaterThanOrEqualTo(text.width + 24));
          expect(rect.height, greaterThanOrEqualTo(icon.height));
          expect(text.left, closeTo(icon.right + 8, 0.001));
          await tester.tap(find.byType(RemixButton));
          expect(pressed, isTrue);
        },
      );
    }
  }

  testWidgets(
    'unbounded custom content does not require intrinsic measurement',
    (tester) async {
      await tester.pumpRemixApp(
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: RemixButton(
            label: 'Save',
            onPressed: () {},
            textBuilder: (_, _, _) => LayoutBuilder(
              builder: (_, constraints) {
                expect(constraints.hasBoundedWidth, isFalse);
                return const SizedBox(width: 48, height: 20);
              },
            ),
            style: ButtonStyler().mainAxisSize(.max),
          ),
        ),
      );
      expect(tester.takeException(), isNull);
      expect(tester.getSize(find.byType(RemixButton)), const Size(48, 20));
    },
  );

  testWidgets('the same button follows changing bounded and unbounded widths', (
    tester,
  ) async {
    var bounded = true;
    var maxAxis = true;
    late StateSetter update;
    await tester.pumpRemixApp(
      StatefulBuilder(
        builder: (_, setState) {
          update = setState;
          return SizedBox(
            width: 240,
            child: OverflowBox(
              minWidth: 0,
              maxWidth: bounded ? 240 : double.infinity,
              child: RemixButton(
                label: 'Save',
                onPressed: () {},
                style: ButtonStyler().mainAxisSize(maxAxis ? .max : .min),
              ),
            ),
          );
        },
      ),
    );
    expect(tester.takeException(), isNull);
    final button = find.byType(RemixButton);
    final element = tester.element(button);
    expect(tester.getSize(button).width, 240);
    update(() => bounded = false);
    await tester.pump();
    expect(tester.takeException(), isNull);
    final naturalWidth = tester.getSize(find.text('Save')).width;
    expect(tester.getSize(button).width, naturalWidth);
    update(() => bounded = true);
    await tester.pump();
    expect(tester.takeException(), isNull);
    expect(tester.getSize(button).width, 240);
    update(() => maxAxis = false);
    await tester.pump();
    expect(tester.getSize(button).width, naturalWidth);
    update(() => maxAxis = true);
    await tester.pump();
    expect(tester.getSize(button).width, 240);
    expect(tester.element(button), same(element));
  });

  testWidgets('unbounded max-axis dry layout agrees with real layout', (
    tester,
  ) async {
    await tester.pumpRemixApp(
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: RemixButton(
          label: 'Save',
          onPressed: () {},
          leadingIcon: const IconData(0xe000),
          style: ButtonStyler()
              .mainAxisSize(.max)
              .height(40)
              .spacing(8)
              .icon(.size(16)),
        ),
      ),
    );
    final flex = tester.renderObject<RenderFlex>(
      find.byWidgetPredicate((widget) => widget is Flex),
    );
    expect(flex.constraints.hasBoundedWidth, isFalse);
    expect(flex.mainAxisSize, MainAxisSize.max);
    expect(flex.size.width, greaterThan(0));
    expect(flex.getDryLayout(flex.constraints), flex.size);
    expect(tester.takeException(), isNull);
  });
}
