import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:naked_ui/naked_ui.dart';

import '../test_helpers.dart';

// Contracts from the 1.2.0 select/popover audit
// (2026-10-07-naked-ui-audit-select-popover.md). Several depend on
// RawMenuAnchor details that differ between Flutter 3.41, 3.44, and 3.47, so
// run this file on the 3.41 floor as well as the pinned SDK.
void main() {
  NakedSelect<String> select({
    bool? open,
    ValueChanged<bool>? onOpenChanged,
    ValueChanged<String?>? onChanged,
    bool enabled = true,
    bool closeOnClickOutside = true,
    FocusNode? triggerFocusNode,
  }) => NakedSelect<String>(
    open: open,
    onOpenChanged: onOpenChanged,
    onChanged: onChanged ?? (_) {},
    enabled: enabled,
    closeOnClickOutside: closeOnClickOutside,
    triggerFocusNode: triggerFocusNode,
    builder: (context, state, child) => const Text('Fruit'),
    overlayBuilder: (context, info) => const Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        NakedSelectOption<String>(value: 'apple', child: Text('Apple')),
        NakedSelectOption<String>(value: 'banana', child: Text('Banana')),
        NakedSelectOption<String>(value: 'orange', child: Text('Orange')),
      ],
    ),
  );

  /// A select whose owner accepts every request. The owner's state lives
  /// outside any builder, so overlay rebuilds cannot reset it.
  Widget owned(
    _Owner owner, {
    bool enabled = true,
    FocusNode? triggerFocusNode,
  }) => StatefulBuilder(
    builder: (context, setState) => select(
      open: owner.open,
      enabled: enabled,
      triggerFocusNode: triggerFocusNode,
      onOpenChanged: (value) {
        owner.requests.add(value);
        setState(() => owner.open = value);
      },
    ),
  );

  group('controlled NakedSelect nested in a popover', () {
    // RawMenuAnchor delivers close requests to anchors that are not open on
    // Flutter 3.41 and 3.47 (3.44 guards them).
    testWidgets('opens when the owner accepts the request', (tester) async {
      final owner = _Owner(open: false);
      await tester.pumpMaterialWidget(
        Center(
          child: NakedPopover(
            popoverBuilder: (context, info) => owned(owner),
            child: const Text('Open popover'),
          ),
        ),
      );
      await tester.tap(find.text('Open popover'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Fruit'));
      await tester.pumpAndSettle();

      expect(owner.requests, [true]);
      expect(find.text('Apple'), findsOneWidget);
    });

    testWidgets('starts open when the owner says so', (tester) async {
      final owner = _Owner(open: true);
      await tester.pumpMaterialWidget(
        Center(
          child: NakedPopover(
            popoverBuilder: (context, info) => owned(owner),
            child: const Text('Open popover'),
          ),
        ),
      );
      await tester.tap(find.text('Open popover'));
      await tester.pumpAndSettle();

      expect(owner.requests, isEmpty);
      expect(find.text('Apple'), findsOneWidget);
    });

    testWidgets('Escape on its closed trigger dismisses the popover', (
      tester,
    ) async {
      final triggerFocusNode = FocusNode();
      addTearDown(triggerFocusNode.dispose);
      await tester.pumpMaterialWidget(
        Center(
          child: NakedPopover(
            popoverBuilder: (context, info) => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Popover content'),
                select(triggerFocusNode: triggerFocusNode),
              ],
            ),
            child: const Text('Open popover'),
          ),
        ),
      );
      await tester.tap(find.text('Open popover'));
      await tester.pumpAndSettle();
      triggerFocusNode.requestFocus();
      await tester.pump();

      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();

      expect(find.text('Popover content'), findsNothing);
    });
  });

  group('controlled NakedSelect requests', () {
    testWidgets('owner-driven changes are not echoed', (tester) async {
      final owner = _Owner(open: false);
      late StateSetter setHostState;
      await tester.pumpMaterialWidget(
        Center(
          child: StatefulBuilder(
            builder: (context, setState) {
              setHostState = setState;
              return owned(owner);
            },
          ),
        ),
      );

      setHostState(() => owner.open = true);
      await tester.pumpAndSettle();
      expect(find.text('Apple'), findsOneWidget);
      setHostState(() => owner.open = false);
      await tester.pumpAndSettle();
      expect(find.text('Apple'), findsNothing);

      expect(owner.requests, isEmpty);
    });

    testWidgets('Escape in the overlay and outside taps request close', (
      tester,
    ) async {
      final requests = <bool>[];
      await tester.pumpMaterialWidget(
        Center(child: select(open: true, onOpenChanged: requests.add)),
      );
      await tester.pumpAndSettle();

      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pump();
      expect(requests, [false]);
      expect(find.text('Apple'), findsOneWidget);

      await tester.tapAt(const Offset(5, 5));
      await tester.pump();
      expect(requests, [false, false]);
      expect(find.text('Apple'), findsOneWidget);
    });

    testWidgets('an accepted Escape closes and returns focus to the trigger', (
      tester,
    ) async {
      final owner = _Owner(open: true);
      final triggerFocusNode = FocusNode();
      addTearDown(triggerFocusNode.dispose);
      await tester.pumpMaterialWidget(
        Center(child: owned(owner, triggerFocusNode: triggerFocusNode)),
      );
      await tester.pumpAndSettle();

      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();

      expect(owner.requests, [false]);
      expect(find.text('Apple'), findsNothing);
      expect(triggerFocusNode.hasFocus, isTrue);
    });

    testWidgets('a view resize requests close', (tester) async {
      final requests = <bool>[];
      await tester.pumpMaterialWidget(
        Center(child: select(open: true, onOpenChanged: requests.add)),
      );
      await tester.pumpAndSettle();
      addTearDown(tester.view.reset);

      tester.view.physicalSize = tester.view.physicalSize * 0.9;
      await tester.pumpAndSettle();

      expect(requests, [false]);
      expect(find.text('Apple'), findsOneWidget);
    });

    testWidgets('a disabled select stays closed and does not request', (
      tester,
    ) async {
      final requests = <bool>[];
      await tester.pumpMaterialWidget(
        Center(
          child: select(
            open: true,
            enabled: false,
            onOpenChanged: requests.add,
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Apple'), findsNothing);

      await tester.tap(find.text('Fruit'));
      await tester.pumpAndSettle();
      expect(requests, isEmpty);
      expect(find.text('Apple'), findsNothing);
    });

    testWidgets('disabling an open select closes it', (tester) async {
      var enabled = true;
      late StateSetter setHostState;
      await tester.pumpMaterialWidget(
        Center(
          child: StatefulBuilder(
            builder: (context, setState) {
              setHostState = setState;
              return select(open: true, enabled: enabled);
            },
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Apple'), findsOneWidget);

      setHostState(() => enabled = false);
      await tester.pumpAndSettle();
      expect(find.text('Apple'), findsNothing);
    });
  });

  group('uncontrolled NakedSelect', () {
    testWidgets('closeOnClickOutside: false ignores outside taps', (
      tester,
    ) async {
      await tester.pumpMaterialWidget(
        Center(child: select(closeOnClickOutside: false)),
      );
      await tester.tap(find.text('Fruit'));
      await tester.pumpAndSettle();

      await tester.tapAt(const Offset(5, 5));
      await tester.pumpAndSettle();
      expect(find.text('Apple'), findsOneWidget);

      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();
      expect(find.text('Apple'), findsNothing);
    });

    for (final (key, expected) in [
      (LogicalKeyboardKey.end, 'orange'),
      (LogicalKeyboardKey.home, 'apple'),
    ]) {
      testWidgets('${key.keyLabel} focuses the edge option', (tester) async {
        String? chosen;
        await tester.pumpMaterialWidget(
          Center(child: select(onChanged: (value) => chosen = value)),
        );
        await tester.tap(find.text('Fruit'));
        await tester.pumpAndSettle();
        // Start away from both edges.
        await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
        await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
        await tester.pump();

        await tester.sendKeyEvent(key);
        await tester.pump();
        await tester.sendKeyEvent(LogicalKeyboardKey.enter);
        await tester.pumpAndSettle();

        expect(chosen, expected);
      });
    }
  });
}

class _Owner {
  _Owner({required this.open});

  bool open;
  final requests = <bool>[];
}
