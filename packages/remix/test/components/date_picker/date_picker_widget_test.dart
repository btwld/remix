import 'dart:ui' show Tristate;

import 'package:flutter/gestures.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:naked_ui/naked_ui.dart';
import 'package:remix/remix.dart';

Widget _host(
  Widget child, {
  double textScale = 1,
  TextDirection direction = TextDirection.ltr,
  EdgeInsets? safeArea,
  EdgeInsets? viewInsets,
  GlobalKey<NavigatorState>? navigatorKey,
}) => WidgetsApp(
  color: const Color(0xffffffff),
  navigatorKey: navigatorKey,
  pageRouteBuilder: <T>(settings, builder) => PageRouteBuilder<T>(
    settings: settings,
    pageBuilder: (context, animation, secondaryAnimation) => builder(context),
  ),
  builder: (context, page) => MediaQuery(
    data: MediaQuery.of(context).copyWith(
      textScaler: TextScaler.linear(textScale),
      padding: safeArea,
      viewPadding: safeArea,
      viewInsets: viewInsets,
    ),
    child: Directionality(textDirection: direction, child: page!),
  ),
  home: Center(child: child),
);

RemixDatePicker _picker({
  DateTime? value,
  DateTime? firstDate,
  DateTime? lastDate,
  DateTime? currentDate,
  ValueChanged<DateTime>? onChanged,
  FocusNode? focusNode,
  bool enabled = true,
  bool Function(DateTime)? isDateUnavailable,
  String semanticLabel = 'Appointment date',
  String placeholder = 'Select date',
  String Function(DateTime)? formatDate,
  RemixCalendarLabels calendarLabels = const RemixCalendarLabels(),
  ButtonStyler buttonStyle = const ButtonStyler.create(),
  CalendarStyler calendarStyle = const CalendarStyler.create(),
  PopoverStyler popoverStyle = const PopoverStyler.create(),
}) => RemixDatePicker(
  value: value,
  firstDate: firstDate ?? DateTime(2023),
  lastDate: lastDate ?? DateTime(2026, 12, 31),
  currentDate: currentDate ?? DateTime(2024, 2, 15),
  onChanged: onChanged ?? (_) {},
  focusNode: focusNode,
  enabled: enabled,
  isDateUnavailable: isDateUnavailable,
  semanticLabel: semanticLabel,
  placeholder: placeholder,
  formatDate: formatDate,
  calendarLabels: calendarLabels,
  buttonStyle: buttonStyle,
  calendarStyle: calendarStyle,
  popoverStyle: popoverStyle,
);

DateTime? _focusedDate() {
  DateTime? result;
  FocusManager.instance.primaryFocus?.context?.visitAncestorElements((element) {
    if (element.widget case NakedCalendarDay(:final date)) {
      result = date;
      return false;
    }
    return true;
  });
  return result;
}

bool _focusInside(Type type) {
  var found = false;
  FocusManager.instance.primaryFocus?.context?.visitAncestorElements((element) {
    if (element.widget.runtimeType == type) found = true;
    return !found;
  });
  return found;
}

Future<void> _open(WidgetTester tester) async {
  await tester.tap(find.byType(RemixButton).first);
  await tester.pumpAndSettle();
  expect(find.byType(RemixCalendar), findsOneWidget);
}

