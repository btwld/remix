import 'dart:ui' show Tristate;

import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:naked_ui/naked_ui.dart';

class _Host extends StatefulWidget {
  const _Host({
    required this.initial,
    required this.proposals,
    this.accept = true,
    this.editable = true,
    this.enabled = true,
    this.readOnly = false,
    this.maxTags,
    this.duplicates = NakedTagInputDuplicates.rejectIgnoringCase,
    this.separators = const [','],
    this.duplicatesSeen,
    this.textDirection = TextDirection.ltr,
    this.onEscape,
  });

  final List<String> initial;
  final List<List<String>> proposals;
  final bool accept;
  final bool editable;
  final bool enabled;
  final bool readOnly;
  final int? maxTags;
  final NakedTagInputDuplicates duplicates;
  final List<String> separators;
  final List<int>? duplicatesSeen;
  final TextDirection textDirection;
  final VoidCallback? onEscape;

  @override
  State<_Host> createState() => _HostState();
}

class _HostState extends State<_Host> {
  late List<String> value = widget.initial;

  void replace(List<String> next) => setState(() => value = next);

  @override
  Widget build(BuildContext context) {
    return WidgetsApp(
      color: const Color(0xff000000),
      pageRouteBuilder: <T>(settings, builder) => PageRouteBuilder<T>(
        settings: settings,
        pageBuilder: (context, animation, secondaryAnimation) =>
            builder(context),
      ),
      home: Directionality(
        textDirection: widget.textDirection,
        child: Focus(
          canRequestFocus: false,
          onKeyEvent: (node, event) {
            if (event is! KeyDownEvent ||
                event.logicalKey != LogicalKeyboardKey.escape) {
              return KeyEventResult.ignored;
            }
            widget.onEscape?.call();
            return KeyEventResult.handled;
          },
          child: Column(
            children: [
              NakedTagInput(
                value: value,
                enabled: widget.enabled,
                readOnly: widget.readOnly,
                maxTags: widget.maxTags,
                duplicates: widget.duplicates,
                separators: widget.separators,
                onDuplicate: widget.duplicatesSeen?.add,
                onChanged: widget.editable
                    ? (next) {
                        widget.proposals.add(next);
                        if (widget.accept) setState(() => value = next);
                      }
                    : null,
                builder: (context, field) => Wrap(
                  children: [
                    for (final tag in field.tags)
                      NakedTagInputTag(
                        key: ValueKey('tag-${tag.index}'),
                        item: tag,
                        child: SizedBox(
                          width: 60,
                          height: 20,
                          child: Text(
                            tag.isPicked ? '[${tag.value}]' : tag.value,
                          ),
                        ),
                      ),
                    SizedBox(
                      width: 120,
                      child: NakedTextField(
                        controller: field.controller,
                        focusNode: field.focusNode,
                        enabled: field.enabled,
                        readOnly: field.readOnly,
                        onChanged: field.onChanged,
                        onEditingComplete: field.onEditingComplete,
                        semanticLabel: 'Topics',
                        builder: (context, state, editable) => editable,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                width: 10,
                height: 10,
                child: Focus(child: Text('after')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Finder get _editor => find.byType(EditableText);

TextEditingController _controller(WidgetTester tester) =>
    tester.widget<EditableText>(_editor).controller;

FocusNode _focus(WidgetTester tester) =>
    tester.widget<EditableText>(_editor).focusNode;

Future<void> _focusEditor(WidgetTester tester) async {
  _focus(tester).requestFocus();
  await tester.pump();
}

Future<void> _enter(WidgetTester tester, String text) async {
  await tester.enterText(_editor, text);
  await tester.pump();
}

Future<void> _submit(WidgetTester tester) async {
  await tester.testTextInput.receiveAction(TextInputAction.done);
  await tester.pump();
}

Future<void> _key(WidgetTester tester, LogicalKeyboardKey key) async {
  await tester.sendKeyEvent(key);
  await tester.pump();
}

List<String> _captureAnnouncements(WidgetTester tester) {
  final announcements = <String>[];
  tester.binding.defaultBinaryMessenger.setMockDecodedMessageHandler(
    SystemChannels.accessibility,
    (message) async {
      if (message is Map && message['type'] == 'announce') {
        announcements.add((message['data'] as Map)['message'] as String);
      }
      return null;
    },
  );
  addTearDown(
    () => tester.binding.defaultBinaryMessenger.setMockDecodedMessageHandler(
      SystemChannels.accessibility,
      null,
    ),
  );
  return announcements;
}

void main() {
  group('commit', () {
    testWidgets('Enter commits the trimmed draft once and keeps focus', (
      tester,
    ) async {
      final proposals = <List<String>>[];
      final announcements = _captureAnnouncements(tester);
      await tester.pumpWidget(
        _Host(initial: const ['a'], proposals: proposals),
      );
      await _focusEditor(tester);
      await _enter(tester, '  flutter ');
      await _submit(tester);

      expect(proposals, [
        ['a', 'flutter'],
      ]);
      expect(_controller(tester).text, isEmpty);
      expect(_focus(tester).hasFocus, isTrue);
      expect(find.text('flutter'), findsOneWidget);
      expect(announcements, ['Added flutter']);
    });

    testWidgets('Enter on a blank draft proposes nothing', (tester) async {
      final proposals = <List<String>>[];
      await tester.pumpWidget(_Host(initial: const [], proposals: proposals));
      await _focusEditor(tester);
      await _enter(tester, '   ');
      await _submit(tester);
      expect(proposals, isEmpty);
      expect(_focus(tester).hasFocus, isTrue);
    });

    testWidgets('a typed separator commits the text before it', (tester) async {
      final proposals = <List<String>>[];
      await tester.pumpWidget(_Host(initial: const [], proposals: proposals));
      await _focusEditor(tester);
      await _enter(tester, 'dart');
      await _enter(tester, 'dart,');
      expect(proposals, [
        ['dart'],
      ]);
      expect(_controller(tester).text, isEmpty);
    });

    testWidgets('pasted text splits at every separator in one proposal', (
      tester,
    ) async {
      final proposals = <List<String>>[];
      await tester.pumpWidget(
        _Host(
          initial: const [],
          proposals: proposals,
          separators: const [',', ';'],
        ),
      );
      await _focusEditor(tester);
      await _enter(tester, 'a, b;;c,d');
      expect(proposals, [
        ['a', 'b', 'c'],
      ]);
      expect(_controller(tester).text, 'd');
      expect(
        _controller(tester).selection,
        const TextSelection.collapsed(offset: 1),
      );
    });

    testWidgets('no separators means commas are text', (tester) async {
      final proposals = <List<String>>[];
      await tester.pumpWidget(
        _Host(initial: const [], proposals: proposals, separators: const []),
      );
      await _focusEditor(tester);
      await _enter(tester, 'a,b');
      expect(proposals, isEmpty);
      await _submit(tester);
      expect(proposals, [
        ['a,b'],
      ]);
    });

    testWidgets('focus loss commits the draft', (tester) async {
      final proposals = <List<String>>[];
      await tester.pumpWidget(_Host(initial: const [], proposals: proposals));
      await _focusEditor(tester);
      await _enter(tester, 'blur');
      _focus(tester).unfocus();
      await tester.pump();
      expect(proposals, [
        ['blur'],
      ]);
    });

    testWidgets('a declined proposal keeps the owner list', (tester) async {
      final proposals = <List<String>>[];
      await tester.pumpWidget(
        _Host(initial: const ['a'], proposals: proposals, accept: false),
      );
      await _focusEditor(tester);
      await _enter(tester, 'b');
      await _submit(tester);
      expect(proposals, [
        ['a', 'b'],
      ]);
      expect(find.text('b'), findsNothing);
      expect(find.text('a'), findsOneWidget);
    });
  });

  group('duplicates', () {
    testWidgets(
      'a case-insensitive duplicate is refused, announced, and reported',
      (tester) async {
        final proposals = <List<String>>[];
        final seen = <int>[];
        final announcements = _captureAnnouncements(tester);
        await tester.pumpWidget(
          _Host(
            initial: const ['x', 'React'],
            proposals: proposals,
            duplicatesSeen: seen,
          ),
        );
        await _focusEditor(tester);
        await _enter(tester, 'react');
        await _submit(tester);
        expect(proposals, isEmpty);
        expect(seen, [1]);
        expect(_controller(tester).text, 'react');
        expect(announcements, ['React is already added']);
      },
    );

    testWidgets('a duplicate before a typed separator keeps its text', (
      tester,
    ) async {
      final proposals = <List<String>>[];
      await tester.pumpWidget(
        _Host(initial: const ['a'], proposals: proposals),
      );
      await _focusEditor(tester);
      await _enter(tester, 'A,');
      expect(proposals, isEmpty);
      expect(_controller(tester).text, 'A');
    });

    testWidgets('exact policy accepts a different case', (tester) async {
      final proposals = <List<String>>[];
      await tester.pumpWidget(
        _Host(
          initial: const ['a'],
          proposals: proposals,
          duplicates: NakedTagInputDuplicates.reject,
        ),
      );
      await _focusEditor(tester);
      await _enter(tester, 'A');
      await _submit(tester);
      await _enter(tester, 'a');
      await _submit(tester);
      expect(proposals, [
        ['a', 'A'],
      ]);
    });

    testWidgets('allow policy accepts repeats', (tester) async {
      final proposals = <List<String>>[];
      await tester.pumpWidget(
        _Host(
          initial: const ['a'],
          proposals: proposals,
          duplicates: NakedTagInputDuplicates.allow,
        ),
      );
      await _focusEditor(tester);
      await _enter(tester, 'a');
      await _submit(tester);
      expect(proposals, [
        ['a', 'a'],
      ]);
    });
  });

  group('max tags', () {
    testWidgets('a full field refuses commits and keeps the draft', (
      tester,
    ) async {
      final proposals = <List<String>>[];
      await tester.pumpWidget(
        _Host(initial: const ['a', 'b'], proposals: proposals, maxTags: 2),
      );
      await _focusEditor(tester);
      await _enter(tester, 'c');
      await _submit(tester);
      expect(proposals, isEmpty);
      expect(_controller(tester).text, 'c');
    });

    testWidgets('a paste past the limit keeps the pieces that did not fit', (
      tester,
    ) async {
      final proposals = <List<String>>[];
      await tester.pumpWidget(
        _Host(initial: const ['a'], proposals: proposals, maxTags: 2),
      );
      await _focusEditor(tester);
      await _enter(tester, 'b,c,d');
      expect(proposals, [
        ['a', 'b'],
      ]);
      expect(_controller(tester).text, 'c,d');
    });
  });

  group('keyboard picking', () {
    testWidgets('Backspace at the start picks the last tag, then removes it', (
      tester,
    ) async {
      final proposals = <List<String>>[];
      final announcements = _captureAnnouncements(tester);
      await tester.pumpWidget(
        _Host(initial: const ['a', 'b'], proposals: proposals),
      );
      await _focusEditor(tester);
      await _key(tester, LogicalKeyboardKey.backspace);
      expect(find.text('[b]'), findsOneWidget);
      expect(proposals, isEmpty);
      expect(announcements, ['b selected. Press Backspace to remove it.']);

      await _key(tester, LogicalKeyboardKey.backspace);
      expect(proposals, [
        ['a'],
      ]);
      expect(find.text('[a]'), findsNothing);
      expect(find.text('a'), findsOneWidget);
      expect(_focus(tester).hasFocus, isTrue);
      expect(announcements.last, 'Removed b');
    });

    testWidgets('Backspace with text before the caret edits the text', (
      tester,
    ) async {
      final proposals = <List<String>>[];
      await tester.pumpWidget(
        _Host(initial: const ['a'], proposals: proposals),
      );
      await _focusEditor(tester);
      await _enter(tester, 'xy');
      await _key(tester, LogicalKeyboardKey.backspace);
      expect(find.text('[a]'), findsNothing);
      expect(proposals, isEmpty);
    });

    testWidgets('arrows move the pick and Right past the end returns', (
      tester,
    ) async {
      final proposals = <List<String>>[];
      await tester.pumpWidget(
        _Host(initial: const ['a', 'b', 'c'], proposals: proposals),
      );
      await _focusEditor(tester);
      await _key(tester, LogicalKeyboardKey.arrowLeft);
      expect(find.text('[c]'), findsOneWidget);
      await _key(tester, LogicalKeyboardKey.arrowLeft);
      await _key(tester, LogicalKeyboardKey.arrowLeft);
      await _key(tester, LogicalKeyboardKey.arrowLeft);
      expect(find.text('[a]'), findsOneWidget);
      await _key(tester, LogicalKeyboardKey.arrowRight);
      expect(find.text('[b]'), findsOneWidget);
      await _key(tester, LogicalKeyboardKey.arrowRight);
      await _key(tester, LogicalKeyboardKey.arrowRight);
      expect(find.textContaining('['), findsNothing);
      expect(_focus(tester).hasFocus, isTrue);
      expect(proposals, isEmpty);
    });

    testWidgets('arrows follow the reading direction', (tester) async {
      await tester.pumpWidget(
        _Host(
          initial: const ['a', 'b'],
          proposals: [],
          textDirection: TextDirection.rtl,
        ),
      );
      await _focusEditor(tester);
      await _key(tester, LogicalKeyboardKey.arrowLeft);
      expect(find.textContaining('['), findsNothing);
      await _key(tester, LogicalKeyboardKey.arrowRight);
      expect(find.text('[b]'), findsOneWidget);
    });

    testWidgets('Delete removes the picked tag', (tester) async {
      final proposals = <List<String>>[];
      await tester.pumpWidget(
        _Host(initial: const ['a', 'b'], proposals: proposals),
      );
      await _focusEditor(tester);
      await _key(tester, LogicalKeyboardKey.arrowLeft);
      await _key(tester, LogicalKeyboardKey.arrowLeft);
      await _key(tester, LogicalKeyboardKey.delete);
      expect(proposals, [
        ['b'],
      ]);
    });

    testWidgets('Escape clears a pick and otherwise bubbles', (tester) async {
      var escapes = 0;
      await tester.pumpWidget(
        _Host(initial: const ['a'], proposals: [], onEscape: () => escapes++),
      );
      await _focusEditor(tester);
      await _key(tester, LogicalKeyboardKey.backspace);
      expect(find.text('[a]'), findsOneWidget);
      final picked = await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pump();
      expect(picked, isTrue);
      expect(find.text('[a]'), findsNothing);
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      expect(escapes, 1);
    });

    testWidgets('typing clears the pick', (tester) async {
      await tester.pumpWidget(_Host(initial: const ['a'], proposals: []));
      await _focusEditor(tester);
      await _key(tester, LogicalKeyboardKey.backspace);
      await _enter(tester, 'z');
      expect(find.text('[a]'), findsNothing);
    });

    testWidgets('focus loss clears the pick', (tester) async {
      await tester.pumpWidget(_Host(initial: const ['a'], proposals: []));
      await _focusEditor(tester);
      await _key(tester, LogicalKeyboardKey.backspace);
      expect(find.text('[a]'), findsOneWidget);
      _focus(tester).unfocus();
      await tester.pump();
      await tester.pump();
      expect(find.text('[a]'), findsNothing);
    });

    testWidgets('a held Backspace does not chain from text into tags', (
      tester,
    ) async {
      final proposals = <List<String>>[];
      await tester.pumpWidget(
        _Host(initial: const ['a'], proposals: proposals),
      );
      await _focusEditor(tester);
      await tester.sendKeyRepeatEvent(LogicalKeyboardKey.backspace);
      await tester.pump();
      expect(find.text('[a]'), findsNothing);
    });

    testWidgets('modified arrows stay with the editor', (tester) async {
      await tester.pumpWidget(_Host(initial: const ['a'], proposals: []));
      await _focusEditor(tester);
      await tester.sendKeyDownEvent(LogicalKeyboardKey.shiftLeft);
      await _key(tester, LogicalKeyboardKey.arrowLeft);
      await tester.sendKeyUpEvent(LogicalKeyboardKey.shiftLeft);
      expect(find.text('[a]'), findsNothing);
    });

    testWidgets('the external value shrinking past the pick clears it', (
      tester,
    ) async {
      await tester.pumpWidget(_Host(initial: const ['a', 'b'], proposals: []));
      await _focusEditor(tester);
      await _key(tester, LogicalKeyboardKey.backspace);
      final state = tester.state<_HostState>(find.byType(_Host));
      state.replace(const ['a']);
      await tester.pump();
      expect(find.textContaining('['), findsNothing);
      await _key(tester, LogicalKeyboardKey.backspace);
      expect(find.text('[a]'), findsOneWidget);
    });
  });

  group('pointer', () {
    testWidgets('a tap toggles the pick and focuses the editor', (
      tester,
    ) async {
      await tester.pumpWidget(_Host(initial: const ['a', 'b'], proposals: []));
      await tester.tap(find.byKey(const ValueKey('tag-0')));
      await tester.pump();
      expect(find.text('[a]'), findsOneWidget);
      expect(_focus(tester).hasFocus, isTrue);
      await tester.tap(find.byKey(const ValueKey('tag-0')));
      await tester.pump();
      expect(find.text('[a]'), findsNothing);
    });
  });

  group('disabled and read-only', () {
    for (final (name, host) in [
      (
        'disabled',
        (List<List<String>> p) =>
            _Host(initial: const ['a'], proposals: p, enabled: false),
      ),
      (
        'read-only',
        (List<List<String>> p) =>
            _Host(initial: const ['a'], proposals: p, readOnly: true),
      ),
      (
        'without onChanged',
        (List<List<String>> p) =>
            _Host(initial: const ['a'], proposals: p, editable: false),
      ),
    ]) {
      testWidgets('$name: no picks, removals, or commits', (tester) async {
        final proposals = <List<String>>[];
        await tester.pumpWidget(host(proposals));
        await tester.tap(find.byKey(const ValueKey('tag-0')));
        await tester.pump();
        expect(find.text('[a]'), findsNothing);
        if (name != 'disabled') {
          await _focusEditor(tester);
          await _key(tester, LogicalKeyboardKey.backspace);
          await _key(tester, LogicalKeyboardKey.backspace);
          expect(find.text('[a]'), findsNothing);
          await _submit(tester);
        }
        expect(proposals, isEmpty);
        final editor = tester.widget<EditableText>(_editor);
        expect(editor.readOnly || name == 'disabled', isTrue);
      });
    }

    testWidgets('disabling clears a pick', (tester) async {
      final proposals = <List<String>>[];
      var enabled = true;
      late StateSetter set;
      await tester.pumpWidget(
        StatefulBuilder(
          builder: (context, setState) {
            set = setState;
            return _Host(
              initial: const ['a'],
              proposals: proposals,
              enabled: enabled,
            );
          },
        ),
      );
      await _focusEditor(tester);
      await _key(tester, LogicalKeyboardKey.backspace);
      expect(find.text('[a]'), findsOneWidget);
      set(() => enabled = false);
      await tester.pump();
      expect(find.text('[a]'), findsNothing);
    });
  });

  group('semantics', () {
    testWidgets(
      'each tag is one node with its label, pick, and remove action',
      (tester) async {
        final handle = tester.ensureSemantics();
        final proposals = <List<String>>[];
        await tester.pumpWidget(
          _Host(initial: const ['alpha', 'beta'], proposals: proposals),
        );
        final tagNode = tester.getSemantics(
          find.byKey(const ValueKey('tag-0')),
        );
        expect(tagNode.label, 'alpha');
        expect(tagNode.flagsCollection.isSelected, isNot(Tristate.isTrue));
        final data = tagNode.getSemanticsData();
        expect(data.customSemanticsActionIds, hasLength(1));
        final action = CustomSemanticsAction.getAction(
          data.customSemanticsActionIds!.single,
        )!;
        expect(action.label, 'Remove');
        expect(
          tester.getSemantics(_editor),
          isSemantics(label: 'Topics', isTextField: true),
        );

        await _focusEditor(tester);
        await _key(tester, LogicalKeyboardKey.backspace);
        final picked = tester.getSemantics(find.byKey(const ValueKey('tag-1')));
        expect(picked.flagsCollection.isSelected, Tristate.isTrue);

        tagNode.owner!.performAction(
          tagNode.id,
          SemanticsAction.customAction,
          data.customSemanticsActionIds!.single,
        );
        await tester.pump();
        expect(proposals, [
          ['beta'],
        ]);
        handle.dispose();
      },
    );

    testWidgets('a disabled tag offers no remove action', (tester) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(
        _Host(initial: const ['alpha'], proposals: [], enabled: false),
      );
      final data = tester
          .getSemantics(find.byKey(const ValueKey('tag-0')))
          .getSemanticsData();
      expect(data.customSemanticsActionIds ?? const [], isEmpty);
      expect(data.label, 'alpha');
      handle.dispose();
    });
  });
}
