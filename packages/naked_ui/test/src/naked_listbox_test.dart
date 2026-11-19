import 'dart:ui' show CheckedState, SemanticsRole, Tristate;

import 'package:flutter/gestures.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:naked_ui/naked_ui.dart';

const _ada = NakedListboxOption(
  value: 'ada',
  semanticLabel: 'Ada',
  child: Text('Ada visual'),
);
const _leo = NakedListboxOption(
  value: 'leo',
  semanticLabel: 'Leo',
  child: Text('Leo visual'),
);
const _maya = NakedListboxOption(
  value: 'maya',
  semanticLabel: 'Maya',
  enabled: false,
  child: Text('Maya visual'),
);

Widget _host(Widget list) => WidgetsApp(
  color: const Color(0xFFFFFFFF),
  builder: (context, child) => Align(
    alignment: Alignment.topLeft,
    child: SizedBox(
      width: 240,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Focus(child: Text('Before')),
          list,
          const Focus(child: Text('After')),
        ],
      ),
    ),
  ),
);

FocusNode _node(WidgetTester tester, String text) =>
    Focus.of(tester.element(find.text(text)));

Future<void> _key(WidgetTester tester, LogicalKeyboardKey key) async {
  await tester.sendKeyEvent(key);
  await tester.pumpAndSettle();
}

final _rows = List.generate(20, (index) => _row(index));

NakedListboxOption<int> _row(int index, {bool enabled = true}) =>
    NakedListboxOption(
      value: index,
      semanticLabel: 'Row $index',
      enabled: enabled,
      child: SizedBox(height: 30, child: Text('Row $index')),
    );

Widget _scrollHost(
  ScrollController controller,
  List<Set<int>> proposals,
  List<NakedListboxOption<int>> rows,
) => _host(
  SizedBox(
    height: 120,
    child: SingleChildScrollView(
      controller: controller,
      child: NakedListbox<int>.multiple(
        options: rows,
        semanticLabel: 'Rows',
        selectedValues: const {0},
        onChanged: proposals.add,
      ),
    ),
  ),
);

void _expectVisibleFocus(WidgetTester tester, String label) {
  expect(_node(tester, label).hasPrimaryFocus, isTrue);
  final viewport = tester.getRect(find.byType(SingleChildScrollView));
  final row = tester.getRect(find.text(label));
  expect(row.top, greaterThanOrEqualTo(viewport.top));
  expect(row.bottom, lessThanOrEqualTo(viewport.bottom));
}

Iterable<SemanticsNode> _tree(SemanticsNode node) sync* {
  yield node;
  final children = <SemanticsNode>[];
  node.visitChildren((child) {
    children.add(child);
    return true;
  });
  for (final child in children) {
    yield* _tree(child);
  }
}

Iterable<SemanticsNode> _merged(WidgetTester tester) => _tree(
  tester.binding.renderViews.single.owner!.semanticsOwner!.rootSemanticsNode!,
);

SemanticsNode _named(WidgetTester tester, String label) =>
    _merged(tester).singleWhere((node) => node.label == label);

