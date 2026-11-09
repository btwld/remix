import 'package:flutter/rendering.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registry_source/vanilla.dart';
import 'package:remix/remix.dart';
import 'package:remix_ui_icons/remix_ui_icons.dart';

import 'calendar_recipes_test.dart' show calendarHost;
import 'support.dart';

void main() {
  for (final theme in vanillaThemes) {
    for (final range in [false, true]) {
      testWidgets(
        '${theme.name} $range trigger icon follows muted text at 200 percent',
        (t) async {
          await t.pumpWidget(
            calendarHost(
              range
                  ? VanillaDateRangePicker(
                      value: null,
                      firstDate: DateTime(2026),
                      lastDate: DateTime(2028),
                      onChanged: (_) {},
                    )
                  : VanillaDatePicker(
                      value: null,
                      firstDate: DateTime(2026),
                      lastDate: DateTime(2028),
                      onChanged: (_) {},
                    ),
              theme.data,
              scale: 2,
            ),
          );
          final spec = t
              .widget<StyleSpecProvider<ButtonSpec>>(
                find.byType(StyleSpecProvider<ButtonSpec>).first,
              )
              .spec
              .spec;
          expect(spec.icon.spec.color, theme.data.mutedForeground);
          expect(spec.icon.spec.size, VanillaTokens.icon * 2);
          final mouse = await t.createGesture(kind: PointerDeviceKind.mouse);
          await mouse.addPointer();
          await mouse.moveTo(t.getCenter(find.byType(RemixButton)));
          await t.pumpAndSettle();
          for (final pressed in [false, true]) {
            if (pressed) {
              await mouse.down(t.getCenter(find.byType(RemixButton)));
              await t.pumpAndSettle();
            }
            final active = t
                .widget<StyleSpecProvider<ButtonSpec>>(
                  find.byType(StyleSpecProvider<ButtonSpec>).first,
                )
                .spec
                .spec;
            expect(active.icon.spec.color, theme.data.mutedForeground);
          }
          await mouse.cancel();
          await mouse.removePointer();
        },
      );
    }

    for (final range in [false, true]) {
      testWidgets(
        '${theme.name} ${range ? "range" : "single"} picker is a field and tracks its anchor',
        (t) async {
          final child = range
              ? VanillaDateRangePicker(
                  value: null,
                  buttonStyle: ButtonStyler().width(440),
                  firstDate: DateTime(2026),
                  lastDate: DateTime(2028),
                  currentDate: DateTime(2026, 11, 6),
                  onChanged: (_) {},
                )
              : VanillaDatePicker(
                  value: null,
                  buttonStyle: ButtonStyler().width(440),
                  firstDate: DateTime(2026),
                  lastDate: DateTime(2028),
                  currentDate: DateTime(2026, 11, 6),
                  onChanged: (_) {},
                );
          await t.pumpWidget(
            calendarHost(SizedBox(width: 440, child: child), theme.data),
          );
          ButtonSpec spec() => t
              .widget<StyleSpecProvider<ButtonSpec>>(
                find.byType(StyleSpecProvider<ButtonSpec>).first,
              )
              .spec
              .spec;
          expect(spec().label.spec.style?.color, theme.data.mutedForeground);
          expect(spec().label.spec.style?.fontWeight, FontWeight.w400);
          expect(
            spec().container.spec.flex?.spec.mainAxisAlignment,
            MainAxisAlignment.start,
          );
          expect(
            spec().container.spec.box?.spec.constraints?.minWidth,
            greaterThanOrEqualTo(240),
          );
          expect(
            t.widget<RemixButton>(find.byType(RemixButton)).leadingIcon,
            RemixIcons.calendar,
          );
          await t.tap(find.byType(RemixButton));
          await t.pumpAndSettle();
          final border =
              (spec().container.spec.box!.spec.decoration as BoxDecoration)
                  .border!;
          expect(border.top.color, theme.data.ring);
          final panel = t
              .widget<StyleSpecProvider<PopoverSpec>>(
                find.byType(StyleSpecProvider<PopoverSpec>).first,
              )
              .spec
              .spec;
          final panelBox = find.byWidgetPredicate(
            (w) => w is Box && w.styleSpec?.spec == panel.container.spec,
          );
          expect(
            t.getSize(panelBox).width,
            greaterThanOrEqualTo(
              t.getSize(find.byType(RemixButton).first).width,
            ),
          );
          expect(t.takeException(), isNull);
        },
      );
    }
    testWidgets(
      '${theme.name} natural long range stays within its panel width',
      (t) async {
        await t.pumpWidget(
          calendarHost(
            VanillaDateRangePicker(
              value: CivilDateRange(
                start: DateTime(2026, 11, 10),
                end: DateTime(2027, 3, 24),
              ),
              firstDate: DateTime(2026),
              lastDate: DateTime(2028),
              onChanged: (_) {},
            ),
            theme.data,
          ),
        );
        final anchor = t.getSize(find.byType(RemixButton)).width;
        await t.tap(find.byType(RemixButton));
        await t.pumpAndSettle();
        final panel = t
            .widget<StyleSpecProvider<PopoverSpec>>(
              find.byType(StyleSpecProvider<PopoverSpec>).first,
            )
            .spec
            .spec;
        final panelBox = find.byWidgetPredicate(
          (w) => w is Box && w.styleSpec?.spec == panel.container.spec,
        );
        expect(t.getSize(panelBox).width, greaterThanOrEqualTo(anchor));
        expect(t.takeException(), isNull);
      },
    );
    testWidgets('${theme.name} long range keeps both ends at 240px', (t) async {
      await t.pumpWidget(
        calendarHost(
          SizedBox(
            width: 240,
            child: VanillaDateRangePicker(
              value: CivilDateRange(
                start: DateTime(2026, 11, 10),
                end: DateTime(2027, 3, 24),
              ),
              firstDate: DateTime(2026),
              lastDate: DateTime(2028),
              onChanged: (_) {},
            ),
          ),
          theme.data,
        ),
      );
      final label = t.renderObject<RenderParagraph>(
        find
            .descendant(
              of: find.byType(RemixButton),
              matching: find.byType(RichText),
            )
            .last,
      );
      expect(label.maxLines, greaterThanOrEqualTo(1));

      expect(label.didExceedMaxLines, isFalse);
      expect(t.getSize(find.byType(RemixButton)).width, 240);
      expect(t.takeException(), isNull);
    });
  }
}
