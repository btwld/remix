import 'dart:ui' show SemanticsAction;

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:naked_ui/naked_ui.dart';

enum _Interest { design, code, research, unmounted }

Widget _host(Widget child) => WidgetsApp(
  color: const Color(0xff000000),
  builder: (context, _) => Center(child: child),
);

FocusNode _focusNode() {
  final node = FocusNode();
  addTearDown(node.dispose);
  return node;
}

Widget _item(_Interest interest, {FocusNode? focusNode, bool enabled = true}) {
  return NakedCheckboxGroupItem<_Interest>(
    value: interest,
    focusNode: focusNode,
    enabled: enabled,
    child: Text(interest.name),
  );
}

Future<void> _press(WidgetTester tester, LogicalKeyboardKey key) async {
  await tester.sendKeyEvent(key);
  await tester.pump();
}

void main() {
  testWidgets('a declining owner keeps selection and keyboard focus', (
    tester,
  ) async {
    final values = {_Interest.design, _Interest.unmounted};
    final proposals = <Set<_Interest>>[];
    final focus = _focusNode();

    Widget build() => _host(
      NakedCheckboxGroup<_Interest>(
        values: values,
        onChanged: proposals.add,
        child: NakedCheckboxGroupItem<_Interest>(
          value: _Interest.code,
          focusNode: focus,
          child: const Text('Code'),
          builder: (context, state, child) => Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              child!,
              Text(state.isChecked! ? 'checked' : 'unchecked'),
            ],
          ),
        ),
      ),
    );

    await tester.pumpWidget(build());
    focus.requestFocus();
    await tester.pump();
    await _press(tester, LogicalKeyboardKey.space);

    final proposed = {...values, _Interest.code};
    expect(proposals, [proposed]);
    expect(() => proposals.single.clear(), throwsUnsupportedError);
    expect(values, {_Interest.design, _Interest.unmounted});
    expect(focus.hasPrimaryFocus, isTrue);
    expect(find.text('unchecked'), findsOneWidget);

    await tester.pumpWidget(build());
    expect(proposals, [proposed]);
    await tester.tap(find.text('Code'));
    await tester.pump();
    expect(proposals, [proposed, proposed]);
    expect(identical(proposals.first, proposals.last), isFalse);
    expect(find.text('unchecked'), findsOneWidget);
  });

  testWidgets('semantic tap updates one checkbox in a named required group', (
    tester,
  ) async {
    final proposals = <Set<_Interest>>[];
    var values = <_Interest>{_Interest.design, _Interest.unmounted};

    await tester.pumpWidget(
      _host(
        StatefulBuilder(
          builder: (context, setState) => NakedCheckboxGroup<_Interest>(
            values: values,
            onChanged: (next) {
              proposals.add(next);
              setState(() => values = next);
            },
            semanticLabel: 'Interests',
            isRequired: true,
            child: Column(
              children: [
                const NakedCheckboxGroupItem<_Interest>(
                  value: _Interest.design,
                  semanticLabel: 'Design',
                  child: Text('Visual Design'),
                ),
                _item(_Interest.code, enabled: false),
              ],
            ),
          ),
        ),
      ),
    );

    void expectTree({required bool designChecked}) {
      expect(
        tester.getSemantics(find.byType(NakedCheckboxGroup<_Interest>)),
        matchesSemantics(
          label: 'Interests',
          hasRequiredState: true,
          isRequired: true,
          children: [
            matchesSemantics(
              label: 'Design',
              hasCheckedState: true,
              isChecked: designChecked,
              hasEnabledState: true,
              isEnabled: true,
              isFocusable: true,
              hasFocusAction: true,
              hasTapAction: true,
            ),
            matchesSemantics(
              label: 'code',
              hasCheckedState: true,
              hasEnabledState: true,
            ),
          ],
        ),
      );
    }

    expectTree(designChecked: true);
    tester.semantics.performAction(
      find.semantics.byLabel('Design'),
      SemanticsAction.tap,
    );
    await tester.pump();
    expect(proposals, [
      {_Interest.unmounted},
    ]);
    expectTree(designChecked: false);
  });

  testWidgets('Tab and Shift+Tab traverse each enabled item once', (
    tester,
  ) async {
    final before = _focusNode();
    final design = _focusNode();
    final code = _focusNode();
    final disabled = _focusNode();
    final after = _focusNode();
    final proposals = <Set<_Interest>>[];

    await tester.pumpWidget(
      _host(
        Column(
          children: [
            Focus(focusNode: before, child: const Text('Before')),
            NakedCheckboxGroup<_Interest>(
              values: const {},
              onChanged: proposals.add,
              child: Column(
                children: [
                  _item(_Interest.design, focusNode: design),
                  _item(
                    _Interest.research,
                    focusNode: disabled,
                    enabled: false,
                  ),
                  _item(_Interest.code, focusNode: code),
                ],
              ),
            ),
            Focus(focusNode: after, child: const Text('After')),
          ],
        ),
      ),
    );

    before.requestFocus();
    await tester.pump();
    for (final node in [design, code, after]) {
      await _press(tester, LogicalKeyboardKey.tab);
      expect(node.hasPrimaryFocus, isTrue);
    }
    await tester.sendKeyDownEvent(LogicalKeyboardKey.shiftLeft);
    for (final node in [code, design, before]) {
      await _press(tester, LogicalKeyboardKey.tab);
      expect(node.hasPrimaryFocus, isTrue);
    }
    await tester.sendKeyUpEvent(LogicalKeyboardKey.shiftLeft);
    expect(proposals, isEmpty);
  });

  testWidgets('disabled groups cannot activate; exclusion hides the subtree', (
    tester,
  ) async {
    final proposals = <Set<_Interest>>[];
    final focus = _focusNode();

    Future<void> pump({
      ValueChanged<Set<_Interest>>? onChanged,
      bool enabled = true,
      bool excludeSemantics = false,
    }) => tester.pumpWidget(
      _host(
        NakedCheckboxGroup<_Interest>(
          values: const {_Interest.design},
          onChanged: onChanged,
          enabled: enabled,
          semanticLabel: 'Interests',
          excludeSemantics: excludeSemantics,
          child: _item(_Interest.design, focusNode: focus),
        ),
      ),
    );

    for (final callback in [null, proposals.add]) {
      await pump(onChanged: callback, enabled: callback == null);
      expect(focus.canRequestFocus, isFalse);
      expect(
        find.semantics.byLabel('design').evaluate().single,
        matchesSemantics(
          label: 'design',
          hasCheckedState: true,
          isChecked: true,
          hasEnabledState: true,
        ),
      );
      await tester.tap(find.text('design'));
      expect(proposals, isEmpty);
    }

    await pump(onChanged: proposals.add, excludeSemantics: true);
    expect(find.semantics.byLabel('Interests'), findsNothing);
    expect(find.semantics.byLabel('design'), findsNothing);
    await tester.tap(find.text('design'));
    expect(proposals, [<_Interest>{}]);
  });

  testWidgets('hiding and showing group semantics preserves item focus', (
    tester,
  ) async {
    final proposals = <Set<_Interest>>[];

    Future<void> pump({required bool excludeSemantics}) => tester.pumpWidget(
      _host(
        NakedCheckboxGroup<_Interest>(
          values: const {},
          onChanged: proposals.add,
          semanticLabel: 'Interests',
          isRequired: true,
          excludeSemantics: excludeSemantics,
          child: _item(_Interest.design),
        ),
      ),
    );

    await pump(excludeSemantics: false);
    final focus = Focus.of(tester.element(find.text('design')));
    focus.requestFocus();
    await tester.pump();
    expect(focus.hasPrimaryFocus, isTrue);
    expect(find.semantics.byLabel('Interests'), findsOne);
    expect(find.semantics.byLabel('design'), findsOne);

    await pump(excludeSemantics: true);
    expect(FocusManager.instance.primaryFocus, same(focus));
    expect(find.semantics.byLabel('Interests'), findsNothing);
    expect(find.semantics.byLabel('design'), findsNothing);
    expect(proposals, isEmpty);

    await _press(tester, LogicalKeyboardKey.space);
    expect(proposals, [
      {_Interest.design},
    ]);

    await pump(excludeSemantics: false);
    expect(FocusManager.instance.primaryFocus, same(focus));
    expect(find.semantics.byLabel('Interests'), findsOne);
    expect(find.semantics.byLabel('design'), findsOne);
    expect(proposals, hasLength(1));
  });

  testWidgets('checks for settled duplicate values after items change', (
    tester,
  ) async {
    final removed = _focusNode();
    final proposals = <Set<_Interest>>[];

    Future<void> pump(List<Widget> items) => tester.pumpWidget(
      _host(
        NakedCheckboxGroup<_Interest>(
          values: const {},
          onChanged: proposals.add,
          child: Column(children: items),
        ),
      ),
    );

    await pump([
      _item(_Interest.design),
      _item(_Interest.code, focusNode: removed),
    ]);
    removed.requestFocus();
    await tester.pump();
    expect(removed.hasPrimaryFocus, isTrue);

    await pump([_item(_Interest.code)]);
    expect(tester.takeException(), isNull);
    expect(removed.hasFocus, isFalse);
    expect(proposals, isEmpty);

    await pump([_item(_Interest.code), _item(_Interest.code, enabled: false)]);
    expect(
      tester.takeException(),
      isFlutterError.having(
        (error) => error.message,
        'message',
        contains('item values must be unique'),
      ),
    );
  });
}