void main() {
  testWidgets(
    'multi-select focus moves independently; rejection does not replay',
    (tester) async {
      final proposals = <Set<String>>[];
      final snapshots = <String, NakedListboxOptionState<String>>{};
      Widget build() => _host(
        NakedListbox<String>.multiple(
          semanticLabel: 'Reviewers',
          options: [
            _ada,
            _maya,
            NakedListboxOption(
              value: 'leo',
              semanticLabel: 'Leo',
              child: _leo.child,
              builder: (context, state, child) {
                snapshots[state.value] = state;
                return child!;
              },
            ),
          ],
          selectedValues: const {'ada'},
          onChanged: proposals.add,
        ),
      );
      await tester.pumpWidget(build());
      _node(tester, 'Before').requestFocus();
      await tester.pumpAndSettle();
      await _key(tester, LogicalKeyboardKey.tab);
      expect(_node(tester, 'Ada visual').hasPrimaryFocus, isTrue);
      await _key(tester, LogicalKeyboardKey.arrowDown);
      expect(snapshots['leo']!.isFocused, isTrue);
      await _key(tester, LogicalKeyboardKey.arrowUp);
      expect(_node(tester, 'Ada visual').hasPrimaryFocus, isTrue);
      await _key(tester, LogicalKeyboardKey.arrowDown);
      expect(snapshots['leo']!.isSelected, isFalse);
      expect(proposals, isEmpty);

      await tester.sendKeyDownEvent(LogicalKeyboardKey.space);
      await tester.sendKeyRepeatEvent(LogicalKeyboardKey.space);
      await tester.sendKeyUpEvent(LogicalKeyboardKey.space);
      expect(proposals, [
        const {'ada', 'leo'},
      ]);
      expect(() => proposals.single.clear(), throwsUnsupportedError);
      await tester.pumpWidget(build());
      await tester.pumpAndSettle();
      expect(snapshots['leo']!.isSelected, isFalse);
      expect(snapshots['leo']!.isFocused, isTrue);
      expect(proposals, hasLength(1));

      await _key(tester, LogicalKeyboardKey.tab);
      expect(_node(tester, 'After').hasPrimaryFocus, isTrue);
      await tester.sendKeyDownEvent(LogicalKeyboardKey.shiftLeft);
      await _key(tester, LogicalKeyboardKey.tab);
      expect(_node(tester, 'Ada visual').hasPrimaryFocus, isTrue);
      await _key(tester, LogicalKeyboardKey.tab);
      await tester.sendKeyUpEvent(LogicalKeyboardKey.shiftLeft);
      expect(_node(tester, 'Before').hasPrimaryFocus, isTrue);
      expect(proposals, hasLength(1));
    },
  );

  testWidgets('single-select handles pointer, touch and keyboard activation', (
    tester,
  ) async {
    final proposals = <String>[];
    String? selected;
    await tester.pumpWidget(
      _host(
        StatefulBuilder(
          builder: (context, setState) => NakedListbox(
            semanticLabel: 'Reviewer',
            options: const [_ada, _maya, _leo],
            selectedValue: selected,
            onChanged: (value) {
              proposals.add(value);
              setState(() => selected = value);
            },
          ),
        ),
      ),
    );
    await tester.tap(find.text('Maya visual'));
    expect(proposals, isEmpty);
    await tester.tap(find.text('Leo visual'), kind: PointerDeviceKind.mouse);
    await tester.pumpAndSettle();
    expect(_node(tester, 'Leo visual').hasPrimaryFocus, isTrue);
    final leo = _named(tester, 'Leo').getSemanticsData().flagsCollection;
    expect(leo.isInMutuallyExclusiveGroup, isTrue);
    expect(leo.isChecked, CheckedState.isTrue);
    await _key(tester, LogicalKeyboardKey.tab);
    expect(_node(tester, 'After').hasPrimaryFocus, isTrue);
    await tester.sendKeyDownEvent(LogicalKeyboardKey.shiftLeft);
    await _key(tester, LogicalKeyboardKey.tab);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.shiftLeft);
    expect(_node(tester, 'Leo visual').hasPrimaryFocus, isTrue);
    await _key(tester, LogicalKeyboardKey.end);
    await _key(tester, LogicalKeyboardKey.arrowDown);
    expect(_node(tester, 'Leo visual').hasPrimaryFocus, isTrue);
    await _key(tester, LogicalKeyboardKey.enter);
    expect(proposals, ['leo']);
    await _key(tester, LogicalKeyboardKey.home);
    expect(_node(tester, 'Ada visual').hasPrimaryFocus, isTrue);
    expect(proposals, ['leo']);
    await tester.tap(find.text('Ada visual'));
    await tester.pumpAndSettle();
    expect(proposals, ['leo', 'ada']);
    expect(_node(tester, 'Ada visual').hasPrimaryFocus, isTrue);
  });

  testWidgets('reordering retains the focused node, removal repairs focus', (
    tester,
  ) async {
    final proposals = <Set<String>>[];
    Widget build(List<NakedListboxOption<String>> options) => _host(
      NakedListbox.multiple(
        semanticLabel: 'Reviewers',
        options: options,
        selectedValues: const {'ada'},
        onChanged: proposals.add,
      ),
    );
    await tester.pumpWidget(build([_ada, _leo]));
    final leoNode = _node(tester, 'Leo visual')..requestFocus();
    await tester.pumpAndSettle();
    await tester.pumpWidget(build([_leo, _ada]));
    await tester.pumpAndSettle();
    expect(_node(tester, 'Leo visual'), same(leoNode));
    expect(leoNode.hasPrimaryFocus, isTrue);

    await tester.pumpWidget(build([_maya, _ada]));
    await tester.pumpAndSettle();
    expect(_node(tester, 'Ada visual').hasPrimaryFocus, isTrue);
    await tester.pumpWidget(build([_leo]));
    await tester.pumpAndSettle();
    expect(_node(tester, 'Leo visual').hasPrimaryFocus, isTrue);
    await tester.pumpWidget(
      build([
        _ada,
        const NakedListboxOption(
          value: 'leo',
          semanticLabel: 'Leo',
          enabled: false,
          child: Text('Leo visual'),
        ),
      ]),
    );
    await tester.pumpAndSettle();
    expect(_node(tester, 'Ada visual').hasPrimaryFocus, isTrue);
    expect(proposals, isEmpty);

    _node(tester, 'After').requestFocus();
    await tester.pumpAndSettle();
    await tester.pumpWidget(build([_ada]));
    await tester.pumpAndSettle();
    expect(_node(tester, 'After').hasPrimaryFocus, isTrue);
    expect(proposals, isEmpty);
  });

  testWidgets('Tab enters and reveals the selected option above the viewport', (
    tester,
  ) async {
    final controller = ScrollController();
    addTearDown(controller.dispose);
    final proposals = <Set<int>>[];
    await tester.pumpWidget(_scrollHost(controller, proposals, _rows));
    controller.jumpTo(controller.position.maxScrollExtent);
    _node(tester, 'Before').requestFocus();
    await tester.pumpAndSettle();
    expect(controller.offset, greaterThan(0));

    await _key(tester, LogicalKeyboardKey.tab);
    _expectVisibleFocus(tester, 'Row 0');
    await _key(tester, LogicalKeyboardKey.tab);
    expect(_node(tester, 'After').hasPrimaryFocus, isTrue);

    controller.jumpTo(controller.position.maxScrollExtent);
    await tester.pumpAndSettle();
    await tester.sendKeyDownEvent(LogicalKeyboardKey.shiftLeft);
    await _key(tester, LogicalKeyboardKey.tab);
    _expectVisibleFocus(tester, 'Row 0');
    await _key(tester, LogicalKeyboardKey.tab);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.shiftLeft);
    expect(_node(tester, 'Before').hasPrimaryFocus, isTrue);
    expect(proposals, isEmpty);
  });

  for (final (change, rows, label) in [
    ('removed', _rows.sublist(0, 19), 'Row 0'),
    ('disabled', [..._rows.take(19), _row(19, enabled: false)], 'Row 0'),
    ('moved to the top', [_rows.last, ..._rows.take(19)], 'Row 19'),
  ]) {
    testWidgets('reveals focus when the last option is $change', (
      tester,
    ) async {
      final controller = ScrollController();
      addTearDown(controller.dispose);
      final proposals = <Set<int>>[];
      await tester.pumpWidget(_scrollHost(controller, proposals, _rows));
      _node(tester, 'Row 0').requestFocus();
      await tester.pumpAndSettle();
      await _key(tester, LogicalKeyboardKey.end);
      _expectVisibleFocus(tester, 'Row 19');
      final expectedFocus = _node(tester, label);

      await tester.pumpWidget(_scrollHost(controller, proposals, rows));
      await tester.pumpAndSettle();
      expect(_node(tester, label), same(expectedFocus));
      _expectVisibleFocus(tester, label);
      expect(proposals, isEmpty);
    });
  }

  testWidgets('empty, all-disabled, read-only and disabled lists are skipped', (
    tester,
  ) async {
    final proposals = <String>[];
    for (final list in [
      NakedListbox<String>(
        semanticLabel: 'Reviewers',
        options: const [],
        selectedValue: null,
        onChanged: proposals.add,
      ),
      NakedListbox(
        semanticLabel: 'Reviewers',
        options: const [_maya],
        selectedValue: 'maya',
        onChanged: proposals.add,
      ),
      const NakedListbox(
        semanticLabel: 'Reviewers',
        options: [_ada],
        selectedValue: 'ada',
      ),
      NakedListbox(
        semanticLabel: 'Reviewers',
        options: const [_ada],
        selectedValue: 'ada',
        enabled: false,
        onChanged: proposals.add,
      ),
    ]) {
      await tester.pumpWidget(_host(list));
      _node(tester, 'Before').requestFocus();
      await tester.pumpAndSettle();
      await _key(tester, LogicalKeyboardKey.tab);
      expect(_node(tester, 'After').hasPrimaryFocus, isTrue);
    }
    expect(proposals, isEmpty);
  });

  testWidgets('merged semantics expose one named checkable action per option', (
    tester,
  ) async {
    final proposals = <Set<String>>[];
    Set<String> selected = {'ada', 'hidden'};
    Widget build({bool excludeSemantics = false}) => _host(
      StatefulBuilder(
        builder: (context, setState) => NakedListbox.multiple(
          semanticLabel: 'Reviewers',
          options: const [_ada, _leo, _maya],
          selectedValues: selected,
          excludeSemantics: excludeSemantics,
          onChanged: (values) {
            proposals.add(values);
            setState(() => selected = values);
          },
        ),
      ),
    );
    await tester.pumpWidget(build());
    final list = _named(tester, 'Reviewers');
    expect(list.getSemanticsData().role, SemanticsRole.list);
    expect(list.getSemanticsData().hasAction(SemanticsAction.tap), isFalse);
    final rows = _tree(list).skip(1).toList();
    expect(rows.map((node) => node.label), ['', 'Ada', '', 'Leo', '', 'Maya']);
    for (final name in ['Ada', 'Leo', 'Maya']) {
      expect(
        _named(tester, name).parent!.getSemanticsData().role,
        SemanticsRole.listItem,
      );
    }
    final maya = _named(tester, 'Maya').getSemanticsData();
    expect(maya.flagsCollection.isEnabled, Tristate.isFalse);
    expect(maya.hasAction(SemanticsAction.tap), isFalse);
    expect(
      _named(tester, 'Ada').getSemanticsData().flagsCollection.isChecked,
      CheckedState.isTrue,
    );

    _node(tester, 'Ada visual').requestFocus();
    await tester.pumpAndSettle();
    await _key(tester, LogicalKeyboardKey.arrowDown);
    final leo = _named(tester, 'Leo');
    expect(
      leo.getSemanticsData().flagsCollection.isChecked,
      CheckedState.isFalse,
    );
    expect(leo.getSemanticsData().flagsCollection.isFocused, Tristate.isTrue);
    expect(leo.getSemanticsData().hasAction(SemanticsAction.tap), isTrue);
    expect(proposals, isEmpty);
    final ada = _named(tester, 'Ada');
    ada.owner!.performAction(ada.id, SemanticsAction.tap);
    await tester.pumpAndSettle();
    expect(proposals, [
      const {'hidden'},
    ]);
    final updated = _named(tester, 'Ada').getSemanticsData().flagsCollection;
    expect(updated.isChecked, CheckedState.isFalse);
    expect(updated.isFocused, Tristate.isTrue);

    await tester.pumpWidget(build(excludeSemantics: true));
    final labels = _merged(tester).map((node) => node.label).toSet();
    expect(labels.intersection({'Reviewers', 'Ada', 'Leo', 'Maya'}), isEmpty);
  });
}
