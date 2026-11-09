import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:naked_ui/naked_ui.dart';

typedef City = ({int id, String label});

class _EqualEntity {
  const _EqualEntity(this.id, this.label);

  final int id;
  final String label;

  @override
  bool operator ==(Object other) => other is _EqualEntity && other.id == id;

  @override
  int get hashCode => id.hashCode;
}

class _Host<T extends Object> extends StatefulWidget {
  const _Host({
    super.key,
    required this.optionsBuilder,
    this.display = RawAutocomplete.defaultStringForOption,
    this.clearOnSelected = false,
  });
  final AutocompleteOptionsBuilder<T> optionsBuilder;
  final String Function(T) display;
  final bool clearOnSelected;
  @override
  State<_Host<T>> createState() => _HostState<T>();
}

class _HostState<T extends Object> extends State<_Host<T>> {
  final controllers = <TextEditingController>[];
  final focuses = <FocusNode>[];
  late TextEditingController controller;
  late FocusNode focus;
  final selected = <T>[];
  final rows = <NakedComboboxOptionState<T>>[];
  late VoidCallback submit;
  late NakedComboboxState<T> snapshot;
  bool enabled = true;
  @override
  void initState() {
    super.initState();
    _newEditor(const TextEditingValue());
  }

  void _newEditor(TextEditingValue value) {
    controller = TextEditingController.fromValue(value);
    focus = FocusNode();
    controllers.add(controller);
    focuses.add(focus);
  }

