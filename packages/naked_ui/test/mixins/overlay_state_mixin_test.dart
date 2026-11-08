import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:naked_ui/src/base/overlay_base.dart';

import '../helpers/focus_request_counter.dart';

class _Host extends StatefulWidget {
  const _Host({required this.trigger, required this.attachPanel});

  final FocusNode trigger;
  final bool attachPanel;

  @override
  State<_Host> createState() => _HostState();
}

class _HostState extends State<_Host> with OverlayStateMixin<_Host> {
  void close() => handleClose(triggerFocusNode: widget.trigger);

  @override
  Widget build(BuildContext context) {
    return widget.attachPanel
        ? KeyedSubtree(key: overlayContentKey, child: const SizedBox())
        : const SizedBox();
  }
}

void main() {
  group('OverlayStateMixin.handleClose', () {
    testWidgets('does not restore when the panel is already gone and focus '
        'sits elsewhere', (tester) async {
      final trigger = FocusRequestCounter(debugLabel: 'trigger');
      final field = FocusNode(debugLabel: 'field');
      addTearDown(trigger.dispose);
      addTearDown(field.dispose);
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                TextField(focusNode: field),
                _Host(trigger: trigger, attachPanel: false),
              ],
            ),
          ),
        ),
      );
      field.requestFocus();
      await tester.pump();

      tester.state<_HostState>(find.byType(_Host)).close();
      await tester.pump();

      expect(tester.takeException(), isNull);
      expect(trigger.requestCount, 0);
      expect(field.hasPrimaryFocus, isTrue);
    });
  });
}
