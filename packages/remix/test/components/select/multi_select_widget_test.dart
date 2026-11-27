import 'dart:ui' show CheckedState, SemanticsAction, SemanticsRole, Tristate;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:naked_ui/naked_ui.dart';
import 'package:remix/remix.dart';

import '../../helpers/test_helpers.dart';

const _items = [
  RemixSelectItem(value: 'apple', label: 'Apple'),
  RemixSelectItem(value: 'banana', label: 'Banana'),
  RemixSelectItem(value: 'cherry', label: 'Cherry', enabled: false),
  RemixSelectItem(value: 'date', label: 'Date'),
];

const _rest = Color(0xFF000001);
const _open = Color(0xFF000002);

class _Host extends StatefulWidget {
  const _Host({
    super.key,
    required this.initial,
    required this.proposals,
    this.accept = true,
    this.enabled = true,
  });

  final Set<String> initial;
  final List<Set<String>> proposals;
  final bool accept;
  final bool enabled;

  @override
  State<_Host> createState() => _HostState();
}

class _HostState extends State<_Host> {
  late Set<String> _value = widget.initial;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: RemixMultiSelect<String>(
        trigger: const RemixSelectTrigger(placeholder: 'Pick fruit'),
        items: _items,
        selectedValues: _value,
        enabled: widget.enabled,
        onChanged: (next) {
          widget.proposals.add(next);
          if (widget.accept) setState(() => _value = next);
        },
        style: SelectStyler().trigger(
          SelectTriggerStyler()
              .chipLabel(TextStyler().color(_rest))
              .onSelected(
                SelectTriggerStyler().chipLabel(TextStyler().color(_open)),
              ),
        ),
      ),
    );
  }
}

Finder get _trigger => find.byType(NakedButton);

SemanticsNode _optionNode(WidgetTester tester, String label) =>
    tester.getSemantics(find.bySemanticsLabel(label).last);