  void replace(String text) => setState(
    () => _newEditor(
      TextEditingValue(
        text: text,
        selection: TextSelection.collapsed(offset: text.length),
      ),
    ),
  );
  void enable(bool next) => setState(() => enabled = next);
  @override
  void dispose() {
    for (final controller in controllers) {
      controller.dispose();
    }
    for (final focus in focuses) {
      focus.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
    builder: (context, child) => MediaQuery(
      data: MediaQuery.of(context).copyWith(supportsAnnounce: true),
      child: child!,
    ),
    home: Scaffold(
      body: Center(
        child: SizedBox(
          width: 240,
          child: NakedCombobox<T>(
            enabled: enabled,
            controller: controller,
            focusNode: focus,
            displayStringForOption: widget.display,
            optionsBuilder: widget.optionsBuilder,
            onSelected: (value) {
              selected.add(value);
              if (widget.clearOnSelected) controller.clear();
            },
            fieldBuilder: (_, state, controller, focus, onSubmit) {
              snapshot = state;
              submit = onSubmit;
              return TextField(
                controller: controller,
                focusNode: focus,
                onSubmitted: (_) => onSubmit(),
              );
            },
            overlayBuilder: (_, options) {
              rows.clear();
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (final (index, option) in options.indexed)
                      NakedComboboxOption<T>(
                        key: ValueKey(index),
                        value: option,
                        builder: (_, state, _) {
                          rows.add(state);
                          return SizedBox(
                            height: 48,
                            child: Text(widget.display(option)),
                          );
                        },
                      ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    ),
  );
}

Future<_HostState<T>> _pump<T extends Object>(
  WidgetTester tester,
  _Host<T> host,
) async {
  await tester.pumpWidget(host);
  return tester.state<_HostState<T>>(find.byType(_Host<T>));
}

Future<void> _type(WidgetTester tester, String text) async {
  await tester.enterText(find.byType(TextField), text);
  await tester.pumpAndSettle();
}

void main() {
  for (final replaceController in [true, false]) {
    testWidgets(
      'previous query reopens options after ${replaceController ? 'controller replacement' : 'disabled edit'}',
      (tester) async {
        final host = await _pump(
          tester,
          _Host<String>(
            optionsBuilder: (query) => query.text == 'a' ? ['Apple'] : [],
          ),
        );
        await _type(tester, 'a');
        expect(find.text('Apple'), findsOneWidget);

        if (replaceController) {
          host.replace('');
          await tester.pumpAndSettle();
        } else {
          host.enable(false);
          await tester.pumpAndSettle();
          await _type(tester, '');
          host.enable(true);
          await tester.pumpAndSettle();
        }

        host.focus.unfocus();
        await tester.pump();
        host.focus.requestFocus();
        await tester.pumpAndSettle();
        host.controller.selection = const TextSelection.collapsed(offset: 0);
        await tester.pumpAndSettle();
        expect(find.byType(NakedComboboxOption<String>), findsNothing);
        host.submit();
        expect(host.selected, isEmpty);

        await _type(tester, 'a');
        expect(find.text('Apple'), findsOneWidget);
        await tester.tap(find.text('Apple'));
        await tester.pumpAndSettle();
        expect(host.selected, ['Apple']);
      },
    );
  }

  testWidgets('a still-selected entity retains Raw repeat-selection equality', (
    tester,
  ) async {
    final host = await _pump(
      tester,
      _Host<String>(optionsBuilder: (_) => ['Apple']),
    );
    await _type(tester, 'ap');
    await tester.tap(find.text('Apple'));
    await tester.pumpAndSettle();
    expect(host.selected, ['Apple']);
    host.focus.unfocus();
    await tester.pump();
    host.focus.requestFocus();
    await tester.pumpAndSettle();
    host.submit();
    await tester.pumpAndSettle();
    expect(host.selected, ['Apple']);
    expect(host.snapshot.value, 'Apple');
  });

  testWidgets(
    'selecting a different cached option retains repeat-selection equality',
    (tester) async {
      final host = await _pump(
        tester,
        _Host<String>(optionsBuilder: (_) => ['Apple', 'Banana']),
      );
      await _type(tester, 'a');
      await tester.tap(find.text('Apple'));
      await tester.pumpAndSettle();
      expect(host.selected, ['Apple']);

      // Reopen Raw's retained results without editing away the first value.
      host.focus.unfocus();
      await tester.pump();
      host.focus.requestFocus();
      await tester.pumpAndSettle();
      expect(host.snapshot.value, 'Apple');
      await tester.tap(find.text('Banana'));
      await tester.pumpAndSettle();
      expect(host.selected, ['Apple', 'Banana']);
      expect(host.snapshot.value, 'Banana');

      host.focus.unfocus();
      await tester.pump();
      host.focus.requestFocus();
      await tester.pumpAndSettle();
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pumpAndSettle();
      expect(
        host.rows.where((row) => row.isHighlighted).map((row) => row.value),
        ['Banana'],
      );
      host.submit();
      await tester.pumpAndSettle();
      expect(host.selected, ['Apple', 'Banana']);
      expect(host.snapshot.value, 'Banana');
    },
  );

  testWidgets('replacement with valid caret suppresses resolved old results', (
    tester,
  ) async {
    final host = await _pump(
      tester,
      _Host<String>(
        optionsBuilder: (query) => query.text == 'old' ? ['Apple'] : ['Banana'],
      ),
    );
    await _type(tester, 'old');
    expect(find.text('Apple'), findsOneWidget);
    final oldController = host.controller, oldFocus = host.focus;
    host.replace('replacement');
    await tester.pumpAndSettle();
    host.focus.requestFocus();
    await tester.pumpAndSettle();
    expect(find.text('Apple'), findsNothing);
    host.submit();
    expect(host.selected, isEmpty);
    expect(host.controller.text, 'replacement');
    await _type(tester, 'fresh');
    await tester.tap(find.text('Banana'));
    await tester.pumpAndSettle();
    expect(host.selected, ['Banana']);
    oldController.text = 'still owned';
    oldFocus.requestFocus();
    await tester.pumpAndSettle();
    expect(host.controller.text, 'Banana');
    expect(tester.takeException(), isNull);
  });
  testWidgets('disabled edits stay silent and cannot revive old options', (
    tester,
  ) async {
    final messages = <String>[];
    tester.binding.defaultBinaryMessenger.setMockDecodedMessageHandler(
      SystemChannels.accessibility,
      (message) async {
        if (message is Map && message['type'] == 'announce')
          messages.add((message['data'] as Map)['message'] as String);
        return null;
      },
    );
    addTearDown(
      () => tester.binding.defaultBinaryMessenger.setMockDecodedMessageHandler(
        SystemChannels.accessibility,
        null,
      ),
    );
    var calls = 0;
    final host = await _pump(
      tester,
      _Host<String>(
        optionsBuilder: (query) {
          calls++;
          return query.text == 'empty' ? [] : ['Apple'];
        },
      ),
    );
    await _type(tester, 'old');
    final labels = WidgetsLocalizations.of(
      tester.element(find.byType(TextField)),
    );
    expect(messages, [labels.searchResultsFound]);
    host.enable(false);
    await tester.pumpAndSettle();
    messages.clear();
    final previousCalls = calls;
    final controller = host.controller, focus = host.focus;
    await _type(tester, 'disabled edit');
    expect(calls, previousCalls);
    expect(messages, isEmpty);
    expect(host.controller, same(controller));
    expect(host.focus, same(focus));
    expect(focus.hasFocus, isTrue);
    host.enable(true);
    await tester.pumpAndSettle();
    focus.unfocus();
    await tester.pump();
    focus.requestFocus();
    await tester.pumpAndSettle();
    expect(find.byType(NakedComboboxOption<String>), findsNothing);
    host.submit();
    expect(host.selected, isEmpty);
    await _type(tester, 'empty');
    expect(messages, [labels.noResultsFound]);
    messages.clear();
    await _type(tester, 'fresh');
    expect(messages, [labels.searchResultsFound]);
    await tester.tap(find.text('Apple'));
    await tester.pumpAndSettle();
    expect(host.selected, ['Apple']);
  });
  for (final asynchronous in [false, true]) {
    testWidgets(
      '${asynchronous ? 'Future' : 'synchronous'} requery cannot survive same-event cached acceptance',
      (tester) async {
        final pending = Completer<Iterable<String>>();
        final host = await _pump(
          tester,
          _Host<String>(
            optionsBuilder: (query) => query.text == 'new'
                ? (asynchronous ? pending.future : ['Banana'])
                : ['Apple'],
          ),
        );
        await _type(tester, 'old');
        host.controller.text = 'new';
        host.submit();
        if (asynchronous) pending.complete(['Banana']);
        await tester.pumpAndSettle();
        expect(host.selected, ['Apple']);
        expect(host.controller.text, 'Apple');
        expect(find.byType(NakedComboboxOption<String>), findsNothing);
        await _type(tester, 'fresh');
        expect(find.text('Apple'), findsOneWidget);
      },
    );
  }
  for (final keyboard in [false, true]) {
    testWidgets(
      'callback clear permits whole-query ${keyboard ? 'keyboard' : 'pointer'} reacceptance',
      (tester) async {
        final host = await _pump(
          tester,
          _Host<String>(
            optionsBuilder: (_) => ['Apple'],
            clearOnSelected: true,
          ),
        );
        await _type(tester, 'ap');
        await tester.tap(find.text('Apple'));
        await tester.pumpAndSettle();
        expect(host.selected, ['Apple']);
        expect(host.controller.text, isEmpty);
        final editor = tester.state(find.byType(EditableText));
        final controller = host.controller, focus = host.focus;
        await _type(tester, 'Apple');
        // Raw's public navigation opens its current cache on either supported SDK.
        await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
        await tester.pumpAndSettle();
        if (keyboard) {
          host.submit();
        } else {
          await tester.tap(find.text('Apple').last);
        }
        await tester.pumpAndSettle();
        expect(host.selected, ['Apple', 'Apple']);
        expect(host.controller.text, isEmpty);
        expect(host.snapshot.value, isNull);
        expect(host.controller, same(controller));
        expect(host.focus, same(focus));
        expect(tester.state(find.byType(EditableText)), same(editor));
      },
    );
  }
  testWidgets('equal suggestions retain one value and one highlight', (
    tester,
  ) async {
    final host = await _pump(
      tester,
      _Host<String>(optionsBuilder: (_) => ['Apple', 'Apple', 'Banana']),
    );
    await _type(tester, 'a');
    expect(find.text('Apple'), findsOneWidget);
    expect(
      host.rows.where((row) => row.isHighlighted).map((row) => row.value),
      ['Apple'],
    );
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.pumpAndSettle();
    expect(
      host.rows.where((row) => row.isHighlighted).map((row) => row.value),
      ['Banana'],
    );
    host.submit();
    await tester.pumpAndSettle();
    expect(host.selected, ['Banana']);
  });
  testWidgets('identity-set suggestions retain the first equal entity', (
    tester,
  ) async {
    const first = _EqualEntity(1, 'First');
    const second = _EqualEntity(1, 'Second');
    final options = Set<_EqualEntity>.identity()
      ..add(first)
      ..add(second);
    expect(options, hasLength(2));
    expect(first, equals(second));
    expect(identical(first, second), isFalse);

    final host = await _pump(
      tester,
      _Host<_EqualEntity>(
        display: (entity) => entity.label,
        optionsBuilder: (_) => options,
      ),
    );
    await _type(tester, 'f');
    expect(find.text('First'), findsOneWidget);
    expect(find.text('Second'), findsNothing);
    expect(host.rows, hasLength(1));
    expect(host.rows.single.value, same(first));
    expect(host.rows.single.isHighlighted, isTrue);
    host.submit();
    await tester.pumpAndSettle();
    expect(host.selected, hasLength(1));
    expect(host.selected.single, same(first));
    expect(host.controller.text, 'First');
  });

  testWidgets(
    'unequal entities sharing display text stay independently selectable',
    (tester) async {
      final host = await _pump(
        tester,
        _Host<City>(
          display: (city) => city.label,
          optionsBuilder: (_) => [
            (id: 1, label: 'City'),
            (id: 2, label: 'City'),
          ],
        ),
      );
      await _type(tester, 'c');
      expect(find.text('City'), findsNWidgets(2));
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pumpAndSettle();
      host.submit();
      await tester.pumpAndSettle();
      expect(host.selected.single.id, 2);
    },
  );
}
