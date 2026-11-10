import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registry_source/vanilla.dart';
import 'package:remix/remix.dart';
// `RemixBoxAdapter` is `@internal` to `remix`, but the panel's width is the one
// thing to measure and no public widget is the panel. Suppressed at the use.
import 'package:remix/src/rendering/remix_box_effects.dart';
import 'package:remix_ui_icons/remix_ui_icons.dart';

import 'support.dart';

/// Laid-out sizes the spec states. The spec targets read style inputs, which
/// can agree with the spec while the rendered widget does not.
void main() {
  Widget host(Widget home) => WidgetsApp(
    color: const Color(0xFFFFFFFF),
    pageRouteBuilder: <T>(settings, builder) => PageRouteBuilder<T>(
      settings: settings,
      pageBuilder: (context, _, _) => builder(context),
    ),
    builder: (context, navigator) => VanillaTheme(child: navigator!),
    home: home,
  );

  Rect panelOf(WidgetTester tester, String text) => tester.getRect(
    find
        .ancestor(of: find.text(text), matching: find.byType(DecoratedBox))
        .first,
  );

  for (final range in [false, true]) {
    for (final dark in [false, true]) {
      testWidgets(
        '${range ? "range" : "single"} calendar selectors grow at 200% in RTL (${dark ? "dark" : "light"})',
        (tester) async {
          tester.view.physicalSize = const Size(900, 900);
          tester.view.devicePixelRatio = 1;
          addTearDown(tester.view.reset);
          Widget scene(double scale) => WidgetsApp(
            color: const Color(0xFFFFFFFF),
            builder: (context, _) => VanillaTheme(
              mode: dark ? .dark : .light,
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: MediaQuery(
                  data: MediaQuery.of(
                    context,
                  ).copyWith(textScaler: TextScaler.linear(scale)),
                  child: Overlay(
                    initialEntries: [
                      OverlayEntry(
                        builder: (_) => Center(
                          child: range
                              ? VanillaRangeCalendar(
                                  value: null,
                                  firstDate: DateTime(2026),
                                  lastDate: DateTime(2027),
                                  currentDate: DateTime(2026, 11, 6),
                                  onChanged: (_) {},
                                )
                              : VanillaCalendar(
                                  value: null,
                                  firstDate: DateTime(2026),
                                  lastDate: DateTime(2027),
                                  currentDate: DateTime(2026, 11, 6),
                                  onChanged: (_) {},
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
          await tester.pumpWidget(scene(1));
          final normal = [
            for (final selector in find.byType(RemixSelect<int>).evaluate())
              tester.getSize(find.byWidget(selector.widget)),
          ];
          await tester.pumpWidget(const SizedBox.shrink());
          await tester.pumpWidget(scene(2));
          final large = [
            for (final selector in find.byType(RemixSelect<int>).evaluate())
              tester.getSize(find.byWidget(selector.widget)),
          ];
          for (var i = 0; i < normal.length; i++) {
            expect(large[i].width, greaterThan(normal[i].width));
            expect(large[i].height, greaterThanOrEqualTo(normal[i].height));
          }
          // Ahem may wrap the long month at 100%; the numeric year always
          // starts on one line and proves intrinsic height growth.
          expect(large.last.height, greaterThan(normal.last.height));
          expect(tester.takeException(), isNull);
        },
      );
    }
  }

  for (final direction in TextDirection.values) {
    testWidgets(
      'range slider keeps both 16px thumbs and interval in $direction at 200% text',
      (tester) async {
        await tester.pumpWidget(
          host(
            MediaQuery(
              data: const MediaQueryData(textScaler: TextScaler.linear(2)),
              child: Directionality(
                textDirection: direction,
                child: Center(
                  child: SizedBox(
                    width: 240,
                    child: VanillaRangeSlider(
                      values: const [0.25, 0.75],
                      onChanged: (_) {},
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        final lower = tester.getRect(rangeThumb(0));
        final upper = tester.getRect(rangeThumb(1));
        expect(lower.size, const Size.square(16));
        expect(upper.size, lower.size);
        expect((upper.center.dx - lower.center.dx).abs(), 112);
        // The filled interval spans the centers of the two handles.
        // ignore: invalid_use_of_internal_member
        final interval = tester.getRect(find.byType(RemixBoxAdapter).at(1));
        expect(interval.size, const Size(112, 6));
        expect(interval.center.dx, (lower.center.dx + upper.center.dx) / 2);

        expect(
          lower.center.dx < upper.center.dx,
          direction == TextDirection.ltr,
        );
        expect(
          tester.getSize(find.byType(RemixRangeSlider)),
          const Size(240, 48),
        );
        expect(tester.takeException(), isNull);
      },
    );
  }

  for (final dark in [false, true]) {
    for (final rtl in [false, true]) {
      testWidgets(
        'combobox panel follows its field; dark=$dark RTL 200%=$rtl',
        (tester) async {
          await tester.pumpWidget(
            WidgetsApp(
              color: const Color(0xFFFFFFFF),
              pageRouteBuilder: <T>(settings, builder) => PageRouteBuilder<T>(
                settings: settings,
                pageBuilder: (context, _, _) => builder(context),
              ),
              builder: (context, navigator) => VanillaTheme(
                mode: dark ? .dark : .light,
                child: MediaQuery(
                  data: MediaQuery.of(
                    context,
                  ).copyWith(textScaler: TextScaler.linear(rtl ? 2 : 1)),
                  child: Directionality(
                    textDirection: rtl ? .rtl : .ltr,
                    child: navigator!,
                  ),
                ),
              ),
              home: Align(
                alignment: .topCenter,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: SizedBox(
                    width: 320,
                    child: VanillaCombobox<String>(
                      hintText: 'Search destinations',
                      optionsBuilder: (_) => const [
                        'San Sebastián, Basque Country · Spain',
                        'San Francisco, California · United States',
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
          final field = find.byType(RemixTextField);
          if (!rtl) expect(tester.getSize(field).height, 36);
          await tester.enterText(find.byType(EditableText), 'san');
          await tester.pumpAndSettle();
          final fieldRect = tester.getRect(field);
          final panelRect = tester.getRect(
            find
                .ancestor(
                  of: find.text('San Sebastián, Basque Country · Spain'),
                  matching: find.byType(DecoratedBox),
                )
                .last,
          );
          expect(panelRect.top - fieldRect.bottom, 8);
          expect(panelRect.width, fieldRect.width);
          final label = tester.getRect(
            find.text('San Sebastián, Basque Country · Spain'),
          );
          expect(panelRect.contains(label.topLeft), isTrue);
          expect(panelRect.contains(label.bottomRight), isTrue);
          expect(tester.takeException(), isNull);
        },
      );
    }
  }

  testWidgets('a dialog is centered and fills at most 512px', (tester) async {
    tester.view.physicalSize = const Size(1280, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    late BuildContext context;
    await tester.pumpWidget(
      host(
        Builder(
          builder: (inner) {
            context = inner;
            return const SizedBox.shrink();
          },
        ),
      ),
    );

    showRemixDialog<void>(
      context: context,
      barrierLabel: 'Dismiss',
      builder: (_) =>
          const VanillaDialog(title: 'Invite', description: 'Share it.'),
    );
    await tester.pumpAndSettle();

    final panel = panelOf(tester, 'Invite');
    expect(panel.width, 512);
    expect(panel.center.dx, 640);
    expect(panel.center.dy, 400);
    expect(panel.height, lessThan(800));
  });

  testWidgets('a dialog in a narrow viewport keeps 16px at each side', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(375, 700);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    late BuildContext context;
    await tester.pumpWidget(
      host(
        Builder(
          builder: (inner) {
            context = inner;
            return const SizedBox.shrink();
          },
        ),
      ),
    );

    showRemixDialog<void>(
      context: context,
      barrierLabel: 'Dismiss',
      builder: (_) =>
          const VanillaDialog(title: 'Invite', description: 'Share it.'),
    );
    await tester.pumpAndSettle();

    final panel = panelOf(tester, 'Invite');
    expect(panel.left, 16);
    expect(panel.right, 375 - 16);
  });

  testWidgets('a sidebar destination row is 32px tall', (tester) async {
    await tester.pumpWidget(
      host(
        Center(
          child: SizedBox(
            width: 280,
            height: 320,
            child: VanillaSidebar<String>(
              sections: const [
                RemixSidebarSection(
                  label: 'Workspace',
                  destinations: [
                    RemixSidebarDestination(
                      value: 'overview',
                      label: 'Overview',
                      icon: RemixIcons.grid,
                    ),
                  ],
                ),
              ],
              selectedValue: 'overview',
              onSelected: (_) {},
            ),
          ),
        ),
      ),
    );

    expect(panelOf(tester, 'Overview').height, 32);
  });

  testWidgets(
    'a select panel is at least 128px and at least its trigger wide',
    (tester) async {
      Future<double> panelWidth(double triggerWidth) async {
        await tester.pumpWidget(
          host(
            Center(
              child: SizedBox(
                width: triggerWidth,
                child: VanillaSelect<String>(
                  trigger: const RemixSelectTrigger(placeholder: 'Plan'),
                  items: const [RemixSelectItem(value: 'free', label: 'Free')],
                  onChanged: (_) {},
                ),
              ),
            ),
          ),
        );
        await tester.tap(find.byType(VanillaSelect<String>));
        await tester.pumpAndSettle();
        final width = tester
            .getSize(
              find
                  .ancestor(
                    of: find.text('Free'),
                    // ignore: invalid_use_of_internal_member
                    matching: find.byType(RemixBoxAdapter),
                  )
                  .last,
            )
            .width;
        await tester.tapAt(const Offset(2, 2));
        await tester.pumpAndSettle();

        return width;
      }

      expect(await panelWidth(100), 128);
      expect(await panelWidth(240), 240);
      expect(await panelWidth(400), 400);
    },
  );

  for (final dark in [false, true]) {
    testWidgets('form fields that sit side by side share the 36px height '
        '(${dark ? "dark" : "light"})', (tester) async {
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      final fields = <String, Widget>{
        'text field': const VanillaTextField(hintText: 'Name'),
        'select trigger': VanillaSelect<String>(
          trigger: const RemixSelectTrigger(placeholder: 'Plan'),
          items: const [RemixSelectItem(value: 'free', label: 'Free')],
          onChanged: (_) {},
        ),
        'combobox field': VanillaCombobox<String>(
          hintText: 'Search',
          optionsBuilder: (_) => const ['Free'],
        ),
        'outline button': VanillaButton.outline(
          label: 'Apply',
          onPressed: () {},
        ),
        'date picker trigger': VanillaDatePicker(
          value: null,
          firstDate: DateTime(2026),
          lastDate: DateTime(2027),
          onChanged: (_) {},
        ),
      };
      final keys = {for (final name in fields.keys) name: GlobalKey()};
      await tester.pumpWidget(
        WidgetsApp(
          color: const Color(0xFFFFFFFF),
          pageRouteBuilder: <T>(settings, builder) => PageRouteBuilder<T>(
            settings: settings,
            pageBuilder: (context, _, _) => builder(context),
          ),
          builder: (context, navigator) =>
              VanillaTheme(mode: dark ? .dark : .light, child: navigator!),
          home: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final MapEntry(:key, :value) in fields.entries)
                  SizedBox(
                    width: 200,
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: KeyedSubtree(key: keys[key], child: value),
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      for (final MapEntry(key: name, value: key) in keys.entries) {
        expect(
          tester.getSize(find.byKey(key)).height,
          36,
          reason: '$name height',
        );
      }
    });
  }

  testWidgets('a segmented control stays 36px tall inside a taller row', (
    tester,
  ) async {
    await tester.pumpWidget(
      host(
        Center(
          child: SizedBox(
            height: 56,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                VanillaSegmentedControl<String>(
                  items: const [
                    RemixSegmentedControlItem(value: 'today', label: 'Today'),
                    RemixSegmentedControlItem(value: 'tasks', label: 'Tasks'),
                  ],
                  selectedValue: 'today',
                  onChanged: (_) {},
                ),
              ],
            ),
          ),
        ),
      ),
    );

    expect(
      tester.getSize(find.byType(VanillaSegmentedControl<String>)).height,
      36,
    );
  });
}
