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
  testWidgets('pending query cannot reopen options after acceptance', (
    tester,
  ) async {
    final pending = Completer<Iterable<String>>();
    final selected = <String>[];
    final key = GlobalKey<_ComboboxHostState>();
    await tester.pumpWidget(
      _ComboboxHost(
        key: key,
        optionsBuilder: (value) =>
            value.text == 'new' ? pending.future : ['apple'],
        onSelected: selected.add,
      ),
    );
    await tester.enterText(find.byType(TextField), 'old');
    await tester.pumpAndSettle();
    final controller = key.currentState!.fieldController!;
    controller.text = 'new';
    await tester.pump();
    await tester.tap(find.text('apple'));
    await tester.pumpAndSettle();
    pending.complete(['banana']);
    await tester.pumpAndSettle();
    expect(find.byType(NakedComboboxOption<String>), findsNothing);
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();
    expect(selected, ['apple']);
    expect(controller.text, 'apple');
    await tester.enterText(find.byType(TextField), 'again');
    await tester.pumpAndSettle();
    await tester.tap(find.text('apple'));
    await tester.pumpAndSettle();
    expect(selected, ['apple', 'apple']);
  });

  testWidgets('disabled cached options preserve native caret navigation', (
    tester,
  ) async {
    final key = GlobalKey<_ComboboxHostState>();
    await tester.pumpWidget(
      _ComboboxHost(key: key, optionsBuilder: (_) => ['apple', 'apricot']),
    );
    final host = key.currentState!;
    host.update(() => host.maxLines = 3);
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'first\nsecond');
    await tester.pumpAndSettle();
    final controller = host.fieldController!;
    controller.selection = const TextSelection.collapsed(offset: 0);
    host.update(() => host.enabled = false);
    await tester.pumpAndSettle();
    expect(find.byType(NakedComboboxOption<String>), findsNothing);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.pumpAndSettle();
    expect(controller.selection.baseOffset, greaterThan(0));
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowUp);
    await tester.pumpAndSettle();
    expect(controller.selection.baseOffset, 0);
    expect(controller.text, 'first\nsecond');
    expect(host.fieldFocus!.hasFocus, isTrue);
  });

  testWidgets('controller notifications cannot reenter selection', (
    tester,
  ) async {
    final selected = <String>[];
    final key = GlobalKey<_ComboboxHostState>();
    await tester.pumpWidget(
      _ComboboxHost(
        key: key,
        optionsBuilder: (_) => ['apple', 'apricot'],
        onSelected: selected.add,
      ),
    );
    await tester.enterText(find.byType(TextField), 'ap');
    await tester.pumpAndSettle();
    final host = key.currentState!;
    host.fieldController!.addListener(() {
      if (host.fieldController!.text == 'apricot') host.submit!();
    });
    await tester.tap(find.text('apricot'));
    await tester.pumpAndSettle();
    expect(selected, ['apricot']);
    expect(host.fieldController!.text, 'apricot');
    expect(host.snapshot!.value, 'apricot');
    expect(tester.takeException(), isNull);
  });

  for (final hardware in [false, true]) {
    testWidgets(
      'disable open cached options blocks ${hardware ? 'hardware' : 'IME'} submit before text writes',
      (tester) async {
        final selected = <String>[];
        final key = GlobalKey<_ComboboxHostState>();
        await tester.pumpWidget(
          _ComboboxHost(
            key: key,
            optionsBuilder: (_) => ['apple', 'apricot'],
            onSelected: selected.add,
          ),
        );
        await tester.enterText(find.byType(TextField), 'ap');
        await tester.pumpAndSettle();
        final host = key.currentState!;
        final controller = host.fieldController!;
        final focus = host.fieldFocus!;
        controller.selection = const TextSelection(
          baseOffset: 0,
          extentOffset: 2,
        );
        await tester.pumpAndSettle();
        final editingValue = controller.value;
        final unexpectedTextWrites = <String>[];
        controller.addListener(() {
          if (controller.text != editingValue.text) {
            unexpectedTextWrites.add(controller.text);
          }
        });
        host.update(() => host.enabled = false);
        await tester.pumpAndSettle();
        expect(controller.value, editingValue);
        expect(focus.hasFocus, isTrue);
        if (hardware) {
          await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
          await tester.sendKeyEvent(LogicalKeyboardKey.enter);
        }
        await tester.testTextInput.receiveAction(TextInputAction.done);
        await tester.pumpAndSettle();
        expect(controller.text, 'ap');
        expect(unexpectedTextWrites, isEmpty);
        expect(selected, isEmpty);
        expect(find.byType(NakedComboboxOption<String>), findsNothing);
        expect(host.snapshot!.isOpen, isFalse);

        // Cached results may be reused after re-enabling an unchanged query.
        host.update(() => host.enabled = true);
        focus.requestFocus();
        await tester.pumpAndSettle();
        await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
        await tester.pumpAndSettle();
        await tester.testTextInput.receiveAction(TextInputAction.done);
        await tester.pumpAndSettle();
        expect(selected, hasLength(1));
        expect(controller.text, selected.single);
        expect(tester.takeException(), isNull);
      },
    );
  }

  testWidgets(
    'disable suppresses options without losing composition or focus',
    (tester) async {
      final key = GlobalKey<_ComboboxHostState>();
      await tester.pumpWidget(
        _ComboboxHost(key: key, optionsBuilder: (_) => ['apple']),
      );
      await tester.enterText(find.byType(TextField), 'ap');
      await tester.pumpAndSettle();
      final host = key.currentState!;
      final controller = host.fieldController!;
      controller.value = const TextEditingValue(
        text: 'ap',
        selection: TextSelection.collapsed(offset: 2),
        composing: TextRange(start: 0, end: 2),
      );
      final before = controller.value;
      host.update(() => host.enabled = false);
      await tester.pumpAndSettle();
      expect(controller.value, before);
      expect(host.fieldController, same(controller));
      expect(host.fieldFocus!.hasFocus, isTrue);
      expect(find.byType(NakedComboboxOption<String>), findsNothing);
      expect(host.snapshot!.isOpen, isFalse);
    },
  );

  for (final finishWhileDisabled in [false, true]) {
    testWidgets(
      'pending results cannot cross disable and reenable (finish disabled: $finishWhileDisabled)',
      (tester) async {
        final pending = Completer<Iterable<String>>();
        final selected = <String>[];
        final key = GlobalKey<_ComboboxHostState>();
        await tester.pumpWidget(
          _ComboboxHost(
            key: key,
            optionsBuilder: (value) =>
                value.text == 'ap' ? pending.future : ['fresh'],
            onSelected: selected.add,
          ),
        );
        await tester.enterText(find.byType(TextField), 'ap');
        await tester.pump();
        final host = key.currentState!;
        host.update(() => host.enabled = false);
        await tester.pumpAndSettle();
        if (finishWhileDisabled) {
          pending.complete(['obsolete']);
          await tester.pumpAndSettle();
          expect(find.text('obsolete'), findsNothing);
        }
        host.update(() => host.enabled = true);
        await tester.pumpAndSettle();
        if (!finishWhileDisabled) {
          pending.complete(['obsolete']);
          await tester.pumpAndSettle();
        }
        expect(find.text('obsolete'), findsNothing);
        await tester.testTextInput.receiveAction(TextInputAction.done);
        await tester.pumpAndSettle();
        expect(selected, isEmpty);
        expect(host.fieldController!.text, 'ap');
        await tester.enterText(find.byType(TextField), 'new');
        await tester.pumpAndSettle();
        await tester.tap(find.text('fresh'));
        await tester.pumpAndSettle();
        expect(selected, ['fresh']);
        expect(tester.takeException(), isNull);
      },
    );
  }

  testWidgets('selection callback can remove the combobox', (tester) async {
    final selected = <String>[];
    final key = GlobalKey<_ComboboxHostState>();
    await tester.pumpWidget(
      _ComboboxHost(
        key: key,
        optionsBuilder: (_) => ['apple'],
        onSelected: (value) {
          selected.add(value);
          key.currentState!.update(() => key.currentState!.show = false);
        },
      ),
    );
    await tester.enterText(find.byType(TextField), 'ap');
    await tester.pumpAndSettle();
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();
    expect(find.byType(NakedCombobox<String>), findsNothing);
    expect(selected, ['apple']);
    expect(tester.takeException(), isNull);
  });

  testWidgets('selection callback cannot reenter submit for another option', (
    tester,
  ) async {
    final selected = <String>[];
    final key = GlobalKey<_ComboboxHostState>();
    await tester.pumpWidget(
      _ComboboxHost(
        key: key,
        optionsBuilder: (_) => ['apple', 'apricot'],
        onSelected: (value) {
          selected.add(value);
          key.currentState!.submit!();
        },
      ),
    );
    await tester.enterText(find.byType(TextField), 'ap');
    await tester.pumpAndSettle();
    // Pointer acceptance differs from Raw's current keyboard highlight (apple).
    await tester.tap(find.text('apricot'));
    await tester.pumpAndSettle();
    expect(selected, ['apricot']);
    expect(key.currentState!.fieldController!.text, 'apricot');
    expect(key.currentState!.snapshot!.value, 'apricot');
    expect(tester.takeException(), isNull);
  });

  testWidgets('paired ownership replacements detach adapter listeners', (
    tester,
  ) async {
    final controller = TextEditingController(text: 'external');
    final focus = FocusNode();
    final replacement = TextEditingController(text: 'replacement');
    final replacementFocus = FocusNode();
    addTearDown(controller.dispose);
    addTearDown(focus.dispose);
    addTearDown(replacement.dispose);
    addTearDown(replacementFocus.dispose);
    final key = GlobalKey<_ComboboxHostState>();
    await tester.pumpWidget(
      _ComboboxHost(key: key, optionsBuilder: (_) => const []),
    );
    final host = key.currentState!;
    await tester.enterText(find.byType(TextField), 'internal');
    await tester.pumpAndSettle();
    host.update(() {
      host.controller = controller;
      host.focus = focus;
    });
    await tester.pumpAndSettle();
    expect(host.fieldController, same(controller));
    expect(host.snapshot!.text, 'external');
    host.update(() {
      host.controller = replacement;
      host.focus = replacementFocus;
    });
    await tester.pumpAndSettle();
    controller.text = 'detached';
    focus.requestFocus();
    await tester.pumpAndSettle();
    expect(host.snapshot!.text, 'replacement');
    expect(host.fieldController, same(replacement));
    host.update(() {
      host.controller = null;
      host.focus = null;
    });
    await tester.pumpAndSettle();
    expect(host.fieldController, isNot(same(replacement)));
    replacement.text = 'still caller owned';
    replacementFocus.requestFocus();
    await tester.pumpAndSettle();
    expect(host.snapshot!.text, isNot('still caller owned'));
    expect(tester.takeException(), isNull);
  });

  testWidgets('selection callback can replace the controller and focus pair', (
    tester,
  ) async {
    final controller = TextEditingController(text: 'replacement');
    final focus = FocusNode();
    addTearDown(controller.dispose);
    addTearDown(focus.dispose);
    final selected = <String>[];
    final key = GlobalKey<_ComboboxHostState>();
    await tester.pumpWidget(
      _ComboboxHost(
        key: key,
        optionsBuilder: (_) => ['apple'],
        onSelected: (value) {
          selected.add(value);
          final host = key.currentState!;
          host.update(() {
            host.controller = controller;
            host.focus = focus;
          });
        },
      ),
    );
    await tester.enterText(find.byType(TextField), 'ap');
    await tester.pumpAndSettle();
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();
    expect(selected, ['apple']);
    expect(key.currentState!.snapshot!.value, isNull);
    expect(key.currentState!.snapshot!.text, 'replacement');
    controller.text = 'caller still owns this';
    await tester.pumpAndSettle();
    expect(key.currentState!.snapshot!.text, controller.text);
    expect(tester.takeException(), isNull);
  });

  testWidgets('display-string changes invalidate only the observed selection', (
    tester,
  ) async {
    final key = GlobalKey<_ComboboxHostState>();
    await tester.pumpWidget(
      _ComboboxHost(key: key, optionsBuilder: (_) => ['apple']),
    );
    await tester.enterText(find.byType(TextField), 'ap');
    await tester.pumpAndSettle();
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();
    final host = key.currentState!;
    expect(host.snapshot!.value, 'apple');
    host.update(() => host.displayString = (value) => value.toUpperCase());
    await tester.pumpAndSettle();
    expect(host.fieldController!.text, 'apple');
    expect(host.snapshot!.value, isNull);
    expect(tester.takeException(), isNull);
  });

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

