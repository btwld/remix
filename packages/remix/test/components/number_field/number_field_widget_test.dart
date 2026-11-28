import 'dart:ui' show Tristate;

import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/remix.dart';

const _rest = Color(0xff000001);
const _hover = Color(0xff000002);
const _press = Color(0xff000003);
const _off = Color(0xff000004);
const _shellRest = Color(0xff000011);
const _shellFocus = Color(0xff000012);
const _shellHover = Color(0xff000013);

final _step =
    NumberFieldStepStyler(
          container: BoxStyler().size(30, 30),
          icon: IconStyler(color: _rest, size: 16),
        )
        .onHovered(NumberFieldStepStyler(icon: IconStyler(color: _hover)))
        .onPressed(
          NumberFieldStepStyler(
            icon: IconStyler(color: _press),
            iconScale: 0.82,
          ),
        )
        .onDisabled(NumberFieldStepStyler(icon: IconStyler(color: _off)));

final _style =
    NumberFieldStyler(
          container: BoxStyler().color(_shellRest),
          decrement: _step,
          increment: _step,
        )
        .onHovered(NumberFieldStyler(container: BoxStyler().color(_shellHover)))
        .onFocused(
          NumberFieldStyler(container: BoxStyler().color(_shellFocus)),
        );

class _Owner {
  double? value;
  final proposals = <double?>[];
}

Future<void> _pump(
  WidgetTester tester,
  _Owner owner, {
  double min = 0,
  double max = 10,
  bool enabled = true,
  bool readOnly = false,
  bool error = false,
  String? label = 'Guests',
  String? helperText = 'Up to ten',
}) async {
  await tester.pumpWidget(
    WidgetsApp(
      color: const Color(0xff000000),
      pageRouteBuilder: <T>(settings, builder) => PageRouteBuilder<T>(
        settings: settings,
        pageBuilder: (context, _, _) => builder(context),
      ),
      home: Center(
        child: SizedBox(
          width: 240,
          child: StatefulBuilder(
            builder: (context, setState) => RemixNumberField(
              value: owner.value,
              min: min,
              max: max,
              enabled: enabled,
              readOnly: readOnly,
              error: error,
              label: label,
              helperText: helperText,
              style: _style,
              onChanged: (next) => setState(() {
                owner.proposals.add(next);
                owner.value = next;
              }),
            ),
          ),
        ),
      ),
    ),
  );
  await tester.pump();
}

Color? _glyphColor(WidgetTester tester, String glyph) =>
    tester.widget<Text>(find.text(glyph)).style?.color;

// The shell is the nearest decorated box around both the editor and a step
// control.
Color? _shellColor(WidgetTester tester) {
  final aroundEditor = find.ancestor(
    of: find.byType(EditableText),
    matching: find.byType(DecoratedBox),
  );
  final shell = find.ancestor(of: find.text('+'), matching: aroundEditor).first;
  return (tester.widget<DecoratedBox>(shell).decoration as BoxDecoration).color;
}

Finder get _editor => find.byType(EditableText);

