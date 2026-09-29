import 'dart:ui' show Tristate;

import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:naked_ui/naked_ui.dart';

import 'semantics_test_utils.dart';

void main() {
  testWidgets('exposes a text field and a list of options', (tester) async {
    final handle = tester.ensureSemantics();
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: NakedCombobox<String>(
            semanticLabel: 'Fruit',
            optionsBuilder: (value) => ['apple', 'banana'],
            fieldBuilder: (context, state, controller, focusNode, submit) {
              return TextField(
                controller: controller,
                focusNode: focusNode,
                onSubmitted: (_) => submit(),
              );
            },
            overlayBuilder: (context, options) {
              return const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  NakedComboboxOption(value: 'apple', child: Text('apple')),
                  NakedComboboxOption(value: 'banana', child: Text('banana')),
                ],
              );
            },
          ),
        ),
      ),
    );

    expect(find.bySemanticsLabel('Fruit'), findsWidgets);

    await tester.tap(find.byType(TextField));
    await tester.enterText(find.byType(TextField), 'a');
    await tester.pump();
    await tester.pump();

    SemanticsNode? nodeWithLabel(String label) => findSemanticsNode(
      semanticsRootOf(tester),
      (node) => node.getSemanticsData().label == label,
    );
    SemanticsNode? listNode() => findSemanticsNode(
      semanticsRootOf(tester),
      (node) => node.getSemanticsData().role == SemanticsRole.list,
    );

    expect(listNode(), isNotNull);
    final apple = nodeWithLabel('apple');
    final banana = nodeWithLabel('banana');
    expect(apple, isNotNull);
    expect(banana, isNotNull);
    expect(apple!.getSemanticsData().flagsCollection.isButton, isTrue);
    expect(banana!.getSemanticsData().flagsCollection.isButton, isTrue);
    expectNoNestedSemanticsNodes(
      semanticsRootOf(tester),
      predicate: (node) => node.getSemanticsData().role == SemanticsRole.list,
      debugName: 'list',
    );

    // Selecting closes the options view.
    await tester.tap(find.text('apple'));
    await tester.pump();
    await tester.pump();
    expect(listNode(), isNull);
    expect(nodeWithLabel('apple'), isNull);

    // Refocusing reopens it with the selection still applied.
    FocusManager.instance.primaryFocus?.unfocus();
    await tester.pump();
    await tester.tap(find.byType(TextField));
    await tester.pump();
    await tester.pump();
    expect(listNode(), isNotNull);
    Tristate selectedOf(String label) =>
        nodeWithLabel(label)!.getSemanticsData().flagsCollection.isSelected;
    expect(selectedOf('apple'), Tristate.isTrue);
    expect(selectedOf('banana'), isNot(Tristate.isTrue));

    handle.dispose();
  });

  testWidgets('excludeSemantics hides the combobox', (tester) async {
    final handle = tester.ensureSemantics();
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: NakedCombobox<String>(
            excludeSemantics: true,
            semanticLabel: 'Fruit',
            optionsBuilder: _options,
            fieldBuilder: _field,
            overlayBuilder: _overlay,
          ),
        ),
      ),
    );

    expect(find.bySemanticsLabel('Fruit'), findsNothing);
    handle.dispose();
  });
}

Future<Iterable<String>> _options(TextEditingValue value) async => ['apple'];

Widget _field(
  BuildContext context,
  NakedComboboxState<String> state,
  TextEditingController controller,
  FocusNode focusNode,
  VoidCallback submit,
) {
  return TextField(controller: controller, focusNode: focusNode);
}

Widget _overlay(BuildContext context, Iterable<String> options) {
  return const NakedComboboxOption(value: 'apple', child: Text('apple'));
}
