import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:naked_ui/naked_ui.dart' show NakedTagInputTag;
import 'package:remix/remix.dart';

import '../../helpers/test_helpers.dart';

const _picked = Color(0xFF00AA00);
const _rest = Color(0xFF0000AA);
const _focusedBorder = Color(0xFFAA0000);
const _removeHover = Color(0xFFAAAA00);

TagInputStyler _style() => TagInputStyler()
    .editor(BoxStyler().minHeight(28).padding(.horizontal(5)))
    .spacing(6)
    .runSpacing(4)
    .editorMinWidth(80)
    .padding(.all(7))
    .border(BoxBorderMix.all(BorderSideMix(color: const Color(0xFF999999))))
    .onFocused(
      TagInputStyler().border(
        BoxBorderMix.all(BorderSideMix(color: _focusedBorder)),
      ),
    )
    .tag(
      TagInputTagStyler()
          .color(_rest)
          .height(28)
          .onSelected(TagInputTagStyler().color(_picked))
          .removeButton(
            IconButtonStyler()
                .size(22, 22)
                .onHovered(IconButtonStyler().color(_removeHover)),
          ),
    );

class _Host extends StatefulWidget {
  const _Host({
    required this.initial,
    this.width = 300,
    this.enabled = true,
    this.readOnly = false,
    this.hintText,
  });

  final List<String> initial;
  final double width;
  final bool enabled;
  final bool readOnly;
  final String? hintText;

  @override
  State<_Host> createState() => _HostState();
}

class _HostState extends State<_Host> {
  late List<String> value = widget.initial;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: widget.width,
    child: RemixTagInput(
      label: 'Topics',
      hintText: widget.hintText,
      helperText: 'Press Enter to add',
      value: value,
      enabled: widget.enabled,
      readOnly: widget.readOnly,
      onChanged: (next) => setState(() => value = next),
      style: _style(),
    ),
  );
}

Finder _tagBox(String tag) => find
    .ancestor(of: find.text(tag), matching: find.byType(DecoratedBox))
    .first;

Color? _tagColor(WidgetTester tester, String tag) =>
    (tester.widget<DecoratedBox>(_tagBox(tag)).decoration as BoxDecoration)
        .color;

Finder get _editor => find.byType(EditableText);

Finder _remove(String tag) => find.descendant(
  of: find.ancestor(
    of: find.text(tag),
    matching: find.byType(NakedTagInputTag),
  ),
  matching: find.byType(RemixIconButton),
);

Future<void> _focusEditor(WidgetTester tester) async {
  tester.widget<EditableText>(_editor).focusNode.requestFocus();
  await tester.pump();
}

