import 'dart:ui' show Tristate;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:naked_ui/naked_ui.dart';

import '../semantics/semantics_test_utils.dart';

void main() {
  testWidgets('Tab enters and leaves once in both directions', (tester) async {
    final before = _node();
    final attach = _node();
    final send = _node();
    final after = _node();
    await tester.pumpWidget(
      _host([
        _button('Before', before),
        _toolbar([_button('Attach', attach), _button('Send', send)]),
        _button('After', after),
      ]),
    );

    before.requestFocus();
    await tester.pump();
    await _press(tester, LogicalKeyboardKey.tab);
    expect(attach.hasPrimaryFocus, isTrue);
    await _press(tester, LogicalKeyboardKey.arrowRight);
    expect(send.hasPrimaryFocus, isTrue);
    await _press(tester, LogicalKeyboardKey.tab);
    expect(after.hasPrimaryFocus, isTrue);
    await _shiftTab(tester);
    expect(send.hasPrimaryFocus, isTrue);
    await _shiftTab(tester);
    expect(before.hasPrimaryFocus, isTrue);
  });

  for (final direction in TextDirection.values) {
    testWidgets('$direction arrows wrap, skip disabled, and do not activate', (
      tester,
    ) async {
      final attach = _node();
      final unavailable = _node();
      final toggle = _node();
      final send = _node();
      final events = <String>[];
      final forward = direction == TextDirection.ltr
          ? LogicalKeyboardKey.arrowRight
          : LogicalKeyboardKey.arrowLeft;
      final backward = direction == TextDirection.ltr
          ? LogicalKeyboardKey.arrowLeft
          : LogicalKeyboardKey.arrowRight;
      await tester.pumpWidget(
        _host([
          _toolbar([
            _button('Attach', attach, onPressed: () => events.add('attach')),
            _button('Unavailable', unavailable, enabled: false),
            NakedToggle(
              focusNode: toggle,
              value: false,
              onFocusChange: (focused) {
                if (focused) events.add('focused');
              },
              onChanged: (value) => events.add('toggle:$value'),
              child: const Text('Toggle'),
            ),
            _button('Send', send, onPressed: () => events.add('send')),
          ]),
        ], direction: direction),
      );

      attach.requestFocus();
      await tester.pump();
      await _press(tester, backward);
      expect(send.hasPrimaryFocus, isTrue);
      await _press(tester, forward);
      expect(attach.hasPrimaryFocus, isTrue);
      await _press(tester, forward);
      expect(toggle.hasPrimaryFocus, isTrue);
      expect(unavailable.hasFocus, isFalse);
      expect(events, ['focused']);
      await _press(tester, LogicalKeyboardKey.space);
      expect(events, ['focused', 'toggle:true']);
      expect(
        tester.widget<NakedToggle>(find.byType(NakedToggle)).value,
        isFalse,
      );
    });
  }

  testWidgets('keyed reorder retains focus and uses the new order', (
    tester,
  ) async {
    final attach = _node();
    final format = _node();
    final send = _node();
    final attachButton = _button('Attach', attach);
    final formatButton = _button('Format', format);
    final sendButton = _button('Send', send);
    await tester.pumpWidget(
      _host([
        _toolbar([attachButton, formatButton, sendButton]),
      ]),
    );
    format.requestFocus();
    await tester.pump();
    await tester.pumpWidget(
      _host([
        _toolbar([formatButton, attachButton, sendButton]),
      ]),
    );
    expect(format.hasPrimaryFocus, isTrue);
    await _press(tester, LogicalKeyboardKey.arrowRight);
    expect(attach.hasPrimaryFocus, isTrue);
  });

  testWidgets('empty and all-disabled toolbars have no Tab stop', (
    tester,
  ) async {
    final before = _node();
    final after = _node();
    await tester.pumpWidget(
      _host([
        _button('Before', before),
        _toolbar([]),
        _toolbar([_button('Unavailable', _node(), enabled: false)]),
        _button('After', after),
      ]),
    );

    before.requestFocus();
    await tester.pump();
    await _press(tester, LogicalKeyboardKey.tab);
    expect(after.hasPrimaryFocus, isTrue);
    await _shiftTab(tester);
    expect(before.hasPrimaryFocus, isTrue);
  });

  testWidgets('removing the focused action repairs focus from the scope', (
    tester,
  ) async {
    final attach = _node();
    final send = _node();
    Widget host({required bool showAttach}) => _host([
      _toolbar([
        if (showAttach) _button('Attach', attach),
        _button('Send', send),
      ]),
    ]);

    await tester.pumpWidget(host(showAttach: true));
    attach.requestFocus();
    await tester.pump();
    await tester.pumpWidget(host(showAttach: false));
    await tester.pumpAndSettle();
    expect(attach.hasFocus, isFalse);
    expect(send.hasPrimaryFocus, isTrue);
  });

  testWidgets('disabling the focused action repairs focus without removal', (
    tester,
  ) async {
    final attach = _node();
    final send = _node();
    final after = _node();
    Widget host({required bool attachEnabled}) => _host([
      _toolbar([
        _button('Attach', attach, enabled: attachEnabled),
        _button('Send', send),
      ]),
      _button('After', after),
    ]);

    await tester.pumpWidget(host(attachEnabled: true));
    await _press(tester, LogicalKeyboardKey.tab);
    expect(attach.hasPrimaryFocus, isTrue);
    final originalAction = tester.element(find.byKey(const ValueKey('Attach')));

    await tester.pumpWidget(host(attachEnabled: false));
    await tester.pumpAndSettle();
    expect(
      tester.element(find.byKey(const ValueKey('Attach'))),
      same(originalAction),
    );
    expect(attach.canRequestFocus, isFalse);
    expect(FocusManager.instance.primaryFocus, same(send));
    await _press(tester, LogicalKeyboardKey.tab);
    expect(after.hasPrimaryFocus, isTrue);
    await _shiftTab(tester);
    expect(send.hasPrimaryFocus, isTrue);
  });

  testWidgets('disabling the last eligible action leaves no toolbar Tab stop', (
    tester,
  ) async {
    final before = _node();
    final attach = _node();
    final send = _node();
    final after = _node();
    Widget host({required bool attachEnabled}) => _host([
      _button('Before', before),
      _toolbar([
        _button('Attach', attach, enabled: attachEnabled),
        _button('Send', send, enabled: false),
      ]),
      _button('After', after),
    ]);

    await tester.pumpWidget(host(attachEnabled: true));
    attach.requestFocus();
    await tester.pump();
    expect(attach.hasPrimaryFocus, isTrue);
    await tester.pumpWidget(host(attachEnabled: false));
    await tester.pumpAndSettle();
    expect(FocusManager.instance.primaryFocus, same(attach.enclosingScope));
    expect(attach.hasFocus, isFalse);
    expect(send.hasFocus, isFalse);
    before.requestFocus();
    await tester.pump();
    await _press(tester, LogicalKeyboardKey.tab);
    expect(after.hasPrimaryFocus, isTrue);
    await _shiftTab(tester);
    expect(before.hasPrimaryFocus, isTrue);
  });

  testWidgets('disabling the focused action respects an outside fallback', (
    tester,
  ) async {
    final before = _node();
    final attach = _node();
    final send = _node();
    Widget host({required bool attachEnabled}) => _host([
      _button('Before', before),
      _toolbar([
        _button('Attach', attach, enabled: attachEnabled),
        _button('Send', send),
      ]),
    ]);

    await tester.pumpWidget(host(attachEnabled: true));
    before.requestFocus();
    await tester.pump();
    await _press(tester, LogicalKeyboardKey.tab);
    expect(attach.hasPrimaryFocus, isTrue);
    await tester.pumpWidget(host(attachEnabled: false));
    await tester.pumpAndSettle();
    expect(before.hasPrimaryFocus, isTrue);
    await _press(tester, LogicalKeyboardKey.tab);
    expect(send.hasPrimaryFocus, isTrue);
  });

  testWidgets('composer editor keeps editing keys and removal fallback', (
    tester,
  ) async {
    final editor = _node();
    final attach = _node();
    final send = _node();
    final controller = TextEditingController.fromValue(
      const TextEditingValue(
        text: 'Draft',
        selection: TextSelection.collapsed(offset: 5),
      ),
    );
    addTearDown(controller.dispose);
    Widget host({required bool showAttach}) => _host([
      NakedTextField(
        controller: controller,
        focusNode: editor,
        maxLines: null,
        builder: (context, state, editable) => editable,
      ),
      _toolbar([
        if (showAttach) _button('Attach', attach),
        _button('Send', send),
      ]),
    ]);

    await tester.pumpWidget(host(showAttach: true));
    editor.requestFocus();
    await tester.pump();
    final handled = await tester.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
    await tester.pump();
    expect(editor.hasPrimaryFocus, isTrue);
    if (kIsWeb) {
      expect(handled, isFalse, reason: 'The browser owns caret movement.');
    } else {
      expect(controller.selection, const TextSelection.collapsed(offset: 4));
    }
    await _press(tester, LogicalKeyboardKey.tab);
    expect(attach.hasPrimaryFocus, isTrue);
    await tester.pumpWidget(host(showAttach: false));
    await tester.pumpAndSettle();
    expect(editor.hasPrimaryFocus, isTrue);
    await _press(tester, LogicalKeyboardKey.tab);
    expect(send.hasPrimaryFocus, isTrue);
  });

  testWidgets('group adds only a label and preserves each semantic action', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    final attach = _node();
    final send = _node();
    final events = <String>[];
    await tester.pumpWidget(
      _host([
        _toolbar([
          _button('Attach', attach, onPressed: () => events.add('attach')),
          _button('Send', send, onPressed: () => events.add('send')),
          _button('Unavailable', _node(), enabled: false),
        ]),
      ]),
    );

    SemanticsNode group() => findSemanticsNode(
      semanticsRootOf(tester),
      (node) => node.getSemanticsData().label == 'Message actions',
    )!;
    List<SemanticsNode> buttons() => collectSemanticsNodes(
      group(),
      (node) => node.getSemanticsData().flagsCollection.isButton,
    );
    SemanticsNode button(String label) =>
        buttons().singleWhere((node) => node.getSemanticsData().label == label);

    final groupData = group().getSemanticsData();
    expect(groupData.role, SemanticsRole.none);
    expect(groupData.flagsCollection.isFocused, Tristate.none);
    expect(groupData.hasAction(SemanticsAction.tap), isFalse);
    expect(
      buttons().map((node) => node.getSemanticsData().label),
      unorderedEquals(['Attach', 'Send', 'Unavailable']),
    );
    final disabled = button('Unavailable').getSemanticsData();
    expect(disabled.flagsCollection.isEnabled, Tristate.isFalse);
    expect(disabled.hasAction(SemanticsAction.tap), isFalse);

    attach.requestFocus();
    await tester.pumpAndSettle();
    expect(attach.hasPrimaryFocus, isTrue);
    expect(
      button('Attach').getSemanticsData().flagsCollection.isFocused,
      Tristate.isTrue,
    );
    await _press(tester, LogicalKeyboardKey.arrowRight);
    expect(
      button('Attach').getSemanticsData().flagsCollection.isFocused,
      Tristate.isFalse,
    );
    final sendButton = button('Send');
    expect(
      sendButton.getSemanticsData().flagsCollection.isFocused,
      Tristate.isTrue,
    );
    expect(events, isEmpty);

    sendButton.owner!.performAction(sendButton.id, SemanticsAction.tap);
    await tester.pump();
    expect(events, ['send']);
    await tester.tap(find.text('Attach'));
    expect(events, ['send', 'attach']);
    expect(send.hasPrimaryFocus, isTrue);
    semantics.dispose();
  });
}

