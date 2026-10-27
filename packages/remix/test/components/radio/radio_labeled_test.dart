import 'dart:ui' show CheckedState, SemanticsAction;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/remix.dart';

import '../../helpers/test_helpers.dart';

const _label = 'Monthly billing';

/// A group whose selection stays on `a`, so every activation of `b` reports.
Widget _group({required Widget child, ValueChanged<String?>? onChanged}) {
  return RemixRadioGroup<String>(
    groupValue: 'a',
    onChanged: onChanged,
    child: child,
  );
}

Finder _ring() => find
    .descendant(of: find.byType(RemixRadio<String>), matching: find.byType(Box))
    .first;

Color? _ringColor(WidgetTester tester) {
  final decoration = tester.widget<Box>(_ring()).styleSpec!.spec.decoration;
  return (decoration as BoxDecoration?)?.color;
}

SemanticsNode _expectSingleRadioNode(WidgetTester tester) {
  final root = tester.getSemantics(find.byType(RemixRadio<String>));
  final radioNodes = semanticsSubtree(root)
      .where(
        (node) =>
            node.getSemanticsData().flagsCollection.isChecked !=
            CheckedState.none,
      )
      .toList();
  expect(radioNodes, hasLength(1));
  return radioNodes.single;
}

/// RawRadio shows hover and focus only while Flutter is in traditional
/// highlight mode, which touch-first test platforms start outside of.
void _useTraditionalHighlightMode() {
  final previous = FocusManager.instance.highlightStrategy;
  FocusManager.instance.highlightStrategy =
      FocusHighlightStrategy.alwaysTraditional;
  addTearDown(() => FocusManager.instance.highlightStrategy = previous);
}

Future<TestGesture> _hoverAt(WidgetTester tester, Offset location) async {
  final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
  addTearDown(mouse.removePointer);
  await mouse.addPointer(location: Offset.zero);
  await mouse.moveTo(location);
  await tester.pumpAndSettle();
  return mouse;
}