void main() {
  testWidgets('screen readers get one named spin button and two buttons', (
    tester,
  ) async {
    final handle = tester.ensureSemantics();
    final owner = _Owner()..value = 4;
    await _pump(tester, owner);

    expect(
      tester.getSemantics(_editor),
      isSemantics(
        label: 'Guests',
        hint: 'Up to ten',
        value: '4',
        increasedValue: '5',
        decreasedValue: '3',
        isTextField: true,
        isEnabled: true,
        hasIncreaseAction: true,
        hasDecreaseAction: true,
      ),
    );
    expect(
      tester.getSemantics(find.text('+')),
      isSemantics(label: 'Increase', isButton: true, hasTapAction: true),
    );
    expect(
      tester.getSemantics(find.text('−')),
      isSemantics(label: 'Decrease', isButton: true, hasTapAction: true),
    );
    expect(find.bySemanticsLabel('Guests'), findsOneWidget);
    expect(find.bySemanticsLabel(RegExp('Up to ten')), findsNothing);

    final node = tester.getSemantics(_editor);
    node.owner!.performAction(node.id, SemanticsAction.decrease);
    await tester.pump();
    expect(owner.proposals, [3]);
    expect(tester.getSemantics(_editor).value, '3');
    handle.dispose();
  });

  testWidgets('disabled fields drop every step action and the error state '
      'reads invalid', (tester) async {
    final handle = tester.ensureSemantics();
    await _pump(tester, _Owner()..value = 4, enabled: false);
    final disabled = tester.getSemantics(_editor).getSemanticsData();
    expect(disabled.hasAction(SemanticsAction.increase), isFalse);
    expect(disabled.flagsCollection.isEnabled, Tristate.isFalse);
    expect(
      tester
          .getSemantics(find.text('+'))
          .getSemanticsData()
          .hasAction(SemanticsAction.tap),
      isFalse,
    );

    await _pump(tester, _Owner()..value = 4, error: true);
    expect(
      tester.getSemantics(_editor).getSemanticsData().validationResult,
      SemanticsValidationResult.invalid,
    );
    handle.dispose();
  });

  testWidgets('step controls step, keep editor focus, and disable at a bound', (
    tester,
  ) async {
    final owner = _Owner()..value = 9;
    await _pump(tester, owner);
    await tester.tap(_editor);
    await tester.pump();

    await tester.tap(find.text('+'));
    await tester.pumpAndSettle();
    expect(owner.proposals, [10]);
    expect(_glyphColor(tester, '+'), _off);
    expect(_glyphColor(tester, '−'), _rest);

    await tester.tap(find.text('+'));
    await tester.pumpAndSettle();
    expect(owner.proposals, [10]);
    expect(tester.widget<EditableText>(_editor).focusNode.hasFocus, isTrue);

    await tester.sendKeyEvent(LogicalKeyboardKey.home);
    await tester.pump();
    expect(owner.proposals, [10, 0]);
    expect(_glyphColor(tester, '−'), _off);
  });

  testWidgets('each step control resolves its own pressed and hovered states', (
    tester,
  ) async {
    await _pump(tester, _Owner()..value = 5);

    final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
    addTearDown(mouse.removePointer);
    await mouse.addPointer(location: Offset.zero);
    await mouse.moveTo(tester.getCenter(find.text('+')));
    await tester.pumpAndSettle();
    expect(_glyphColor(tester, '+'), _hover);
    expect(_glyphColor(tester, '−'), _rest);
    expect(_shellColor(tester), _shellHover);

    await mouse.down(tester.getCenter(find.text('+')));
    await tester.pumpAndSettle();
    expect(_glyphColor(tester, '+'), _press);
    expect(
      tester
          .widget<Transform>(
            find.ancestor(of: find.text('+'), matching: find.byType(Transform)),
          )
          .transform
          .entry(0, 0),
      closeTo(0.82, 1e-9),
    );
    expect(_glyphColor(tester, '−'), _rest);
    await mouse.up();
    await tester.pumpAndSettle();
  });

  testWidgets('the shell resolves focus from the editor', (tester) async {
    await _pump(tester, _Owner()..value = 5);
    expect(_shellColor(tester), _shellRest);

    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pumpAndSettle();
    expect(_shellColor(tester), _shellFocus);
    expect(tester.widget<EditableText>(_editor).focusNode.hasFocus, isTrue);

    await tester.sendKeyEvent(LogicalKeyboardKey.arrowUp);
    await tester.pump();
    expect(tester.widget<EditableText>(_editor).controller.text, '6');
  });

  testWidgets('read-only shows the value with both controls disabled', (
    tester,
  ) async {
    final owner = _Owner()..value = 5;
    await _pump(tester, owner, readOnly: true);

    expect(_glyphColor(tester, '+'), _off);
    expect(_glyphColor(tester, '−'), _off);
    await tester.tap(find.text('+'));
    await tester.pump();
    expect(owner.proposals, isEmpty);
    expect(tester.widget<EditableText>(_editor).readOnly, isTrue);
  });

  testWidgets('a typed draft commits clamped on submit', (tester) async {
    final owner = _Owner()..value = 2;
    await _pump(tester, owner, label: null, helperText: null);
    await tester.tap(_editor);
    await tester.enterText(_editor, '40');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pump();

    expect(owner.proposals, [10]);
    expect(tester.widget<EditableText>(_editor).controller.text, '10');
    expect(tester.widget<EditableText>(_editor).textAlign, TextAlign.center);
  });

  testWidgets('each side takes its own style, and a style icon replaces the '
      'text glyph', (tester) async {
    const plus = IconData(0xe145, fontFamily: 'TestIcons');
    await tester.pumpWidget(
      WidgetsApp(
        color: const Color(0xff000000),
        pageRouteBuilder: <T>(settings, builder) => PageRouteBuilder<T>(
          settings: settings,
          pageBuilder: (context, _, _) => builder(context),
        ),
        home: Center(
          child: SizedBox(
            width: 240,
            child: RemixNumberField(
              value: 1,
              onChanged: (_) {},
              style: NumberFieldStyler(
                decrement: NumberFieldStepStyler(
                  icon: IconStyler(color: _rest),
                ),
                increment: NumberFieldStepStyler(
                  icon: IconStyler(icon: plus, color: _hover),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    expect(find.text('+'), findsNothing);
    expect(tester.widget<Icon>(find.byIcon(plus)).color, _hover);
    expect(_glyphColor(tester, '\u2212'), _rest);
  });
}
