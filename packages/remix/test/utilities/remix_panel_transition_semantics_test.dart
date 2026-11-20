import 'dart:ui' show SemanticsAction, SemanticsRole, Tristate;

import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart' show LogicalKeyboardKey;
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/remix.dart';

import '../helpers/test_helpers.dart';

const _duration = Duration(milliseconds: 200);

RemixPanelTransition _fade() => RemixPanelTransition(
  duration: _duration,
  builder: (context, info, panel) =>
      FadeTransition(opacity: info.animation, child: panel),
);

final class _Node {
  _Node(this.id, SemanticsData data)
    : canTap = data.hasAction(SemanticsAction.tap),
      label = data.label,
      role = data.role,
      expanded = data.flagsCollection.isExpanded,
      isButton = data.flagsCollection.isButton;

  final int id;
  final bool canTap;
  final String label;
  final SemanticsRole role;
  final Tristate expanded;
  final bool isButton;
}

SemanticsOwner _semantics(WidgetTester tester) {
  // ignore: deprecated_member_use
  return tester.binding.pipelineOwner.semanticsOwner!;
}

List<_Node> _nodes(WidgetTester tester) {
  final nodes = <_Node>[];
  void walk(SemanticsNode node) {
    nodes.add(_Node(node.id, node.getSemanticsData()));
    node.visitChildren((child) {
      walk(child);
      return true;
    });
  }

  walk(_semantics(tester).rootSemanticsNode!);
  return nodes;
}

_Node _byLabel(WidgetTester tester, String label, {SemanticsRole? role}) =>
    _nodes(tester).firstWhere(
      (node) => node.label == label && (role == null || node.role == role),
      orElse: () => throw TestFailure('no semantics node "$label"'),
    );

bool _announces(WidgetTester tester, String label) =>
    _nodes(tester).any((node) => node.label == label);

/// Opens with a tap, lets the open and the exit finish, and checks the
/// trigger's expanded state and the panel's labels at each stage.
Future<void> _runs(
  WidgetTester tester, {
  required Widget overlay,
  required String trigger,
  required String content,
  required FocusNode triggerFocus,
  required List<String> actions,
  SemanticsRole? contentRole,
  SemanticsRole? panelRole,
}) async {
  final handle = tester.ensureSemantics();
  try {
    await tester.pumpRemixApp(overlay);

    expect(_byLabel(tester, trigger).isButton, isTrue);
    expect(_byLabel(tester, trigger).expanded, Tristate.isFalse);
    expect(_announces(tester, content), isFalse);

    await tester.tap(find.text(trigger));
    await tester.pump();
    await tester.pump(_duration ~/ 2);
    // Mid-open: the panel is announced and the trigger says it is expanded.
    expect(_byLabel(tester, trigger).expanded, Tristate.isTrue);
    expect(_byLabel(tester, content, role: contentRole), isNotNull);
    if (panelRole != null) {
      expect(_nodes(tester).any((node) => node.role == panelRole), isTrue);
    }

    await tester.pump(_duration * 2);
    expect(_byLabel(tester, trigger).expanded, Tristate.isTrue);
    final contentNode = _byLabel(tester, content, role: contentRole);
    expect(contentNode.canTap, isTrue);

    if (contentRole == SemanticsRole.menuItem) {
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pump();
    }
    final focus = FocusManager.instance.primaryFocus!;
    expect(focus, isNot(triggerFocus));

    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    expect(actions, isEmpty);
    await tester.pump();
    await tester.pump(_duration ~/ 2);
    expect(find.text(content), findsOneWidget);
    expect(_announces(tester, content), isFalse);
    expect(focus.hasPrimaryFocus, isFalse);

    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.tap(find.text(content), warnIfMissed: false);
    _semantics(tester).performAction(contentNode.id, SemanticsAction.tap);
    expect(actions, isEmpty);

    await tester.pump(_duration * 2);
    expect(_announces(tester, content), isFalse);
    expect(_byLabel(tester, trigger).expanded, Tristate.isFalse);
    expect(triggerFocus.hasPrimaryFocus, isTrue);
  } finally {
    handle.dispose();
  }
}

void main() {
  group('panel transition semantics', () {
    testWidgets('menu', (tester) async {
      final triggerFocus = FocusNode();
      addTearDown(triggerFocus.dispose);
      final actions = <String>[];
      await _runs(
        tester,
        overlay: RemixMenu<String>(
          trigger: const RemixMenuTrigger(label: 'Options'),
          items: const [RemixMenuItem(value: 'copy', label: 'Copy')],
          style: MenuStyler().panelTransition(_fade()),
          triggerFocusNode: triggerFocus,
          onSelected: actions.add,
        ),
        trigger: 'Options',
        content: 'Copy',
        triggerFocus: triggerFocus,
        actions: actions,
        contentRole: SemanticsRole.menuItem,
        panelRole: SemanticsRole.menu,
      );
    });

    testWidgets('popover', (tester) async {
      final triggerFocus = FocusNode();
      final panelFocus = FocusNode();
      addTearDown(triggerFocus.dispose);
      addTearDown(panelFocus.dispose);
      final actions = <String>[];
      await _runs(
        tester,
        overlay: RemixPopover(
          popoverChild: TextButton(
            focusNode: panelFocus,
            onPressed: () => actions.add('activated'),
            child: const Text('Popover content'),
          ),
          triggerFocusNode: triggerFocus,
          initialFocusNode: panelFocus,
          style: PopoverStyler().panelTransition(_fade()),
          child: const Text('Open popover'),
        ),
        trigger: 'Open popover',
        content: 'Popover content',
        triggerFocus: triggerFocus,
        actions: actions,
      );
    });

    testWidgets('select', (tester) async {
      final triggerFocus = FocusNode();
      addTearDown(triggerFocus.dispose);
      final actions = <String>[];
      await _runs(
        tester,
        overlay: RemixSelect<String>(
          onChanged: (value) => actions.add(value!),
          focusNode: triggerFocus,
          trigger: const RemixSelectTrigger(placeholder: 'Choose'),
          items: const [RemixSelectItem(value: 'a', label: 'Alpha')],
          style: SelectStyler().panelTransition(_fade()),
        ),
        trigger: 'Choose',
        content: 'Alpha',
        triggerFocus: triggerFocus,
        actions: actions,
        contentRole: SemanticsRole.menuItem,
        panelRole: SemanticsRole.menu,
      );
    });
  });
}