void main() {
  testWidgets('queued metric close cannot dismiss a pointer-reopened session', (
    tester,
  ) async {
    await tester.pumpWidget(_host(_picker()));
    await _open(tester);
    final trigger = find.byType(RemixButton).first;
    tester.binding.handleMetricsChanged();
    await tester.tap(trigger);
    await tester.tap(trigger);
    await tester.pumpAndSettle();
    expect(find.byType(RemixCalendar), findsOneWidget);
  });

  for (final reopen in [false, true]) {
    testWidgets(
      'queued semantic day action is ignored after ${reopen ? 'reopen' : 'dismissal'}',
      (tester) async {
        final semantics = tester.ensureSemantics();
        final requests = <DateTime>[];
        try {
          await tester.pumpWidget(_host(_picker(onChanged: requests.add)));
          await _open(tester);
          final day = tester.getSemantics(
            find.bySemanticsLabel('Thursday, February 22, 2024'),
          );
          final trigger = tester.getSemantics(find.byType(RemixButton).first);
          final owner = day.owner!;
          owner.performAction(trigger.id, SemanticsAction.tap);
          if (reopen) owner.performAction(trigger.id, SemanticsAction.tap);
          owner.performAction(day.id, SemanticsAction.tap);
          await tester.pumpAndSettle();
          expect(requests, isEmpty);
          expect(
            find.byType(RemixCalendar),
            reopen ? findsOneWidget : findsNothing,
          );
        } finally {
          semantics.dispose();
        }
      },
    );
  }

  testWidgets(
    'selection cleanup preserves a session reopened by the callback',
    (tester) async {
      late SemanticsNode trigger;
      final semantics = tester.ensureSemantics();
      final requests = <DateTime>[];
      try {
        await tester.pumpWidget(
          _host(
            _picker(
              onChanged: (date) {
                requests.add(date);
                trigger.owner!.performAction(trigger.id, SemanticsAction.tap);
                trigger.owner!.performAction(trigger.id, SemanticsAction.tap);
              },
            ),
          ),
        );
        await _open(tester);
        trigger = tester.getSemantics(find.byType(RemixButton).first);
        await tester.tap(find.text('22'));
        await tester.pumpAndSettle();
        expect(requests, [DateTime(2024, 2, 22)]);
        expect(find.byType(RemixCalendar), findsOneWidget);
      } finally {
        semantics.dispose();
      }
    },
  );

  testWidgets('calendar minimum-width styling composes inside the picker', (
    tester,
  ) async {
    await tester.pumpWidget(
      _host(_picker(calendarStyle: CalendarStyler().minWidth(420))),
    );
    await _open(tester);
    expect(tester.takeException(), isNull);
    expect(tester.getSize(find.byType(RemixCalendar)).width, 420);
    await tester.tap(find.text('20'));
    await tester.pumpAndSettle();
    expect(find.byType(RemixCalendar), findsNothing);
  });

  testWidgets('one real trigger, localized name and single expanded state', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();

    final before = FocusNode();
    final trigger = FocusNode();
    final after = FocusNode();
    addTearDown(before.dispose);
    addTearDown(trigger.dispose);
    addTearDown(after.dispose);
    await tester.pumpWidget(
      _host(
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RemixButton(label: 'Before', focusNode: before, onPressed: () {}),
            _picker(
              focusNode: trigger,
              placeholder: 'Choisir',
              semanticLabel: 'Rendez-vous',
            ),
            RemixButton(label: 'After', focusNode: after, onPressed: () {}),
          ],
        ),
      ),
    );
    final node = tester.getSemantics(
      find.bySemanticsLabel('Rendez-vous, Choisir'),
    );
    expect(node.getSemanticsData().flagsCollection.isButton, isTrue);
    expect(
      node.getSemanticsData().flagsCollection.isExpanded,
      Tristate.isFalse,
    );
    expect(find.byType(NakedButton), findsNWidgets(3));
    before.requestFocus();
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();
    expect(trigger.hasPrimaryFocus, isTrue);
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();
    expect(after.hasPrimaryFocus, isTrue);
    trigger.requestFocus();
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pumpAndSettle();
    expect(_focusedDate(), DateTime(2024, 2, 15));
    final expanded = tester.getSemantics(
      find.bySemanticsLabel('Rendez-vous, Choisir'),
    );
    expect(
      expanded.getSemanticsData().flagsCollection.isExpanded,
      Tristate.isTrue,
    );
    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pumpAndSettle();
    expect(trigger.hasPrimaryFocus, isTrue);
    await tester.sendKeyEvent(LogicalKeyboardKey.space);
    await tester.pumpAndSettle();
    expect(_focusedDate(), DateTime(2024, 2, 15));
    semantics.dispose();
  });

  for (final kind in [
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    PointerDeviceKind.stylus,
  ]) {
    testWidgets('$kind opens onto actual selected day; keys do not select', (
      tester,
    ) async {
      final changes = <DateTime>[];
      await tester.pumpWidget(
        _host(
          _picker(value: DateTime.utc(2024, 2, 14, 20), onChanged: changes.add),
        ),
      );
      await tester.tap(find.byType(RemixButton), kind: kind);
      await tester.pumpAndSettle();
      expect(_focusedDate(), DateTime(2024, 2, 14));
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pumpAndSettle();
      expect(_focusedDate(), DateTime(2024, 2, 21));
      expect(changes, isEmpty);
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();
      expect(changes, [DateTime(2024, 2, 21)]);
      expect(find.byType(RemixCalendar), findsNothing);
    });
  }

  testWidgets('unavailable selected date is focusable, not activatable', (
    tester,
  ) async {
    final changes = <DateTime>[];
    await tester.pumpWidget(
      _host(
        _picker(
          value: DateTime(2024, 2, 14),
          isDateUnavailable: (date) => date.day == 14,
          onChanged: changes.add,
        ),
      ),
    );
    await _open(tester);
    expect(_focusedDate(), DateTime(2024, 2, 14));
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pumpAndSettle();
    expect(changes, isEmpty);
    expect(find.byType(RemixCalendar), findsOneWidget);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
    await tester.pumpAndSettle();
    expect(_focusedDate(), DateTime(2024, 2, 15));
    await tester.sendKeyEvent(LogicalKeyboardKey.space);
    await tester.pumpAndSettle();
    expect(changes, [DateTime(2024, 2, 15)]);
  });

  testWidgets(
    'invalid external value remains named; focus follows clamped current day',
    (tester) async {
      await tester.pumpWidget(
        _host(
          _picker(
            value: DateTime(2030, 8, 7),
            firstDate: DateTime(2024, 2, 10),
            lastDate: DateTime(2024, 2, 20),
            currentDate: DateTime(2020),
          ),
        ),
      );
      expect(find.text('Wednesday, August 7, 2030'), findsOneWidget);
      await _open(tester);
      expect(_focusedDate(), DateTime(2024, 2, 10));
    },
  );

  testWidgets(
    'repeated selected date requests once and closes despite rejecting parent',
    (tester) async {
      final changes = <DateTime>[];
      await tester.pumpWidget(
        _host(_picker(value: DateTime(2024, 2, 14), onChanged: changes.add)),
      );
      for (var attempt = 0; attempt < 2; attempt++) {
        await _open(tester);
        await tester.tap(find.text('14'));
        await tester.pumpAndSettle();
        expect(find.byType(RemixCalendar), findsNothing);
      }
      expect(changes, [DateTime(2024, 2, 14), DateTime(2024, 2, 14)]);
      expect(find.text('Wednesday, February 14, 2024'), findsOneWidget);
    },
  );

  testWidgets(
    'outside and Escape dismiss without selection and restore trigger',
    (tester) async {
      final changes = <DateTime>[];
      final focus = FocusNode();
      addTearDown(focus.dispose);
      await tester.pumpWidget(
        _host(_picker(focusNode: focus, onChanged: changes.add)),
      );
      await _open(tester);
      await tester.tapAt(const Offset(1, 1));
      await tester.pumpAndSettle();
      expect(find.byType(RemixCalendar), findsNothing);
      expect(focus.hasPrimaryFocus, isTrue);
      await _open(tester);
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();
      expect(find.byType(RemixCalendar), findsNothing);
      expect(focus.hasPrimaryFocus, isTrue);
      expect(changes, isEmpty);
    },
  );

  for (final removeCallback in [false, true]) {
    testWidgets(
      'open picker closes when ${removeCallback ? 'callback removed' : 'disabled'}',
      (tester) async {
        var enabled = true;
        late StateSetter update;
        final changes = <DateTime>[];
        await tester.pumpWidget(
          _host(
            StatefulBuilder(
              builder: (context, setState) {
                update = setState;
                return RemixDatePicker(
                  value: null,
                  firstDate: DateTime(2024),
                  lastDate: DateTime(2025),
                  onChanged: removeCallback && !enabled ? null : changes.add,
                  enabled: removeCallback || enabled,
                );
              },
            ),
          ),
        );
        await _open(tester);
        update(() => enabled = false);
        await tester.pumpAndSettle();
        expect(find.byType(RemixCalendar), findsNothing);
        await tester.tap(find.byType(RemixButton));
        await tester.pumpAndSettle();
        expect(find.byType(RemixCalendar), findsNothing);
        expect(changes, isEmpty);
        expect(tester.takeException(), isNull);
      },
    );
  }

  testWidgets(
    'removal in selection callback and open disposal leave no stale overlay',
    (tester) async {
      var visible = true;
      var count = 0;
      late StateSetter update;
      await tester.pumpWidget(
        _host(
          StatefulBuilder(
            builder: (context, setState) {
              update = setState;
              return visible
                  ? _picker(
                      onChanged: (_) {
                        count++;
                        setState(() => visible = false);
                      },
                    )
                  : const Text('Gone');
            },
          ),
        ),
      );
      await _open(tester);
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();
      expect(count, 1);
      expect(find.text('Gone'), findsOneWidget);
      expect(find.byType(RemixCalendar), findsNothing);
      update(() => visible = true);
      await tester.pumpAndSettle();
      await _open(tester);
      await tester.pumpWidget(_host(const SizedBox()));
      await tester.pumpAndSettle();
      expect(find.byType(RemixCalendar), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('nested selector then picker then host dialog Escape order', (
    tester,
  ) async {
    final navigator = GlobalKey<NavigatorState>();
    final trigger = FocusNode();
    addTearDown(trigger.dispose);
    await tester.pumpWidget(_host(const Text('Host'), navigatorKey: navigator));
    final result = showNakedDialog<void>(
      context: navigator.currentContext!,
      barrierColor: const Color(0x55000000),
      builder: (_) => Center(child: _picker(focusNode: trigger)),
    );
    await tester.pumpAndSettle();
    await _open(tester);
    final monthSelector = find.byType(RemixSelect<int>).first;
    await tester.tap(monthSelector);
    await tester.pumpAndSettle();
    expect(find.text('January'), findsOneWidget);
    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pumpAndSettle();
    expect(find.text('January'), findsNothing);
    expect(find.byType(RemixCalendar), findsOneWidget);
    expect(_focusInside(RemixSelect<int>), isTrue);
    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pumpAndSettle();
    expect(find.byType(RemixCalendar), findsNothing);
    expect(trigger.hasPrimaryFocus, isTrue);
    expect(find.byType(RemixDatePicker), findsOneWidget);
    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pumpAndSettle();
    expect(find.byType(RemixDatePicker), findsNothing);
    await result;
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'picker opened inside parent popover returns to its live trigger',
    (tester) async {
      final parent = MenuController();
      final trigger = FocusNode();
      addTearDown(trigger.dispose);
      await tester.pumpWidget(
        _host(
          RemixPopover(
            controller: parent,
            popoverChild: _picker(focusNode: trigger),
            child: const Text('Parent'),
          ),
        ),
      );
      parent.open();
      await tester.pumpAndSettle();
      await _open(tester);
      await tester.tap(find.byType(RemixSelect<int>).first);
      await tester.pumpAndSettle();
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();
      expect(find.byType(RemixCalendar), findsOneWidget);
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();
      expect(find.byType(RemixCalendar), findsNothing);
      expect(parent.isOpen, isTrue);
      expect(trigger.hasPrimaryFocus, isTrue);
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();
      expect(parent.isOpen, isFalse);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'forward and reverse Tab contain focus in panel and leave day grid',
    (tester) async {
      await tester.pumpWidget(_host(_picker()));
      await _open(tester);
      final dayNode = FocusManager.instance.primaryFocus;
      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pumpAndSettle();
      expect(FocusManager.instance.primaryFocus, isNot(dayNode));
      expect(_focusInside(RemixCalendar), isTrue);
      await tester.sendKeyDownEvent(LogicalKeyboardKey.shiftLeft);
      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.sendKeyUpEvent(LogicalKeyboardKey.shiftLeft);
      await tester.pumpAndSettle();
      expect(FocusManager.instance.primaryFocus, dayNode);
      for (var i = 0; i < 12; i++) {
        await tester.sendKeyEvent(LogicalKeyboardKey.tab);
        await tester.pumpAndSettle();
        expect(_focusInside(RemixCalendar), isTrue);
      }
    },
  );

  for (final configuration in [
    (size: const Size(320, 300), scale: 1.0, rtl: false),
    (size: const Size(240, 230), scale: 2.0, rtl: true),
  ]) {
    testWidgets(
      'constrained ${configuration.size}, scale ${configuration.scale}, RTL ${configuration.rtl}: focused day revealed',
      (tester) async {
        tester.view.resetPhysicalSize();
        tester.view.devicePixelRatio = 1;
        tester.view.physicalSize = configuration.size;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        final changes = <DateTime>[];
        await tester.pumpWidget(
          _host(
            Align(
              alignment: Alignment.bottomRight,
              child: _picker(
                value: DateTime(2024, 2, 29),
                onChanged: changes.add,
              ),
            ),
            textScale: configuration.scale,
            direction: configuration.rtl
                ? TextDirection.rtl
                : TextDirection.ltr,
          ),
        );
        await _open(tester);
        expect(_focusedDate(), DateTime(2024, 2, 29));
        final panel = tester.getRect(find.byType(RemixCalendar));
        final day = tester.getRect(find.text('29'));
        expect(panel.left, greaterThanOrEqualTo(8));
        expect(panel.right, lessThanOrEqualTo(configuration.size.width - 8));
        expect(panel.top, greaterThanOrEqualTo(8));
        expect(panel.bottom, lessThanOrEqualTo(configuration.size.height - 8));
        expect(panel.overlaps(day), isTrue);
        expect(find.text('29').hitTestable(), findsOneWidget);
        await tester.sendKeyEvent(LogicalKeyboardKey.arrowUp);
        await tester.pumpAndSettle();
        expect(_focusedDate(), DateTime(2024, 2, 22));
        expect(find.text('22').hitTestable(), findsOneWidget);
        await tester.sendKeyEvent(LogicalKeyboardKey.enter);
        await tester.pumpAndSettle();
        expect(changes, [DateTime(2024, 2, 22)]);
        expect(tester.takeException(), isNull);
      },
    );
  }

  testWidgets(
    'safe areas and keyboard overlap; inset-only update safely closes',
    (tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(800, 350);
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      var keyboard = const EdgeInsets.only(bottom: 100);
      late StateSetter update;
      await tester.pumpWidget(
        StatefulBuilder(
          builder: (context, setState) {
            update = setState;
            return _host(
              Align(alignment: Alignment.topCenter, child: _picker()),
              safeArea: const EdgeInsets.fromLTRB(25, 30, 20, 40),
              viewInsets: keyboard,
            );
          },
        ),
      );
      await _open(tester);
      final panel = tester.getRect(find.byType(RemixCalendar));
      expect(panel.left, greaterThanOrEqualTo(33));
      expect(panel.right, lessThanOrEqualTo(772));
      expect(panel.top, greaterThanOrEqualTo(38));
      expect(panel.bottom, lessThanOrEqualTo(242));
      // Enough room below uses max(40,100), not their sum.
      expect(panel.bottom, greaterThan(202));
      update(() => keyboard = const EdgeInsets.only(bottom: 150));
      await tester.pumpAndSettle();
      expect(find.byType(RemixCalendar), findsNothing);
      await _open(tester);
      expect(
        tester.getRect(find.byType(RemixCalendar)).bottom,
        lessThanOrEqualTo(192),
      );
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'SafeArea anchor keeps picker and nested selectors in unconsumed view bounds',
    (tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(400, 400);
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(
        _host(
          SafeArea(
            child: Align(alignment: Alignment.topLeft, child: _picker()),
          ),
          safeArea: const EdgeInsets.fromLTRB(30, 80, 20, 60),
        ),
      );
      await _open(tester);
      final pickerPanel = tester.getRect(find.byType(RemixCalendar));
      expect(pickerPanel.left, greaterThanOrEqualTo(38));
      expect(pickerPanel.top, greaterThanOrEqualTo(88));
      expect(pickerPanel.right, lessThanOrEqualTo(372));
      expect(pickerPanel.bottom, lessThanOrEqualTo(332));
      for (var index = 0; index < 2; index++) {
        final selector = find.byType(RemixSelect<int>).at(index);
        await tester.ensureVisible(selector);
        await tester.pumpAndSettle();
        await tester.tap(selector);
        await tester.pumpAndSettle();
        final panel = tester.getRect(
          find
              .descendant(
                of: find.byType(OverlayPositioner).last,
                matching: find.byType(TapRegion),
              )
              .first,
        );
        expect(panel.left, greaterThanOrEqualTo(30));
        expect(panel.right, lessThanOrEqualTo(380));
        expect(panel.top, greaterThanOrEqualTo(80));
        expect(panel.bottom, lessThanOrEqualTo(340));
        await tester.sendKeyEvent(LogicalKeyboardKey.escape);
        await tester.pumpAndSettle();
        expect(_focusInside(RemixSelect<int>), isTrue);
        expect(find.byType(RemixCalendar), findsOneWidget);
      }
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'view safe-area metrics consumed by SafeArea still close the picker',
    (tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.padding = const FakeViewPadding(top: 80, bottom: 60);
      tester.view.viewPadding = const FakeViewPadding(top: 80, bottom: 60);
      addTearDown(tester.view.resetDevicePixelRatio);
      addTearDown(tester.view.resetPadding);
      addTearDown(tester.view.resetViewPadding);
      await tester.pumpWidget(_host(SafeArea(child: _picker())));
      await _open(tester);
      tester.view.padding = const FakeViewPadding(top: 100, bottom: 60);
      tester.view.viewPadding = const FakeViewPadding(top: 100, bottom: 60);
      await tester.pumpAndSettle();
      expect(find.byType(RemixCalendar), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );

  for (final side in [OverlaySide.left, OverlaySide.right]) {
    testWidgets(
      '$side picker honors top and bottom safe bounds without changing legacy height behavior',
      (tester) async {
        tester.view.devicePixelRatio = 1;
        tester.view.physicalSize = const Size(500, 350);
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        await tester.pumpWidget(
          _host(
            Align(
              alignment: Alignment.topCenter,
              child: RemixDatePicker(
                value: DateTime(2024, 2, 29),
                firstDate: DateTime(2024),
                lastDate: DateTime(2025),
                onChanged: (_) {},
                positioning: OverlayPositionConfig(
                  side: side,
                  collisionPadding: const EdgeInsets.all(10),
                ),
              ),
            ),
            safeArea: const EdgeInsets.fromLTRB(20, 60, 20, 40),
            viewInsets: const EdgeInsets.only(bottom: 100),
          ),
        );
        await _open(tester);
        final panel = tester.getRect(find.byType(RemixCalendar));
        expect(panel.left, greaterThanOrEqualTo(30));
        expect(panel.right, lessThanOrEqualTo(470));
        expect(panel.top, greaterThanOrEqualTo(70));
        expect(panel.bottom, lessThanOrEqualTo(240));
        expect(find.text('29').hitTestable(), findsOneWidget);
        expect(tester.takeException(), isNull);
      },
    );
  }

  for (final offset in [0.0, 200.0]) {
    testWidgets(
      'root popover keeps picker and selectors view-safe at nested Overlay offset $offset',
      (tester) async {
        tester.view.devicePixelRatio = 1;
        tester.view.physicalSize = const Size(800, 600);
        addTearDown(tester.view.resetDevicePixelRatio);
        addTearDown(tester.view.resetPhysicalSize);
        final outer = MenuController();
        await tester.pumpWidget(
          _host(
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: EdgeInsets.only(left: offset, top: offset),
                child: SizedBox(
                  width: 400,
                  height: 300,
                  child: Overlay.wrap(
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: NakedPopover(
                        controller: outer,
                        useRootOverlay: true,
                        popoverBuilder: (context, info) =>
                            _picker(value: DateTime(2024, 2, 29)),
                        child: const Text('Outer popover'),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            safeArea: const EdgeInsets.only(top: 80, bottom: 60),
          ),
        );
        outer.open();
        await tester.pumpAndSettle();
        await _open(tester);
        final panel = tester.getRect(find.byType(RemixCalendar));
        expect(panel.top, greaterThanOrEqualTo(88));
        expect(panel.bottom, lessThanOrEqualTo(532));
        expect(panel.width, 308);
        for (var index = 0; index < 2; index++) {
          final selector = find.byType(RemixSelect<int>).at(index);
          await tester.ensureVisible(selector);
          await tester.pumpAndSettle();
          await tester.tap(selector);
          await tester.pumpAndSettle();
          final selectorPanel = tester.getRect(
            find
                .descendant(
                  of: find.byType(OverlayPositioner).last,
                  matching: find.byType(TapRegion),
                )
                .first,
          );
          expect(selectorPanel.top, greaterThanOrEqualTo(80));
          expect(selectorPanel.bottom, lessThanOrEqualTo(540));
          await tester.sendKeyEvent(LogicalKeyboardKey.escape);
          await tester.pumpAndSettle();
          expect(find.byType(RemixCalendar), findsOneWidget);
        }
        expect(tester.takeException(), isNull);
      },
    );
  }

  testWidgets(
    'small offset nested Overlay bounds and safe area intersect correctly',
    (tester) async {
      const nestedKey = ValueKey('nested overlay');
      await tester.pumpWidget(
        _host(
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 10, top: 15),
              child: SizedBox(
                width: 250,
                height: 260,
                child: Overlay.wrap(
                  key: nestedKey,
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: _picker(value: DateTime(2024, 2, 29)),
                  ),
                ),
              ),
            ),
          ),
          safeArea: const EdgeInsets.only(left: 30, top: 40),
          viewInsets: const EdgeInsets.only(bottom: 100),
        ),
      );
      await _open(tester);
      final panel = tester.getRect(find.byType(RemixCalendar));
      expect(panel.left, greaterThanOrEqualTo(38));
      expect(panel.top, greaterThanOrEqualTo(48));
      expect(panel.right, lessThanOrEqualTo(252));
      expect(panel.bottom, lessThanOrEqualTo(267));
      expect(find.text('29').hitTestable(), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
}
