import 'dart:ui' show SemanticsRole, Tristate;

import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart' show LogicalKeyboardKey;
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/remix.dart';

import '../helpers/test_helpers.dart';

/// Stands in for a screen-reader pass: what the platform would announce for
/// each overlay with a panel transition running.
const _duration = Duration(milliseconds: 200);

RemixPanelTransition _fade() => RemixPanelTransition(
  duration: _duration,
  builder: (context, info, panel) =>
      FadeTransition(opacity: info.animation, child: panel),
);

final class _Node {
  _Node(SemanticsData data)
    : label = data.label,
      role = data.role,
      expanded = data.flagsCollection.isExpanded,
      isButton = data.flagsCollection.isButton;

  final String label;
  final SemanticsRole role;
  final Tristate expanded;
  final bool isButton;
}

List<_Node> _nodes(WidgetTester tester) {
  final nodes = <_Node>[];
  void walk(SemanticsNode node) {
    nodes.add(_Node(node.getSemanticsData()));
    node.visitChildren((child) {
      walk(child);
      return true;
    });
  }

  // ignore: deprecated_member_use
  walk(tester.binding.pipelineOwner.semanticsOwner!.rootSemanticsNode!);
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
  SemanticsRole? contentRole,
  SemanticsRole? panelRole,
}) async {
  final handle = tester.ensureSemantics();
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
  expect(_announces(tester, content), isTrue);

  await tester.sendKeyEvent(LogicalKeyboardKey.escape);
  await tester.pump();
  await tester.pump(_duration ~/ 2);
  // Mid-exit: the panel is still held, so it is still announced.
  expect(_announces(tester, content), isTrue);

  await tester.pump(_duration * 2);
  expect(_announces(tester, content), isFalse);
  expect(_byLabel(tester, trigger).expanded, Tristate.isFalse);
  handle.dispose();
}

void main() {
  group('panel transition semantics', () {
    testWidgets('menu', (tester) async {
      await _runs(
        tester,
        overlay: RemixMenu<String>(
          trigger: const RemixMenuTrigger(label: 'Options'),
          items: const [RemixMenuItem(value: 'copy', label: 'Copy')],
          style: MenuStyler().panelTransition(_fade()),
        ),
        trigger: 'Options',
        content: 'Copy',
        contentRole: SemanticsRole.menuItem,
        panelRole: SemanticsRole.menu,
      );
    });

    testWidgets('popover', (tester) async {
      await _runs(
        tester,
        overlay: RemixPopover(
          popoverChild: const Text('Popover content'),
          style: PopoverStyler().panelTransition(_fade()),
          child: const Text('Open popover'),
        ),
        trigger: 'Open popover',
        content: 'Popover content',
      );
    });

    testWidgets('select', (tester) async {
      await _runs(
        tester,
        overlay: RemixSelect<String>(
          onChanged: (_) {},
          trigger: const RemixSelectTrigger(placeholder: 'Choose'),
          items: const [RemixSelectItem(value: 'a', label: 'Alpha')],
          style: SelectStyler().panelTransition(_fade()),
        ),
        trigger: 'Choose',
        content: 'Alpha',
        contentRole: SemanticsRole.menuItem,
        panelRole: SemanticsRole.menu,
      );
    });
  });
}
