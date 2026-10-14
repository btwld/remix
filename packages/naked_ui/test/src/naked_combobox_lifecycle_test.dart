import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:naked_ui/naked_ui.dart';

// From the 1.2.0 combobox audit
// (2026-10-07-naked-ui-audit-dialog-combobox-radio.md). Flutter 3.41's
// RawAutocomplete uses its context after awaiting async options, so run this
// file on the 3.41 floor as well as the pinned SDK.
void main() {
  testWidgets('async options that finish after removal do not throw', (
    tester,
  ) async {
    final pending = Completer<Iterable<String>>();
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: NakedCombobox<String>(
            optionsBuilder: (value) =>
                value.text.isEmpty ? const <String>[] : pending.future,
            fieldBuilder: (context, state, controller, focusNode, submit) =>
                SizedBox(
                  width: 200,
                  child: TextField(
                    controller: controller,
                    focusNode: focusNode,
                  ),
                ),
            overlayBuilder: (context, options) => Column(
              mainAxisSize: MainAxisSize.min,
              children: [for (final option in options) Text(option)],
            ),
          ),
        ),
      ),
    );
    await tester.enterText(find.byType(TextField), 'a');
    await tester.pump();

    await tester.pumpWidget(const MaterialApp(home: SizedBox()));
    pending.complete(const ['apple']);
    await tester.pump();

    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'Tab from an open combobox advances focus to the next focusable widget and closes options',
    (tester) async {
      final nextFocus = FocusNode(debugLabel: 'next');
      addTearDown(nextFocus.dispose);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                NakedCombobox<String>(
                  optionsBuilder: (value) => value.text.isEmpty
                      ? const <String>[]
                      : const ['apple', 'apricot'],
                  fieldBuilder:
                      (context, state, controller, focusNode, submit) =>
                          SizedBox(
                            width: 200,
                            child: TextField(
                              controller: controller,
                              focusNode: focusNode,
                            ),
                          ),
                  overlayBuilder: (context, options) => Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      for (final option in options)
                        NakedComboboxOption<String>(
                          value: option,
                          child: Text(option),
                        ),
                    ],
                  ),
                ),
                TextButton(
                  focusNode: nextFocus,
                  onPressed: () {},
                  child: const Text('Next'),
                ),
              ],
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextField), 'a');
      await tester.pumpAndSettle();
      expect(find.text('apple'), findsOneWidget);

      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pumpAndSettle();

      expect(nextFocus.hasFocus, isTrue);
      expect(find.text('apple'), findsNothing);
    },
  );

  testWidgets(
    'tracks state.isOpen, rebuilds open overlay, and suppresses options when disabled',
    (tester) async {
      final isOpenSnapshots = <bool>[];
      var prefix = 'v1:';
      var enabled = true;
      late StateSetter setHostState;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                setHostState = setState;
                return NakedCombobox<String>(
                  enabled: enabled,
                  optionsBuilder: (value) =>
                      value.text.isEmpty ? const <String>[] : const ['apple'],
                  fieldBuilder:
                      (context, state, controller, focusNode, submit) {
                        isOpenSnapshots.add(state.isOpen);
                        return SizedBox(
                          width: 200,
                          child: TextField(
                            controller: controller,
                            focusNode: focusNode,
                          ),
                        );
                      },
                  overlayBuilder: (context, options) => Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      for (final option in options) Text('$prefix$option'),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      );

      expect(isOpenSnapshots.last, isFalse);

      await tester.enterText(find.byType(TextField), 'a');
      await tester.pumpAndSettle();
      expect(find.text('v1:apple'), findsOneWidget);
      expect(isOpenSnapshots.last, isTrue);

      setHostState(() => prefix = 'v2:');
      await tester.pumpAndSettle();
      expect(find.text('v2:apple'), findsOneWidget);

      setHostState(() => enabled = false);
      await tester.enterText(find.byType(TextField), 'ap');
      await tester.pumpAndSettle();
      expect(find.text('v2:apple'), findsNothing);
      expect(isOpenSnapshots.last, isFalse);
    },
  );
}
