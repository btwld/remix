import 'dart:async';

import 'package:flutter/material.dart';
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
                  child: TextField(controller: controller, focusNode: focusNode),
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
}
