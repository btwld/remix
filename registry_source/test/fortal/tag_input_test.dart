import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:naked_ui/naked_ui.dart' show NakedTagInputTag;
import 'package:registry_source/fortal.dart';
import 'package:remix/remix.dart' show RemixIconButton;

import '../helpers/test_helpers.dart';

class _Host extends StatefulWidget {
  const _Host(this.initial, {super.key, this.highContrast = false});

  final List<String> initial;
  final bool highContrast;

  @override
  State<_Host> createState() => _HostState();
}

class _HostState extends State<_Host> {
  late List<String> value = widget.initial;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: 280,
    child: FortalTagInput(
      label: 'Topics',
      hintText: 'Add a tag',
      highContrast: widget.highContrast,
      value: value,
      onChanged: (next) => setState(() => value = next),
    ),
  );
}

Finder get _editor => find.byType(EditableText);

Finder _tag(String tag) =>
    find.ancestor(of: find.text(tag), matching: find.byType(NakedTagInputTag));

BoxDecoration _decorationIn(
  WidgetTester tester,
  Finder scope, {
  int skip = 0,
}) => tester
    .widgetList<DecoratedBox>(
      find.descendant(of: scope, matching: find.byType(DecoratedBox)),
    )
    .map((box) => box.decoration)
    .whereType<BoxDecoration>()
    .skip(skip)
    .first;

Rect _shellRect(WidgetTester tester) => tester.getRect(
  find
      .ancestor(of: _editor, matching: find.byType(DecoratedBox))
      .evaluate()
      .map((e) => find.byElementPredicate((x) => x == e))
      .firstWhere(
        (f) =>
            ((tester.widget<DecoratedBox>(f).decoration as BoxDecoration)
                .border) !=
            null,
      ),
);

BoxDecoration _shell(WidgetTester tester) => tester
    .widgetList<DecoratedBox>(
      find.ancestor(of: _editor, matching: find.byType(DecoratedBox)),
    )
    .map((box) => box.decoration)
    .whereType<BoxDecoration>()
    .firstWhere((d) => d.border != null);

Color _edge(BoxDecoration d) => (d.border! as Border).top.color;