void main() {
  group('RemixMultiSelect', () {
    testWidgets('shows the placeholder, then chips in selection order', (
      tester,
    ) async {
      await tester.pumpRemixApp(_Host(initial: const {}, proposals: []));
      expect(find.text('Pick fruit'), findsOneWidget);

      await tester.pumpRemixApp(
        _Host(
          key: const ValueKey('selected'),
          initial: const {'date', 'apple', 'banana'},
          proposals: [],
        ),
      );
      expect(find.text('Pick fruit'), findsNothing);
      final chips = tester
          .widgetList<Text>(
            find.descendant(of: _trigger, matching: find.byType(Text)),
          )
          .map((text) => text.data)
          .toList();
      expect(chips, ['Date', 'Apple', '+1']);
    });

    testWidgets('a tap toggles an option once and keeps the popup open', (
      tester,
    ) async {
      final proposals = <Set<String>>[];
      await tester.pumpRemixApp(
        _Host(initial: const {'apple'}, proposals: proposals),
      );
      await tester.tap(_trigger);
      await tester.pumpAndSettle();
      expect(find.byType(NakedListbox<String>), findsOneWidget);

      await tester.tap(find.text('Date').last);
      await tester.pumpAndSettle();
      expect(proposals, [
        {'apple', 'date'},
      ]);
      expect(proposals.single.toList(), ['apple', 'date']);
      expect(find.byType(NakedListbox<String>), findsOneWidget);

      await tester.tap(find.text('Apple').last);
      await tester.pumpAndSettle();
      expect(proposals.last, {'date'});

      await tester.tap(find.text('Cherry'));
      await tester.pumpAndSettle();
      expect(proposals, hasLength(2), reason: 'disabled option');
    });

    testWidgets('a declined proposal leaves the option unselected', (
      tester,
    ) async {
      final proposals = <Set<String>>[];
      await tester.pumpRemixApp(
        _Host(initial: const {'apple'}, proposals: proposals, accept: false),
      );
      await tester.tap(_trigger);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Banana').last);
      await tester.pumpAndSettle();

      expect(proposals, [
        {'apple', 'banana'},
      ]);
      expect(
        _optionNode(tester, 'Banana').flagsCollection.isChecked,
        CheckedState.isFalse,
      );
    });

    testWidgets('keyboard: Space opens, toggles, Escape returns focus', (
      tester,
    ) async {
      final proposals = <Set<String>>[];
      await tester.pumpRemixApp(
        _Host(initial: const {'banana'}, proposals: proposals),
      );
      final triggerFocus = Focus.of(tester.element(find.text('Banana')));
      triggerFocus.requestFocus();
      await tester.pump();

      await tester.sendKeyEvent(LogicalKeyboardKey.space);
      await tester.pumpAndSettle();
      expect(find.byType(NakedListbox<String>), findsOneWidget);
      expect(
        _optionNode(tester, 'Banana').flagsCollection.isFocused,
        Tristate.isTrue,
        reason: 'focus enters on the first selected option',
      );

      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pump();
      expect(
        _optionNode(tester, 'Date').flagsCollection.isFocused,
        Tristate.isTrue,
        reason: 'Down skips the disabled option',
      );
      expect(proposals, isEmpty, reason: 'moving focus selects nothing');

      await tester.sendKeyEvent(LogicalKeyboardKey.space);
      await tester.pumpAndSettle();
      expect(proposals, [
        {'banana', 'date'},
      ]);
      expect(find.byType(NakedListbox<String>), findsOneWidget);

      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();
      expect(find.byType(NakedListbox<String>), findsNothing);
      expect(triggerFocus.hasPrimaryFocus, isTrue);
    });

    testWidgets('a tap outside closes the popup', (tester) async {
      await tester.pumpRemixApp(_Host(initial: const {}, proposals: []));
      await tester.tap(_trigger);
      await tester.pumpAndSettle();
      await tester.tapAt(const Offset(5, 5));
      await tester.pumpAndSettle();
      expect(find.byType(NakedListbox<String>), findsNothing);
    });

    testWidgets('the trigger resolves under selected while open', (
      tester,
    ) async {
      await tester.pumpRemixApp(_Host(initial: const {'apple'}, proposals: []));
      Color? chipColor() => tester
          .widget<Text>(
            find.descendant(of: _trigger, matching: find.text('Apple')),
          )
          .style
          ?.color;
      expect(chipColor(), _rest);

      await tester.tap(_trigger);
      await tester.pumpAndSettle();
      expect(chipColor(), _open);

      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();
      expect(chipColor(), _rest);
    });

    testWidgets('disabled: the trigger does not open', (tester) async {
      await tester.pumpRemixApp(
        _Host(initial: const {'apple'}, proposals: [], enabled: false),
      );
      await tester.tap(_trigger);
      await tester.pumpAndSettle();
      expect(find.byType(NakedListbox<String>), findsNothing);
    });

    testWidgets('semantics: trigger and multiselectable list', (tester) async {
      final handle = tester.ensureSemantics();
      final proposals = <Set<String>>[];
      await tester.pumpRemixApp(
        _Host(initial: const {'apple', 'banana'}, proposals: proposals),
      );

      final trigger = tester.getSemantics(_trigger).getSemanticsData();
      expect(trigger.label, 'Pick fruit');
      expect(trigger.value, 'Apple, Banana');
      expect(trigger.flagsCollection.isButton, isTrue);
      expect(trigger.flagsCollection.isExpanded, Tristate.isFalse);
      expect(trigger.hasAction(SemanticsAction.tap), isTrue);

      await tester.tap(_trigger);
      await tester.pumpAndSettle();
      expect(
        tester
            .getSemantics(_trigger)
            .getSemanticsData()
            .flagsCollection
            .isExpanded,
        Tristate.isTrue,
      );

      final list = tester.getSemantics(
        find.bySemanticsLabel('Pick fruit').last,
      );
      expect(list.role, SemanticsRole.list);

      final apple = _optionNode(tester, 'Apple');
      expect(apple.flagsCollection.isChecked, CheckedState.isTrue);
      expect(apple.flagsCollection.isInMutuallyExclusiveGroup, isFalse);
      final date = _optionNode(tester, 'Date');
      expect(date.flagsCollection.isChecked, CheckedState.isFalse);
      final cherry = _optionNode(tester, 'Cherry');
      expect(cherry.flagsCollection.isEnabled, Tristate.isFalse);
      expect(cherry.getSemanticsData().hasAction(SemanticsAction.tap), isFalse);

      tester.semantics.tap(find.semantics.byLabel('Date'));
      await tester.pumpAndSettle();
      expect(proposals, [
        {'apple', 'banana', 'date'},
      ]);
      expect(find.byType(NakedListbox<String>), findsOneWidget);
      expect(tester.getSemantics(_trigger).value, 'Apple, Banana, Date');
      handle.dispose();
    });
  });
}