void main() {
  group('labeled radio interaction target', () {
    testWidgets('ring, label, gap, and target edges each select once', (
      tester,
    ) async {
      var selections = 0;

      await tester.pumpRemixApp(
        _group(
          onChanged: (_) => selections += 1,
          child: RemixRadio<String>(
            value: 'b',
            label: _label,
            minimumTapTargetSize: const Size.square(48),
            style: RadioStyler().size(16, 16).labelSpacing(12),
          ),
        ),
      );

      final ringRect = tester.getRect(_ring());
      final labelRect = tester.getRect(find.text(_label));
      final targetRect = tester.getRect(find.byType(RemixRadio<String>));
      expect(targetRect.height, 48);
      final tapLocations = <Offset>[
        ringRect.center,
        labelRect.center,
        Offset((ringRect.right + labelRect.left) / 2, targetRect.center.dy),
        targetRect.topLeft + const Offset(1, 1),
        targetRect.topRight + const Offset(-1, 1),
        targetRect.bottomLeft + const Offset(1, -1),
        targetRect.bottomRight + const Offset(-1, -1),
      ];

      for (var i = 0; i < tapLocations.length; i++) {
        await tester.tapAt(tapLocations[i]);
        await tester.pump();
        expect(selections, i + 1, reason: 'tap location ${tapLocations[i]}');
      }
    });

    testWidgets('an explicit minimum target pads an unlabeled radio', (
      tester,
    ) async {
      await tester.pumpRemixApp(
        _group(
          child: RemixRadio<String>(
            value: 'b',
            semanticLabel: 'Monthly',
            minimumTapTargetSize: const Size.square(48),
            style: RadioStyler().size(16, 16),
          ),
        ),
      );

      expect(
        tester.getSize(find.byType(RemixRadio<String>)),
        const Size.square(48),
      );
      expect(tester.getSize(_ring()), const Size.square(16));
    });

    testWidgets('keeps the ring size by default', (tester) async {
      await tester.pumpRemixApp(
        _group(
          child: RemixRadio<String>(
            value: 'b',
            semanticLabel: 'Monthly',
            style: RadioStyler().size(16, 16),
          ),
        ),
      );

      expect(
        tester.getSize(find.byType(RemixRadio<String>)),
        const Size.square(16),
      );
    });

    testWidgets('an unlabeled radio without a target adds no layout', (
      tester,
    ) async {
      await tester.pumpRemixApp(
        _group(
          child: SizedBox.square(
            dimension: 48,
            child: RemixRadio<String>(
              value: 'b',
              semanticLabel: 'Monthly',
              style: RadioStyler().size(16, 16),
            ),
          ),
        ),
      );

      expect(tester.getSize(_ring()), const Size.square(48));
      expect(
        find.descendant(
          of: find.byType(RemixRadio<String>),
          matching: find.byType(Row),
        ),
        findsNothing,
      );
    });

    testWidgets('rejects non-finite and negative minimum target dimensions', (
      tester,
    ) async {
      for (final invalidSize in const <Size>[
        Size(double.infinity, 48),
        Size(48, double.infinity),
        Size(-1, 48),
      ]) {
        await tester.pumpRemixApp(
          _group(
            child: RemixRadio<String>(
              value: 'b',
              label: _label,
              minimumTapTargetSize: invalidSize,
            ),
          ),
        );
        expect(tester.takeException(), isA<AssertionError>());
        await tester.pumpWidget(const SizedBox.shrink());
      }
    });

    testWidgets('meets Android, iOS, and labeled tap target guidelines', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();

      await tester.pumpRemixApp(
        _group(
          onChanged: (_) {},
          child: RemixRadio<String>(
            value: 'b',
            label: _label,
            minimumTapTargetSize: const Size.square(48),
            style: RadioStyler().size(16, 16),
          ),
        ),
      );

      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      await expectLater(tester, meetsGuideline(iOSTapTargetGuideline));
      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
      handle.dispose();
    });
  });

  group('labeled radio hover, press, and focus', () {
    testWidgets('hovering the label applies the hovered style to the ring', (
      tester,
    ) async {
      _useTraditionalHighlightMode();
      await tester.pumpRemixApp(
        _group(
          onChanged: (_) {},
          child: RemixRadio<String>(
            value: 'b',
            label: _label,
            style: RadioStyler()
                .size(16, 16)
                .color(Colors.blue)
                .onHovered(RadioStyler().color(Colors.green)),
          ),
        ),
      );
      expect(_ringColor(tester), Colors.blue);

      final mouse = await _hoverAt(tester, tester.getCenter(find.text(_label)));
      expect(_ringColor(tester), Colors.green);

      await mouse.moveTo(const Offset(2, 2));
      await tester.pumpAndSettle();
      expect(_ringColor(tester), Colors.blue);
    });

    testWidgets('pressing the label applies the pressed style to the ring', (
      tester,
    ) async {
      await tester.pumpRemixApp(
        _group(
          onChanged: (_) {},
          child: RemixRadio<String>(
            value: 'b',
            label: _label,
            style: RadioStyler()
                .size(16, 16)
                .color(Colors.blue)
                .onPressed(RadioStyler().color(Colors.red)),
          ),
        ),
      );
      expect(_ringColor(tester), Colors.blue);

      final press = await tester.startGesture(
        tester.getCenter(find.text(_label)),
      );
      await tester.pumpAndSettle();
      expect(_ringColor(tester), Colors.red);

      await press.up();
      await tester.pumpAndSettle();
      expect(_ringColor(tester), Colors.blue);
    });

    testWidgets('focus applies the focused style to the label', (tester) async {
      _useTraditionalHighlightMode();
      final focusNode = FocusNode();
      addTearDown(focusNode.dispose);

      await tester.pumpRemixApp(
        _group(
          onChanged: (_) {},
          child: RemixRadio<String>(
            value: 'b',
            label: _label,
            focusNode: focusNode,
            style: RadioStyler().onFocused(
              RadioStyler().labelColor(Colors.red),
            ),
          ),
        ),
      );

      focusNode.requestFocus();
      await tester.pumpAndSettle();

      expect(tester.widget<Text>(find.text(_label)).style?.color, Colors.red);
    });
  });

  group('labeled radio semantics', () {
    testWidgets('exposes one exact radio node named by the label', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();

      await tester.pumpRemixApp(
        _group(
          onChanged: (_) {},
          child: const RemixRadio<String>(value: 'b', label: _label),
        ),
      );

      final node = _expectSingleRadioNode(tester);
      expect(
        node,
        matchesSemantics(
          label: _label,
          textDirection: TextDirection.ltr,
          hasCheckedState: true,
          hasEnabledState: true,
          isEnabled: true,
          isInMutuallyExclusiveGroup: true,
          isFocusable: true,
          hasTapAction: true,
          hasFocusAction: true,
          children: const <Matcher>[],
        ),
      );
      handle.dispose();
    });

    testWidgets('a selected radio reports checked', (tester) async {
      final handle = tester.ensureSemantics();

      await tester.pumpRemixApp(
        RemixRadioGroup<String>(
          groupValue: 'a',
          onChanged: (_) {},
          child: const RemixRadio<String>(value: 'a', label: _label),
        ),
      );

      expect(
        _expectSingleRadioNode(
          tester,
        ).getSemanticsData().flagsCollection.isChecked,
        CheckedState.isTrue,
      );
      handle.dispose();
    });

    testWidgets('a disabled radio keeps its name and drops its actions', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();

      await tester.pumpRemixApp(
        _group(
          onChanged: (_) {},
          child: const RemixRadio<String>(
            value: 'b',
            label: _label,
            enabled: false,
          ),
        ),
      );

      final data = _expectSingleRadioNode(tester).getSemanticsData();
      expect(data.label, _label);
      expect(data.hasAction(SemanticsAction.tap), isFalse);
      expect(data.hasAction(SemanticsAction.focus), isFalse);
      handle.dispose();
    });

    testWidgets(
      'semanticLabel overrides the visible label without duplication',
      (tester) async {
        final handle = tester.ensureSemantics();

        await tester.pumpRemixApp(
          _group(
            onChanged: (_) {},
            child: const RemixRadio<String>(
              value: 'b',
              label: 'Monthly',
              semanticLabel: 'Monthly billing, charged on the 1st',
            ),
          ),
        );

        final node = _expectSingleRadioNode(tester);
        expect(
          node.getSemanticsData().label,
          'Monthly billing, charged on the 1st',
        );
        expect(find.text('Monthly'), findsOneWidget);
        final labeledNodes = semanticsSubtree(
          tester.getSemantics(find.byType(RemixRadio<String>)),
        ).where((node) => node.getSemanticsData().label.isNotEmpty);
        expect(labeledNodes, hasLength(1));
        handle.dispose();
      },
    );

    testWidgets('a semanticLabel alone names a radio without a visible label', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();

      await tester.pumpRemixApp(
        _group(
          onChanged: (_) {},
          child: const RemixRadio<String>(value: 'b', semanticLabel: 'Monthly'),
        ),
      );

      expect(
        _expectSingleRadioNode(tester).getSemanticsData().label,
        'Monthly',
      );
      handle.dispose();
    });

    testWidgets('semantic tap and focus actions activate the whole control', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      final focusNode = FocusNode();
      addTearDown(focusNode.dispose);
      var selections = 0;

      await tester.pumpRemixApp(
        _group(
          onChanged: (_) => selections += 1,
          child: RemixRadio<String>(
            value: 'b',
            label: _label,
            focusNode: focusNode,
          ),
        ),
      );

      final node = _expectSingleRadioNode(tester);
      node.owner!.performAction(node.id, SemanticsAction.tap);
      await tester.pump();
      expect(selections, 1);

      node.owner!.performAction(node.id, SemanticsAction.focus);
      await tester.pump();
      expect(focusNode.hasFocus, isTrue);
      handle.dispose();
    });

    testWidgets('excludeSemantics hides the radio and its label', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();

      await tester.pumpRemixApp(
        _group(
          onChanged: (_) {},
          child: const RemixRadio<String>(
            value: 'b',
            label: _label,
            excludeSemantics: true,
          ),
        ),
      );

      expect(find.semantics.byLabel(_label), findsNothing);
      expect(find.text(_label), findsOneWidget);
      handle.dispose();
    });

    test('requires a label or a semanticLabel', () {
      expect(() => RemixRadio<String>(value: 'b'), throwsAssertionError);
    });

    test('rejects empty labels', () {
      expect(
        () => RemixRadio<String>(value: 'b', label: ''),
        throwsAssertionError,
      );
      expect(
        () => RemixRadio<String>(value: 'b', label: _label, semanticLabel: ''),
        throwsAssertionError,
      );
    });

    testWidgets('rejects blank visible and semantic labels', (tester) async {
      for (final radio in const <RemixRadio<String>>[
        RemixRadio<String>(value: 'b', label: '  '),
        RemixRadio<String>(value: 'b', semanticLabel: '\n'),
      ]) {
        await tester.pumpRemixApp(_group(child: radio));
        expect(tester.takeException(), isA<AssertionError>());
        await tester.pumpWidget(const SizedBox.shrink());
      }
    });
  });

  group('labeled radio layout and styling', () {
    for (final direction in TextDirection.values) {
      testWidgets('uses ambient ${direction.name} visual order', (
        tester,
      ) async {
        await tester.pumpRemixApp(
          _group(
            onChanged: (_) {},
            child: RemixRadio<String>(
              value: 'b',
              label: _label,
              style: RadioStyler().size(16, 16).labelSpacing(12),
            ),
          ),
          textDirection: direction,
        );

        final ringRect = tester.getRect(_ring());
        final labelRect = tester.getRect(find.text(_label));
        final gap = direction == TextDirection.ltr
            ? labelRect.left - ringRect.right
            : ringRect.left - labelRect.right;
        expect(gap, 12);
        expect(
          direction == TextDirection.ltr
              ? ringRect.left < labelRect.left
              : ringRect.left > labelRect.left,
          isTrue,
        );
      });
    }

    testWidgets('wraps a long label at 3x text scaling when width is bounded', (
      tester,
    ) async {
      const label =
          'Bill me every month and send detailed invoices to the finance team';

      await tester.pumpRemixApp(
        MediaQuery(
          data: const MediaQueryData(textScaler: TextScaler.linear(3)),
          child: SizedBox(
            width: 220,
            child: _group(
              onChanged: (_) {},
              child: RemixRadio<String>(
                value: 'b',
                label: label,
                style: RadioStyler().size(16, 16),
              ),
            ),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
      expect(tester.getSize(find.byType(RemixRadio<String>)).width, 220);
      expect(tester.getSize(find.text(label)).height, greaterThan(48));
    });

    testWidgets('lays out without throwing when the width is unbounded', (
      tester,
    ) async {
      await tester.pumpRemixApp(
        _group(
          onChanged: (_) {},
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              RemixRadio<String>(
                value: 'b',
                label: _label,
                style: RadioStyler().size(16, 16).labelSpacing(12),
              ),
            ],
          ),
        ),
      );

      expect(tester.takeException(), isNull);
      expect(
        tester.getSize(find.byType(RemixRadio<String>)).width,
        16 + 12 + tester.getSize(find.text(_label)).width,
      );
    });

    testWidgets('generated label and spacing styles resolve and render', (
      tester,
    ) async {
      await tester.pumpRemixApp(
        _group(
          onChanged: (_) {},
          child: RemixRadio<String>(
            value: 'b',
            label: _label,
            style: RadioStyler()
                .size(16, 16)
                .labelColor(Colors.purple)
                .labelSpacing(14),
          ),
        ),
      );

      final ringRect = tester.getRect(_ring());
      final labelRect = tester.getRect(find.text(_label));
      expect(labelRect.left - ringRect.right, 14);
      expect(
        tester.widget<Text>(find.text(_label)).style?.color,
        Colors.purple,
      );
    });

    testWidgets('raw styleSpec controls label style and spacing', (
      tester,
    ) async {
      const spec = RadioSpec(
        container: StyleSpec(
          spec: BoxSpec(
            constraints: BoxConstraints(
              minWidth: 16,
              maxWidth: 16,
              minHeight: 16,
              maxHeight: 16,
            ),
          ),
        ),
        label: StyleSpec(
          spec: TextSpec(style: TextStyle(color: Colors.orange)),
        ),
        labelSpacing: 10,
      );

      await tester.pumpRemixApp(
        _group(
          onChanged: (_) {},
          child: const RemixRadio<String>(
            value: 'b',
            label: _label,
            styleSpec: spec,
          ),
        ),
      );

      final ringRect = tester.getRect(_ring());
      final labelRect = tester.getRect(find.text(_label));
      expect(labelRect.left - ringRect.right, 10);
      expect(
        tester.widget<Text>(find.text(_label)).style?.color,
        Colors.orange,
      );
    });
  });

  group('disabled labeled radio behavior', () {
    testWidgets('does not select, hover with click cursor, or take focus', (
      tester,
    ) async {
      final focusNode = FocusNode();
      addTearDown(focusNode.dispose);
      var selections = 0;

      await tester.pumpRemixApp(
        _group(
          onChanged: (_) => selections += 1,
          child: RemixRadio<String>(
            value: 'b',
            label: _label,
            enabled: false,
            focusNode: focusNode,
          ),
        ),
      );

      await tester.tap(find.text(_label));
      await tester.pump();
      expect(selections, 0);

      final mouseRegion = tester.widget<MouseRegion>(
        find
            .descendant(
              of: find.byType(RemixRadio<String>),
              matching: find.byType(MouseRegion),
            )
            .first,
      );
      expect(mouseRegion.cursor, SystemMouseCursors.basic);

      focusNode.requestFocus();
      await tester.pump();
      expect(focusNode.hasFocus, isFalse);
    });

    testWidgets('a group without a callback has the same disabled contract', (
      tester,
    ) async {
      final focusNode = FocusNode();
      addTearDown(focusNode.dispose);

      await tester.pumpRemixApp(
        _group(
          child: RemixRadio<String>(
            value: 'b',
            label: _label,
            focusNode: focusNode,
          ),
        ),
      );

      focusNode.requestFocus();
      await tester.pump();
      expect(focusNode.hasFocus, isFalse);
    });

    testWidgets('a disabled style that wraps the control dims the label', (
      tester,
    ) async {
      Future<double> labelOpacity({required bool enabled}) async {
        await tester.pumpRemixApp(
          _group(
            onChanged: (_) {},
            child: RemixRadio<String>(
              value: 'b',
              label: _label,
              enabled: enabled,
              style: RadioStyler().onDisabled(
                RadioStyler().wrap(.opacity(0.4)),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        return tester
            .widgetList<Opacity>(
              find.ancestor(
                of: find.text(_label),
                matching: find.byType(Opacity),
              ),
            )
            .fold<double>(1, (opacity, widget) => opacity * widget.opacity);
      }

      expect(await labelOpacity(enabled: true), 1);
      expect(await labelOpacity(enabled: false), closeTo(0.4, 1e-9));
    });
  });

  group('labeled radio keyboard behavior', () {
    testWidgets('arrow keys and Space move the selection across labels', (
      tester,
    ) async {
      String? selected = 'a';
      final nodes = List<FocusNode>.generate(3, (_) => FocusNode());
      addTearDown(() {
        for (final node in nodes) {
          node.dispose();
        }
      });

      await tester.pumpRemixApp(
        StatefulBuilder(
          builder: (context, setState) {
            return RemixRadioGroup<String>(
              groupValue: selected,
              onChanged: (value) => setState(() => selected = value),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RemixRadio<String>(
                    value: 'a',
                    label: 'Alpha',
                    focusNode: nodes[0],
                  ),
                  RemixRadio<String>(
                    value: 'b',
                    label: 'Bravo',
                    focusNode: nodes[1],
                  ),
                  RemixRadio<String>(
                    value: 'c',
                    label: 'Charlie',
                    focusNode: nodes[2],
                  ),
                ],
              ),
            );
          },
        ),
      );

      nodes[0].requestFocus();
      await tester.pump();

      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pumpAndSettle();
      expect(selected, 'b');
      expect(nodes[1].hasFocus, isTrue);

      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pumpAndSettle();
      expect(selected, 'c');

      nodes[0].requestFocus();
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.space);
      await tester.pumpAndSettle();
      expect(selected, 'a');
    });

    testWidgets('tapping a label selects its radio in the group', (
      tester,
    ) async {
      String? selected = 'a';

      await tester.pumpRemixApp(
        StatefulBuilder(
          builder: (context, setState) {
            return RemixRadioGroup<String>(
              groupValue: selected,
              onChanged: (value) => setState(() => selected = value),
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RemixRadio<String>(value: 'a', label: 'Alpha'),
                  RemixRadio<String>(value: 'b', label: 'Bravo'),
                ],
              ),
            );
          },
        ),
      );

      await tester.tap(find.text('Bravo'));
      await tester.pumpAndSettle();

      expect(selected, 'b');
    });
  });

  group('RadioStyler call surface', () {
    test('forwards the labeled radio API', () {
      final radio = RadioStyler().call<String>(
        value: 'b',
        label: _label,
        minimumTapTargetSize: Size.zero,
      );

      expect(radio.label, _label);
      expect(radio.semanticLabel, isNull);
      expect(radio.minimumTapTargetSize, Size.zero);
    });
  });
}