void main() {
  testWidgets('renders label, helper, tags, and the editor', (tester) async {
    await tester.pumpRemixApp(const _Host(initial: ['alpha', 'beta']));
    expect(find.text('Topics'), findsOneWidget);
    expect(find.text('Press Enter to add'), findsOneWidget);
    expect(find.text('alpha'), findsOneWidget);
    expect(find.text('beta'), findsOneWidget);
    expect(_editor, findsOneWidget);
    expect(_tagColor(tester, 'alpha'), _rest);
    expect(tester.getSize(_tagBox('alpha')).height, 28);
    expect(tester.getSize(_remove('alpha')), const Size(22, 22));
    final editorBox = find.ancestor(
      of: _editor,
      matching: find.byType(Padding),
    );
    expect(tester.getSize(editorBox.first).height, 28);
    expect(
      tester.getTopLeft(_editor).dx - tester.getTopLeft(editorBox.first).dx,
      5,
    );
  });

  testWidgets('the hint shows only while there are no tags and no draft', (
    tester,
  ) async {
    await tester.pumpRemixApp(const _Host(initial: [], hintText: 'Add a tag'));
    expect(find.text('Add a tag'), findsOneWidget);
    await tester.enterText(_editor, 'x');
    await tester.pump();
    expect(find.text('Add a tag'), findsNothing);
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pump();
    expect(find.text('x'), findsOneWidget);
    expect(find.text('Add a tag'), findsNothing);
  });

  testWidgets('a picked tag resolves its selected style', (tester) async {
    await tester.pumpRemixApp(const _Host(initial: ['alpha', 'beta']));
    await _focusEditor(tester);
    await tester.sendKeyEvent(LogicalKeyboardKey.backspace);
    await tester.pump();
    expect(_tagColor(tester, 'beta'), _picked);
    expect(_tagColor(tester, 'alpha'), _rest);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
    await tester.pump();
    expect(_tagColor(tester, 'alpha'), _picked);
    expect(_tagColor(tester, 'beta'), _rest);
  });

  testWidgets('focus within the editor resolves the shell focused style', (
    tester,
  ) async {
    await tester.pumpRemixApp(const _Host(initial: ['alpha']));
    Color shellBorder() {
      final box = tester
          .widgetList<DecoratedBox>(
            find.ancestor(of: _editor, matching: find.byType(DecoratedBox)),
          )
          .map((box) => box.decoration)
          .whereType<BoxDecoration>()
          .firstWhere((d) => d.border != null);
      return (box.border! as Border).top.color;
    }

    expect(shellBorder(), const Color(0xFF999999));
    await _focusEditor(tester);
    expect(shellBorder(), _focusedBorder);
  });

  testWidgets('the remove button removes, keeps focus, and hovers', (
    tester,
  ) async {
    await tester.pumpRemixApp(const _Host(initial: ['alpha', 'beta']));
    await _focusEditor(tester);
    await tester.enterText(_editor, 'draft');

    final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
    addTearDown(mouse.removePointer);
    await mouse.addPointer(location: Offset.zero);
    await mouse.moveTo(tester.getCenter(_remove('alpha')));
    await tester.pump();
    final surface = find.descendant(
      of: _remove('alpha'),
      matching: find.byType(DecoratedBox),
    );
    expect(
      (tester.widget<DecoratedBox>(surface.first).decoration as BoxDecoration)
          .color,
      _removeHover,
    );

    await tester.tap(_remove('alpha'));
    await tester.pump();
    expect(find.text('alpha'), findsNothing);
    expect(find.text('beta'), findsOneWidget);
    expect(tester.widget<EditableText>(_editor).focusNode.hasFocus, isTrue);
    expect(tester.widget<EditableText>(_editor).controller.text, 'draft');
  });

  testWidgets('Shift+Tab from the editor skips the remove buttons', (
    tester,
  ) async {
    await tester.pumpRemixApp(
      const Column(
        children: [
          _Host(initial: ['alpha', 'beta']),
          Focus(child: SizedBox(width: 10, height: 10)),
        ],
      ),
    );
    await _focusEditor(tester);
    await tester.sendKeyDownEvent(LogicalKeyboardKey.shiftLeft);
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.shiftLeft);
    await tester.pump();
    final focused = FocusManager.instance.primaryFocus!;
    expect(focused.context!.widget, isA<Focus>());
    expect(
      find.descendant(
        of: find.byType(RemixTagInput),
        matching: find.byWidget(focused.context!.widget),
      ),
      findsNothing,
    );
  });

  testWidgets('the editor takes the rest of a row that fits it', (
    tester,
  ) async {
    await tester.pumpRemixApp(const _Host(initial: ['a'], width: 300));
    final tagRight = tester.getTopRight(_tagBox('a')).dx;
    expect(tester.getTopLeft(_editor).dx, closeTo(tagRight + 6 + 5, 0.01));
    expect(
      tester.getTopLeft(_editor).dy,
      lessThan(tester.getBottomLeft(_tagBox('a')).dy),
    );
  });

  testWidgets(
    'a tag that leaves less than the minimum pushes the editor down',
    (tester) async {
      // 300 wide, 7 padding and a 1 px border: 284 inside. A 220 tag leaves
      // 58, under 80.
      await tester.pumpRemixApp(
        SizedBox(
          width: 300,
          child: RemixTagInput(
            value: const ['wide'],
            onChanged: (_) {},
            style: _style().tag(
              TagInputTagStyler().width(220).height(28).color(_rest),
            ),
          ),
        ),
      );
      final tag = tester.getRect(_tagBox('wide'));
      final editor = tester.getRect(_editor);
      expect(editor.top, greaterThanOrEqualTo(tag.bottom + 4 - 0.01));
      expect(editor.left, closeTo(tag.left + 5, 0.01));
      expect(editor.width, closeTo(300 - 14 - 2 - 10, 0.01));
    },
  );

  testWidgets('disabled and read-only fields draw no remove buttons', (
    tester,
  ) async {
    await tester.pumpRemixApp(const _Host(initial: ['alpha'], enabled: false));
    expect(find.byType(RemixIconButton), findsNothing);
    await tester.pumpRemixApp(const _Host(initial: ['alpha'], readOnly: true));
    expect(find.byType(RemixIconButton), findsNothing);
    expect(find.text('alpha'), findsOneWidget);
  });

  testWidgets('semantics: a labelled editor and one node per tag', (
    tester,
  ) async {
    final handle = tester.ensureSemantics();
    await tester.pumpRemixApp(const _Host(initial: ['alpha']));
    final fields = tester.semantics
        .simulatedAccessibilityTraversal()
        .map((node) => node.getSemanticsData())
        .where((data) => data.flagsCollection.isTextField)
        .toList();
    expect(fields, hasLength(1));
    expect(fields.single.label, 'Topics');
    expect(fields.single.hint, 'Press Enter to add');

    final tag = tester.getSemantics(find.text('alpha'));
    final data = tag.getSemanticsData();
    expect(data.label, 'alpha');
    expect(data.customSemanticsActionIds, hasLength(1));
    expect(
      CustomSemanticsAction.getAction(
        data.customSemanticsActionIds!.single,
      )!.label,
      'Remove',
    );
    final buttons = tester.semantics.simulatedAccessibilityTraversal().where(
      (node) => node.getSemanticsData().flagsCollection.isButton,
    );
    expect(buttons, isEmpty);
    handle.dispose();
  });
}