void main() {
  testWidgets('one row is 44px: 28px rows inside 7px padding and a 1px edge', (
    tester,
  ) async {
    await tester.pumpRemixApp(
      const _Host(['design', 'flutter']),
      accent: .orla,
    );
    await tester.pumpAndSettle();
    final shell = _shellRect(tester);
    final tag = tester.getRect(_tag('design'));
    expect(tag.height, 28);
    expect(tag.left - shell.left, 8);
    expect(tag.top - shell.top, 8);
    expect(tester.getRect(_tag('flutter')).left - tag.right, 6);

    await tester.pumpRemixApp(
      const _Host([], key: ValueKey('empty')),
      accent: .orla,
    );
    await tester.pumpAndSettle();
    expect(_shellRect(tester).height, 44);
    // The hint starts where typed text starts: 7px padding, then 5px.
    expect(
      tester.getTopLeft(find.text('Add a tag')).dx - _shellRect(tester).left,
      1 + 7 + 5,
    );
  });

  testWidgets('the editor wraps when less than 100px is left in its row', (
    tester,
  ) async {
    await tester.pumpRemixApp(
      const _Host(['design systems', 'flutter', 'accessibility']),
      accent: .orla,
    );
    await tester.pumpAndSettle();
    final last = tester.getRect(_tag('accessibility'));
    final shell = _shellRect(tester);
    final editor = tester.getRect(_editor);
    final left = shell.right - 8 - last.right - 6;
    if (left < 100) {
      expect(editor.top, greaterThan(last.bottom));
    } else {
      expect(editor.top, lessThan(last.bottom));
    }
  });

  testWidgets('light values: shell, tag, and picked tag', (tester) async {
    await tester.pumpRemixApp(
      const _Host(['design', 'flutter']),
      accent: .orla,
    );
    await tester.pumpAndSettle();
    final shell = _shell(tester);
    expect(shell.color, const Color(0xFFFFFFFF));
    expect(_edge(shell), const Color(0xFFE9E9E9));
    expect(shell.borderRadius, BorderRadius.circular(14));

    final fill = _decorationIn(tester, _tag('design'));
    expect(fill.color, const Color(0xFFF8F8F8));
    final pill = _decorationIn(tester, _tag('design'), skip: 1);
    expect(_edge(pill), const Color(0xFFE9E9E9));
    expect(pill.color, const Color(0x00000000));

    _editorFocus(tester);
    await tester.pumpAndSettle();
    expect(_edge(_shell(tester)), const Color(0xFF0B0B0B));

    await tester.sendKeyEvent(LogicalKeyboardKey.backspace);
    await tester.pumpAndSettle();
    final picked = _decorationIn(tester, _tag('flutter'), skip: 1);
    expect(_edge(picked), const Color(0xFF353535));
    expect(picked.color, const Color(0x1A353535));
    expect(
      _decorationIn(tester, _tag('flutter')).color,
      const Color(0xFFF8F8F8),
    );
  });

  testWidgets('hover darkens the shell edge to gray8 over 150ms', (
    tester,
  ) async {
    await tester.pumpRemixApp(const _Host(['design']), accent: .orla);
    await tester.pumpAndSettle();
    final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
    addTearDown(mouse.removePointer);
    await mouse.addPointer(location: Offset.zero);
    await mouse.moveTo(_shellRect(tester).centerRight - const Offset(20, 0));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 75));
    final mid = _edge(_shell(tester));
    expect(mid, isNot(const Color(0xFFE9E9E9)));
    expect(mid, isNot(const Color(0xFFC4C4C4)));
    await tester.pump(const Duration(milliseconds: 100));
    expect(_edge(_shell(tester)), const Color(0xFFC4C4C4));
  });

  testWidgets('dark values and high contrast edges', (tester) async {
    await tester.pumpRemixApp(
      const _Host(['design']),
      accent: .orla,
      mode: .dark,
    );
    await tester.pumpAndSettle();
    expect(_shell(tester).color, const Color(0xFF191919));
    expect(_edge(_shell(tester)), const Color(0xFF2B2B2B));
    expect(
      _decorationIn(tester, _tag('design')).color,
      const Color(0xFF242424),
    );

    await tester.pumpRemixApp(
      const _Host(['design'], highContrast: true),
      accent: .orla,
    );
    await tester.pumpAndSettle();
    expect(_edge(_shell(tester)), const Color(0xFFC4C4C4));
    expect(
      _edge(_decorationIn(tester, _tag('design'), skip: 1)),
      const Color(0xFFC4C4C4),
    );
  });

  testWidgets('remove button: 22px circle, 14px glyph, gray2 on hover', (
    tester,
  ) async {
    await tester.pumpRemixApp(const _Host(['design']), accent: .orla);
    await tester.pumpAndSettle();
    final button = find.descendant(
      of: _tag('design'),
      matching: find.byType(RemixIconButton),
    );
    expect(tester.getSize(button), const Size(22, 22));
    expect(
      tester.getRect(button).right,
      tester.getRect(_tag('design')).right - 1 - 4,
    );
    expect(
      tester.getSize(
        find.descendant(
          of: button,
          matching: find.byWidgetPredicate(
            (w) =>
                w is CustomPaint &&
                '${w.painter.runtimeType}'.contains('PathIcon'),
          ),
        ),
      ),
      const Size(14, 14),
    );

    final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
    addTearDown(mouse.removePointer);
    await mouse.addPointer(location: Offset.zero);
    await mouse.moveTo(tester.getCenter(button));
    await tester.pumpAndSettle();
    expect(_decorationIn(tester, button).color, const Color(0xFFFFFFFF));
  });
}

void _editorFocus(WidgetTester tester) =>
    tester.widget<EditableText>(_editor).focusNode.requestFocus();
