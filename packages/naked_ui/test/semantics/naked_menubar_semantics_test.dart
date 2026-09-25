import 'dart:ui' show Tristate;

import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:naked_ui/naked_ui.dart';

import 'semantics_test_utils.dart';

void main() {
  testWidgets('menu bar contains menu item triggers', (tester) async {
    final handle = tester.ensureSemantics();
    final file = MenuController();
    final edit = MenuController();
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: NakedMenubar(
            semanticLabel: 'Application',
            child: Row(
              children: [
                NakedMenu<String>(
                  controller: file,
                  semanticLabel: 'File',
                  builder: (context, state, child) => const Text('File'),
                  overlayBuilder: (context, info) => const Text('New'),
                ),
                NakedMenu<String>(
                  controller: edit,
                  semanticLabel: 'Edit',
                  builder: (context, state, child) => const Text('Edit'),
                  overlayBuilder: (context, info) => const Text('Copy'),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    final root = semanticsRootOf(tester);
    final bar = findSemanticsNode(
      root,
      (node) => node.getSemanticsData().role == SemanticsRole.menuBar,
    );
    expect(bar, isNotNull);
    expect(
      collectSemanticsNodes(
        root,
        (node) => node.getSemanticsData().role == SemanticsRole.menuItem,
      ),
      isNotEmpty,
    );

    await tester.tap(find.text('File'));
    await tester.pumpAndSettle();
    final openRoot = semanticsRootOf(tester);
    expect(
      findSemanticsNode(
        openRoot,
        (node) => node.getSemanticsData().role == SemanticsRole.menu,
      ),
      isNotNull,
    );

    bool isExpanded(SemanticsNode node) =>
        node.getSemanticsData().flagsCollection.isExpanded == Tristate.isTrue;
    final fileTrigger = findSemanticsNode(
      openRoot,
      (node) =>
          node.getSemanticsData().role == SemanticsRole.menuItem &&
          node.getSemanticsData().label.contains('File'),
    );
    final editTrigger = findSemanticsNode(
      openRoot,
      (node) =>
          node.getSemanticsData().role == SemanticsRole.menuItem &&
          node.getSemanticsData().label.contains('Edit'),
    );
    expect(fileTrigger, isNotNull);
    expect(editTrigger, isNotNull);
    expect(isExpanded(fileTrigger!), isTrue);
    expect(isExpanded(editTrigger!), isFalse);

    handle.dispose();
  });

  testWidgets('excludeSemantics hides the bar', (tester) async {
    final handle = tester.ensureSemantics();
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: NakedMenubar(
            excludeSemantics: true,
            semanticLabel: 'Application',
            child: NakedMenu<String>(
              controller: MenuController(),
              builder: (context, state, child) => const Text('File'),
              overlayBuilder: (context, info) => const Text('New'),
            ),
          ),
        ),
      ),
    );

    expect(find.bySemanticsLabel('Application'), findsNothing);
    handle.dispose();
  });
}
