import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/remix.dart';

import 'combobox_test_host.dart';

void main() {
  testWidgets(
    'overflow thumb stays visible after idle without host scrollbars',
    (tester) async {
      await tester.pumpWidget(
        comboboxHost(
          ScrollConfiguration(
            behavior: const ScrollBehavior().copyWith(scrollbars: false),
            child: RemixCombobox<String>(
              optionsBuilder: (_) => List.generate(24, (i) => 'Suggestion $i'),
              style: testComboboxStyle().panel(
                ComboboxPanelStyler()
                    .scrollbarColor(const Color(0xFFAA0000))
                    .scrollbarThickness(6),
              ),
            ),
          ),
        ),
      );
      await openCombobox(tester);
      await tester.pump(const Duration(seconds: 2));
      expect(find.byType(RawScrollbar), findsOneWidget);
      final bar = tester.widget<RawScrollbar>(find.byType(RawScrollbar));
      expect(bar.thumbVisibility, isTrue);
      expect(bar.thumbColor, const Color(0xFFAA0000));
      expect(bar.thickness, 6);
      expect(bar.controller!.position.maxScrollExtent, greaterThan(0));
      expect(bar.controller!.position.physics, isA<ClampingScrollPhysics>());
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();
      expect(find.byType(RawScrollbar), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'popup viewport notifications stay inside its scroller',
    (tester) async {
      final hostController = ScrollController(initialScrollOffset: 48);
      addTearDown(hostController.dispose);
      final escaped = <ViewportNotificationMixin>[];
      final values = List.generate(24, (index) => 'Suggestion $index');
      await tester.pumpWidget(
        comboboxHost(
          NotificationListener<ViewportNotificationMixin>(
            onNotification: (notification) {
              escaped.add(notification);
              return false;
            },
            child: PrimaryScrollController(
              controller: hostController,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RemixCombobox<String>(
                    optionsBuilder: (_) => values,
                    style: testComboboxStyle(),
                  ),
                  SizedBox(
                    height: 200,
                    child: ListView(
                      primary: true,
                      children: const [SizedBox(height: 1000)],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
      await openCombobox(tester);
      escaped.clear();
      final popup = find.byType(SingleChildScrollView).last;
      final popupState = tester.state<ScrollableState>(
        find.descendant(of: popup, matching: find.byType(Scrollable)),
      );
      await tester.drag(popup, const Offset(0, 100));
      await tester.pumpAndSettle();
      await tester.drag(popup, const Offset(0, -120));
      await tester.pumpAndSettle();
      expect(popupState.position.pixels, greaterThan(0));
      expect(escaped, isEmpty);
      expect(hostController.positions, hasLength(1));
      expect(hostController.offset, 48);

      Actions.invoke(
        tester.element(find.byType(EditableText)),
        const AutocompleteLastOptionIntent(),
      );
      await tester.pumpAndSettle();
      final last = tester.getRect(find.text(values.last));
      final viewport = tester.getRect(popup);
      expect(last.top, greaterThanOrEqualTo(viewport.top));
      expect(last.bottom, lessThanOrEqualTo(viewport.bottom));
      expect(escaped, isEmpty);

      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();
      // Containment belongs to the popup, not to the host's normal scroll view.
      await tester.drag(find.byType(ListView), const Offset(0, -100));
      await tester.pumpAndSettle();
      expect(hostController.offset, greaterThan(48));
      expect(escaped.whereType<ScrollUpdateNotification>(), isNotEmpty);
    },
    variant: TargetPlatformVariant({
      TargetPlatform.android,
      TargetPlatform.iOS,
    }),
  );

  testWidgets(
    'popup overscroll does not refresh the page or notify its scrollbar',
    (tester) async {
      final pageController = ScrollController();
      addTearDown(pageController.dispose);
      var refreshes = 0;
      final scrollbarNotifications = <ScrollNotification>[];
      await tester.pumpWidget(
        material.MaterialApp(
          home: material.Scaffold(
            body: material.RefreshIndicator(
              onRefresh: () async => refreshes++,
              child: material.Scrollbar(
                controller: pageController,
                notificationPredicate: (notification) {
                  scrollbarNotifications.add(notification);
                  return notification.depth == 0;
                },
                child: Column(
                  children: [
                    RemixCombobox<String>(
                      optionsBuilder: (_) =>
                          List.generate(24, (index) => 'Suggestion $index'),
                      style: testComboboxStyle(),
                    ),
                    SizedBox(
                      height: 240,
                      child: ListView(
                        controller: pageController,
                        physics: const AlwaysScrollableScrollPhysics(),
                        children: const [SizedBox(height: 1000)],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
      await openCombobox(tester);
      scrollbarNotifications.clear();
      await tester.drag(
        find.byType(SingleChildScrollView).last,
        const Offset(0, 400),
      );
      await tester.pumpAndSettle();
      expect(refreshes, 0);
      expect(scrollbarNotifications, isEmpty);
      expect(pageController.offset, 0);

      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();
      await tester.drag(find.byType(ListView), const Offset(0, 400));
      await tester.pumpAndSettle();
      expect(refreshes, 1);
      expect(scrollbarNotifications, isNotEmpty);
    },
    variant: TargetPlatformVariant.only(TargetPlatform.android),
  );
}