FocusNode _node() {
  final node = FocusNode();
  addTearDown(node.dispose);
  return node;
}

Widget _host(
  List<Widget> children, {
  TextDirection direction = TextDirection.ltr,
}) {
  return WidgetsApp(
    color: const Color(0xFFFFFFFF),
    pageRouteBuilder: <T>(settings, builder) => PageRouteBuilder<T>(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => builder(context),
    ),
    home: Directionality(
      textDirection: direction,
      child: Column(children: children),
    ),
  );
}

Widget _toolbar(List<Widget> children) => NakedToolbar(
  semanticLabel: 'Message actions',
  child: Row(children: children),
);

Widget _button(
  String label,
  FocusNode focusNode, {
  VoidCallback? onPressed,
  bool enabled = true,
}) => NakedButton(
  key: ValueKey(label),
  focusNode: focusNode,
  semanticLabel: label,
  onPressed: enabled ? onPressed ?? () {} : null,
  child: Text(label),
);

Future<void> _press(WidgetTester tester, LogicalKeyboardKey key) async {
  await tester.sendKeyEvent(key);
  await tester.pump();
}

Future<void> _shiftTab(WidgetTester tester) async {
  await tester.sendKeyDownEvent(LogicalKeyboardKey.shiftLeft);
  await _press(tester, LogicalKeyboardKey.tab);
  await tester.sendKeyUpEvent(LogicalKeyboardKey.shiftLeft);
}
