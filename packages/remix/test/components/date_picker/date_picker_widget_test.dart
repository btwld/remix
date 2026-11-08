import 'dart:ui' show Tristate;

import 'package:flutter/gestures.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:naked_ui/naked_ui.dart';
import 'package:remix/remix.dart';

import 'date_picker_test_helpers.dart';

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

Future<void> _open(WidgetTester tester) async {
  await tester.tap(find.byType(RemixButton).first);
  await tester.pumpAndSettle();
  expect(find.byType(RemixCalendar), findsOneWidget);
}

void main() {
  testWidgets('onOpen and onClose tell completion apart from dismissal', (
    tester,
  ) async {
    final events = <String>[];
    await tester.pumpWidget(
      pickerHost(
        RemixDatePicker(
          value: null,
          firstDate: DateTime(2023),
          lastDate: DateTime(2026, 12, 31),
          currentDate: DateTime(2024, 2, 15),
          onChanged: (date) => events.add('changed ${date.day}'),
          onOpen: () => events.add('open'),
          onClose: () => events.add('close'),
        ),
      ),
    );
    await _open(tester);
    expect(events, ['open']);
    await pressKey(tester, LogicalKeyboardKey.escape);
    expect(events, ['open', 'close'], reason: 'dismissal never selects');
    events.clear();
    await _open(tester);
    await tester.tap(find.text('20'));
    await tester.pumpAndSettle();
    expect(events, ['open', 'changed 20', 'close']);
  });

  for (final sameFrame in [false, true]) {
    testWidgets(
      'reopening (same frame: $sameFrame) restarts at the selected day',
      (tester) async {
        bool showsMarch() => find
            .byWidgetPredicate(
              (w) => w is NakedCalendarDay && w.date == DateTime(2024, 3, 5),
            )
            .evaluate()
            .isNotEmpty;
        await tester.pumpWidget(
          pickerHost(_picker(value: DateTime(2024, 2, 20))),
        );
        await _open(tester);
        expect(focusedDate(), DateTime(2024, 2, 20));
        await pressKey(tester, LogicalKeyboardKey.pageDown);
        expect(focusedDate(), DateTime(2024, 3, 20));
        expect(showsMarch(), isTrue);
        final controller = outerController(tester);
        controller.close();
        if (!sameFrame) await tester.pumpAndSettle();
        controller.open();
        await tester.pumpAndSettle();
        expect(find.byType(RemixCalendar), findsOneWidget);
        expect(showsMarch(), isFalse, reason: 'browsed month must reset');
        expect(focusedDate(), DateTime(2024, 2, 20));
      },
    );
  }

  testWidgets('metrics without a view-size change keep the picker open', (
    tester,
  ) async {
    await tester.pumpWidget(pickerHost(_picker()));
    await _open(tester);
    tester.binding.handleMetricsChanged();
    await tester.pumpAndSettle();
    expect(find.byType(RemixCalendar), findsOneWidget);
  });

  testWidgets('a view-size change closes the picker without selecting', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(800, 600);
    addTearDown(tester.view.reset);
    final requests = <DateTime>[];
    await tester.pumpWidget(pickerHost(_picker(onChanged: requests.add)));
    await _open(tester);
    tester.view.physicalSize = const Size(600, 800);
    await tester.pumpAndSettle();
    expect(find.byType(RemixCalendar), findsNothing);
    expect(requests, isEmpty);
    await _open(tester);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'the keyboard hiding after the trigger takes focus keeps it open',
    (tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(400, 800);
      // A text field above is focused, so the soft keyboard is showing.
      tester.view.viewInsets = const FakeViewPadding(bottom: 300);
      addTearDown(tester.view.reset);
      final text = TextEditingController();
      final textFocus = FocusNode();
      addTearDown(text.dispose);
      addTearDown(textFocus.dispose);
      await tester.pumpWidget(
        pickerHost(
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              EditableText(
                controller: text,
                focusNode: textFocus,
                style: const TextStyle(fontSize: 14),
                cursorColor: const Color(0xff000000),
                backgroundCursorColor: const Color(0xff888888),
              ),
              _picker(),
            ],
          ),
        ),
      );
      textFocus.requestFocus();
      await tester.pump();
      await tester.tap(find.byType(RemixButton));
      await tester.pump();
      expect(textFocus.hasFocus, isFalse);
      expect(find.byType(RemixCalendar), findsOneWidget);
      // The platform now animates the keyboard away over several frames.
      for (final bottom in [200.0, 100.0, 0.0]) {
        tester.view.viewInsets = FakeViewPadding(bottom: bottom);
        await tester.pump(const Duration(milliseconds: 16));
      }
      await tester.pumpAndSettle();
      expect(find.byType(RemixCalendar), findsOneWidget);
      expect(focusInside(RemixCalendar), isTrue);
    },
  );

  testWidgets('a keyboard shown while open re-fits the panel above it', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(800, 600);
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      pickerHost(Align(alignment: Alignment.topCenter, child: _picker())),
    );
    await _open(tester);
    expect(tester.getRect(find.byType(RemixCalendar)).bottom, greaterThan(250));
    tester.view.viewInsets = const FakeViewPadding(bottom: 350);
    await tester.pumpAndSettle();
    expect(find.byType(RemixCalendar), findsOneWidget);
    final panel = tester.getRect(find.byType(RemixCalendar));
    expect(panel.top, greaterThanOrEqualTo(8));
    expect(panel.bottom, lessThanOrEqualTo(242));
    expect(tester.takeException(), isNull);
  });

  for (final reopen in [false, true]) {
    testWidgets(
      'queued semantic day action is ignored after ${reopen ? 'reopen' : 'dismissal'}',
      (tester) async {
        final semantics = tester.ensureSemantics();
        final requests = <DateTime>[];
        try {
          await tester.pumpWidget(pickerHost(_picker(onChanged: requests.add)));
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
          pickerHost(
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
      pickerHost(_picker(calendarStyle: CalendarStyler().minWidth(420))),
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
    await withSemantics(tester, () async {
      final before = FocusNode();
      final trigger = FocusNode();
      final after = FocusNode();
      addTearDown(before.dispose);
      addTearDown(trigger.dispose);
      addTearDown(after.dispose);
      await tester.pumpWidget(
        pickerHost(
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RemixButton(label: 'Before', focusNode: before, onPressed: () {}),
              _picker(
                focusNode: trigger,
                placeholder: 'Choisir',
                semanticLabel: 'Rendez-vous',
                calendarLabels: const RemixCalendarLabels(
                  noDate: 'Aucune date',
                ),
              ),
              RemixButton(label: 'After', focusNode: after, onPressed: () {}),
            ],
          ),
        ),
      );
      final node = tester.getSemantics(find.bySemanticsLabel('Rendez-vous'));
      // The purpose is the name; the empty state is a localized value, not the
      // visible placeholder appended to the name.
      expect(node.getSemanticsData().value, 'Aucune date');
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
      expect(focusedDate(), DateTime(2024, 2, 15));
      // The open calendar shares the purpose as its name; read the trigger.
      final expanded = tester.getSemantics(find.byType(RemixButton).at(1));
      expect(expanded.getSemanticsData().label, 'Rendez-vous');
      expect(
        expanded.getSemanticsData().flagsCollection.isExpanded,
        Tristate.isTrue,
      );
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();
      expect(trigger.hasPrimaryFocus, isTrue);
      await tester.sendKeyEvent(LogicalKeyboardKey.space);
      await tester.pumpAndSettle();
      expect(focusedDate(), DateTime(2024, 2, 15));
    });
  });

  testWidgets('trigger value is the full date while formatDate stays visual', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    try {
      await tester.pumpWidget(
        pickerHost(
          _picker(
            value: DateTime(2024, 2, 20),
            formatDate: (date) => '${date.day}/${date.month}',
          ),
        ),
      );
      expect(find.text('20/2'), findsOneWidget);
      final data = tester
          .getSemantics(find.bySemanticsLabel('Appointment date'))
          .getSemanticsData();
      expect(data.value, 'Tuesday, February 20, 2024');
      expect(data.label, isNot(contains('20/2')));
      expect(data.flagsCollection.isButton, isTrue);
    } finally {
      semantics.dispose();
    }
  });

  testWidgets('replacing a borrowed focusNode while open closes the picker', (
    tester,
  ) async {
    final first = FocusNode(debugLabel: 'first borrowed');
    final second = FocusNode(debugLabel: 'second borrowed');
    addTearDown(first.dispose);
    addTearDown(second.dispose);
    final requests = <DateTime>[];
    late StateSetter update;
    var node = first;
    await tester.pumpWidget(
      StatefulBuilder(
        builder: (context, setState) {
          update = setState;
          return pickerHost(_picker(focusNode: node, onChanged: requests.add));
        },
      ),
    );
    await _open(tester);
    update(() => node = second);
    await tester.pumpAndSettle();
    expect(find.byType(RemixCalendar), findsNothing);
    expect(requests, isEmpty);
    // The application owns focus on its replacement node.
    expect(second.hasFocus, isFalse);
    second.requestFocus();
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pumpAndSettle();
    expect(find.byType(RemixCalendar), findsOneWidget);
    expect(focusedDate(), DateTime(2024, 2, 15));
    expect(tester.takeException(), isNull);
  });

  testWidgets('autofocus focuses the trigger, not the calendar', (
    tester,
  ) async {
    final trigger = FocusNode();
    addTearDown(trigger.dispose);
    await tester.pumpWidget(
      pickerHost(
        RemixDatePicker(
          value: null,
          firstDate: DateTime(2023),
          lastDate: DateTime(2026, 12, 31),
          onChanged: (_) {},
          focusNode: trigger,
          autofocus: true,
        ),
      ),
    );
    await tester.pump();
    expect(trigger.hasPrimaryFocus, isTrue);
    expect(find.byType(RemixCalendar), findsNothing);
  });

  testWidgets('clearing the parent value restores the placeholder', (
    tester,
  ) async {
    DateTime? value = DateTime(2024, 2, 20);
    late StateSetter update;
    await tester.pumpWidget(
      StatefulBuilder(
        builder: (context, setState) {
          update = setState;
          return pickerHost(
            _picker(
              value: value,
              onChanged: (date) => setState(() => value = date),
            ),
          );
        },
      ),
    );
    expect(find.text('Tuesday, February 20, 2024'), findsOneWidget);
    update(() => value = null);
    await tester.pump();
    expect(find.text('Select date'), findsOneWidget);
    await _open(tester);
    expect(focusedDate(), DateTime(2024, 2, 15));
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
        pickerHost(
          _picker(value: DateTime.utc(2024, 2, 14, 20), onChanged: changes.add),
        ),
      );
      await tester.tap(find.byType(RemixButton), kind: kind);
      await tester.pumpAndSettle();
      expect(focusedDate(), DateTime(2024, 2, 14));
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pumpAndSettle();
      expect(focusedDate(), DateTime(2024, 2, 21));
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
      pickerHost(
        _picker(
          value: DateTime(2024, 2, 14),
          isDateUnavailable: (date) => date.day == 14,
          onChanged: changes.add,
        ),
      ),
    );
    await _open(tester);
    expect(focusedDate(), DateTime(2024, 2, 14));
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pumpAndSettle();
    expect(changes, isEmpty);
    expect(find.byType(RemixCalendar), findsOneWidget);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
    await tester.pumpAndSettle();
    expect(focusedDate(), DateTime(2024, 2, 15));
    await tester.sendKeyEvent(LogicalKeyboardKey.space);
    await tester.pumpAndSettle();
    expect(changes, [DateTime(2024, 2, 15)]);
  });

  testWidgets(
    'invalid external value remains named; focus follows clamped current day',
    (tester) async {
      await tester.pumpWidget(
        pickerHost(
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
      expect(focusedDate(), DateTime(2024, 2, 10));
    },
  );

  testWidgets(
    'repeated selected date requests once and closes despite rejecting parent',
    (tester) async {
      final changes = <DateTime>[];
      await tester.pumpWidget(
        pickerHost(
          _picker(value: DateTime(2024, 2, 14), onChanged: changes.add),
        ),
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
        pickerHost(_picker(focusNode: focus, onChanged: changes.add)),
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
          pickerHost(
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
        pickerHost(
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
      await tester.pumpWidget(pickerHost(const SizedBox()));
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
    await tester.pumpWidget(
      pickerHost(const Text('Host'), navigatorKey: navigator),
    );
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
    expect(focusInside(RemixSelect<int>), isTrue);
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
        pickerHost(
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
      await tester.pumpWidget(pickerHost(_picker()));
      await _open(tester);
      final dayNode = FocusManager.instance.primaryFocus;
      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pumpAndSettle();
      expect(FocusManager.instance.primaryFocus, isNot(dayNode));
      expect(focusInside(RemixCalendar), isTrue);
      await tester.sendKeyDownEvent(LogicalKeyboardKey.shiftLeft);
      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.sendKeyUpEvent(LogicalKeyboardKey.shiftLeft);
      await tester.pumpAndSettle();
      expect(FocusManager.instance.primaryFocus, dayNode);
      for (var i = 0; i < 12; i++) {
        await tester.sendKeyEvent(LogicalKeyboardKey.tab);
        await tester.pumpAndSettle();
        expect(focusInside(RemixCalendar), isTrue);
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
          pickerHost(
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
        expect(focusedDate(), DateTime(2024, 2, 29));
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
        expect(focusedDate(), DateTime(2024, 2, 22));
        expect(find.text('22').hitTestable(), findsOneWidget);
        await tester.sendKeyEvent(LogicalKeyboardKey.enter);
        await tester.pumpAndSettle();
        expect(changes, [DateTime(2024, 2, 22)]);
        expect(tester.takeException(), isNull);
      },
    );
  }

  testWidgets(
    'safe areas and keyboard overlap; an inset-only update re-fits the panel',
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
            return pickerHost(
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
      expect(find.byType(RemixCalendar), findsOneWidget);
      final refit = tester.getRect(find.byType(RemixCalendar));
      expect(refit.top, greaterThanOrEqualTo(38));
      expect(refit.bottom, lessThanOrEqualTo(192));
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
        pickerHost(
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
        expect(focusInside(RemixSelect<int>), isTrue);
        expect(find.byType(RemixCalendar), findsOneWidget);
      }
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('safe-area changes consumed by SafeArea re-fit the open picker', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(800, 600);
    tester.view.padding = const FakeViewPadding(top: 80, bottom: 60);
    tester.view.viewPadding = const FakeViewPadding(top: 80, bottom: 60);
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      pickerHost(
        SafeArea(
          child: Align(alignment: Alignment.topCenter, child: _picker()),
        ),
      ),
    );
    await _open(tester);
    // The SafeArea above the anchor consumes this change; the panel is
    // placed in the Overlay, whose media still reports it.
    tester.view.padding = const FakeViewPadding(top: 140, bottom: 60);
    tester.view.viewPadding = const FakeViewPadding(top: 140, bottom: 60);
    await tester.pumpAndSettle();
    expect(find.byType(RemixCalendar), findsOneWidget);
    final panel = tester.getRect(find.byType(RemixCalendar));
    expect(panel.top, greaterThanOrEqualTo(148));
    expect(panel.bottom, lessThanOrEqualTo(532));
    expect(tester.takeException(), isNull);
  });

  for (final side in [OverlaySide.left, OverlaySide.right]) {
    testWidgets(
      '$side picker honors top and bottom safe bounds without changing legacy height behavior',
      (tester) async {
        tester.view.devicePixelRatio = 1;
        tester.view.physicalSize = const Size(500, 350);
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        await tester.pumpWidget(
          pickerHost(
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
          pickerHost(
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
        pickerHost(
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