class _ComboboxHost extends StatefulWidget {
  const _ComboboxHost({
    super.key,
    required this.optionsBuilder,
    this.onSelected,
  });

  final AutocompleteOptionsBuilder<String> optionsBuilder;
  final ValueChanged<String>? onSelected;

  @override
  State<_ComboboxHost> createState() => _ComboboxHostState();
}

class _ComboboxHostState extends State<_ComboboxHost> {
  bool enabled = true;
  int maxLines = 1;
  bool show = true;
  TextEditingController? controller;
  FocusNode? focus;
  TextEditingController? fieldController;
  FocusNode? fieldFocus;
  VoidCallback? submit;
  String Function(String) displayString = (value) => value;
  NakedComboboxState<String>? snapshot;

  void update(VoidCallback callback) => setState(callback);

  @override
  Widget build(BuildContext context) => MaterialApp(
    home: Scaffold(
      body: Center(
        child: show
            ? NakedCombobox<String>(
                enabled: enabled,
                controller: controller,
                focusNode: focus,
                optionsBuilder: widget.optionsBuilder,
                displayStringForOption: displayString,
                onSelected: widget.onSelected,
                fieldBuilder: (context, state, controller, focusNode, submit) {
                  snapshot = state;
                  fieldController = controller;
                  fieldFocus = focusNode;
                  this.submit = submit;
                  return SizedBox(
                    width: 200,
                    child: TextField(
                      controller: controller,
                      focusNode: focusNode,
                      maxLines: maxLines,
                      onSubmitted: (_) => submit(),
                    ),
                  );
                },
                overlayBuilder: (context, options) => Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (final option in options)
                      NakedComboboxOption(value: option, child: Text(option)),
                  ],
                ),
              )
            : const SizedBox(),
      ),
    ),
  );
}
