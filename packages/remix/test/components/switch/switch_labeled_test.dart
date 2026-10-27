import 'dart:ui' show SemanticsAction, Tristate;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/remix.dart';

import '../../helpers/test_helpers.dart';

const _label = 'Airplane mode';

Finder _track() => find
    .descendant(of: find.byType(RemixSwitch), matching: find.byType(Box))
    .first;

Color? _trackColor(WidgetTester tester) {
  final decoration = tester.widget<Box>(_track()).styleSpec!.spec.decoration;
  return (decoration as BoxDecoration?)?.color;
}

SemanticsNode _expectSingleSwitchNode(WidgetTester tester) {
  final root = tester.getSemantics(find.byType(RemixSwitch));
  final switchNodes = semanticsSubtree(root)
      .where(
        (node) =>
            node.getSemanticsData().flagsCollection.isToggled != Tristate.none,
      )
      .toList();
  expect(switchNodes, hasLength(1));
  return switchNodes.single;
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
  group('labeled switch interaction target', () {
    testWidgets('track, label, gap, and target edges each toggle once', (
      tester,
    ) async {
      var toggles = 0;

      await tester.pumpRemixApp(
        RemixSwitch(
          selected: false,
          label: _label,
          minimumTapTargetSize: const Size.square(48),
          onChanged: (_) => toggles += 1,
          style: SwitchStyler().size(32, 18).labelSpacing(12),
        ),
      );

      final trackRect = tester.getRect(_track());
      final labelRect = tester.getRect(find.text(_label));
      final targetRect = tester.getRect(find.byType(RemixSwitch));
      expect(targetRect.height, 48);
      final tapLocations = <Offset>[
        trackRect.center,
        labelRect.center,
        Offset((trackRect.right + labelRect.left) / 2, targetRect.center.dy),
        targetRect.topLeft + const Offset(1, 1),
        targetRect.topRight + const Offset(-1, 1),
        targetRect.bottomLeft + const Offset(1, -1),
        targetRect.bottomRight + const Offset(-1, -1),
      ];

      for (var i = 0; i < tapLocations.length; i++) {
        await tester.tapAt(tapLocations[i]);
        await tester.pump();
        expect(toggles, i + 1, reason: 'tap location ${tapLocations[i]}');
      }
    });

    testWidgets('an explicit minimum target pads an unlabeled switch', (
      tester,
    ) async {
      await tester.pumpRemixApp(
        RemixSwitch(
          selected: false,
          semanticLabel: _label,
          minimumTapTargetSize: const Size.square(48),
          onChanged: (_) {},
          style: SwitchStyler().size(32, 18),
        ),
      );

      expect(tester.getSize(find.byType(RemixSwitch)), const Size.square(48));
      expect(tester.getSize(_track()), const Size(32, 18));
    });

    testWidgets('keeps the track size by default', (tester) async {
      await tester.pumpRemixApp(
        RemixSwitch(
          selected: false,
          semanticLabel: _label,
          onChanged: (_) {},
          style: SwitchStyler().size(32, 18),
        ),
      );

      expect(tester.getSize(find.byType(RemixSwitch)), const Size(32, 18));
    });

    testWidgets('an unlabeled switch without a target adds no layout', (
      tester,
    ) async {
      await tester.pumpRemixApp(
        SizedBox.square(
          dimension: 48,
          child: RemixSwitch(
            selected: false,
            semanticLabel: _label,
            onChanged: (_) {},
            style: SwitchStyler().size(32, 18),
          ),
        ),
      );

      expect(tester.getSize(_track()), const Size.square(48));
      expect(
        find.descendant(
          of: find.byType(RemixSwitch),
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
          RemixSwitch(
            selected: false,
            label: _label,
            minimumTapTargetSize: invalidSize,
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
        RemixSwitch(
          selected: false,
          label: _label,
          minimumTapTargetSize: const Size.square(48),
          onChanged: (_) {},
          style: SwitchStyler().size(32, 18),
        ),
      );

      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      await expectLater(tester, meetsGuideline(iOSTapTargetGuideline));
      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
      handle.dispose();
    });
  });

  group('labeled switch hover, press, and focus', () {
    testWidgets('hovering the label applies the hovered style to the track', (
      tester,
    ) async {
      await tester.pumpRemixApp(
        RemixSwitch(
          selected: false,
          label: _label,
          onChanged: (_) {},
          style: SwitchStyler()
              .size(32, 18)
              .trackColor(Colors.blue)
              .onHovered(SwitchStyler().trackColor(Colors.green)),
        ),
      );
      expect(_trackColor(tester), Colors.blue);

      final mouse = await _hoverAt(tester, tester.getCenter(find.text(_label)));
      expect(_trackColor(tester), Colors.green);

      await mouse.moveTo(const Offset(2, 2));
      await tester.pumpAndSettle();
      expect(_trackColor(tester), Colors.blue);
    });

    testWidgets('pressing the label applies the pressed style to the track', (
      tester,
    ) async {
      await tester.pumpRemixApp(
        RemixSwitch(
          selected: false,
          label: _label,
          onChanged: (_) {},
          style: SwitchStyler()
              .size(32, 18)
              .trackColor(Colors.blue)
              .onPressed(SwitchStyler().trackColor(Colors.red)),
        ),
      );
      expect(_trackColor(tester), Colors.blue);

      final press = await tester.startGesture(
        tester.getCenter(find.text(_label)),
      );
      await tester.pumpAndSettle();
      expect(_trackColor(tester), Colors.red);

      await press.up();
      await tester.pumpAndSettle();
      expect(_trackColor(tester), Colors.blue);
    });

    testWidgets('focus applies the focused style to the label', (tester) async {
      final focusNode = FocusNode();
      addTearDown(focusNode.dispose);

      await tester.pumpRemixApp(
        RemixSwitch(
          selected: false,
          label: _label,
          focusNode: focusNode,
          onChanged: (_) {},
          style: SwitchStyler().onFocused(
            SwitchStyler().labelColor(Colors.red),
          ),
        ),
      );

      focusNode.requestFocus();
      await tester.pumpAndSettle();

      expect(tester.widget<Text>(find.text(_label)).style?.color, Colors.red);
    });

    testWidgets('the selected style reaches the label', (tester) async {
      Future<Color?> labelColor({required bool selected}) async {
        await tester.pumpRemixApp(
          RemixSwitch(
            selected: selected,
            label: _label,
            onChanged: (_) {},
            style: SwitchStyler().onSelected(
              SwitchStyler().labelColor(Colors.green),
            ),
          ),
        );
        return tester.widget<Text>(find.text(_label)).style?.color;
      }

      expect(await labelColor(selected: false), isNot(Colors.green));
      expect(await labelColor(selected: true), Colors.green);
    });
  });

  group('labeled switch semantics', () {
    for (final selected in const [false, true]) {
      testWidgets('exposes one exact ${selected ? 'on' : 'off'} switch node', (
        tester,
      ) async {
        final handle = tester.ensureSemantics();

        await tester.pumpRemixApp(
          RemixSwitch(selected: selected, label: _label, onChanged: (_) {}),
        );

        expect(
          _expectSingleSwitchNode(tester),
          matchesSemantics(
            label: _label,
            textDirection: TextDirection.ltr,
            hasToggledState: true,
            isToggled: selected,
            hasEnabledState: true,
            isEnabled: true,
            isFocusable: true,
            hasTapAction: true,
            hasFocusAction: true,
            children: const <Matcher>[],
          ),
        );
        handle.dispose();
      });
    }

    testWidgets('a disabled switch keeps its name and drops its actions', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();

      await tester.pumpRemixApp(
        const RemixSwitch(selected: false, label: _label),
      );

      final data = _expectSingleSwitchNode(tester).getSemanticsData();
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
          RemixSwitch(
            selected: false,
            label: 'Airplane',
            semanticLabel: 'Airplane mode, disables radios',
            onChanged: (_) {},
          ),
        );

        final node = _expectSingleSwitchNode(tester);
        expect(node.getSemanticsData().label, 'Airplane mode, disables radios');
        expect(find.text('Airplane'), findsOneWidget);
        final labeledNodes = semanticsSubtree(
          tester.getSemantics(find.byType(RemixSwitch)),
        ).where((node) => node.getSemanticsData().label.isNotEmpty);
        expect(labeledNodes, hasLength(1));
        handle.dispose();
      },
    );

    testWidgets(
      'a semanticLabel alone names a switch without a visible label',
      (tester) async {
        final handle = tester.ensureSemantics();

        await tester.pumpRemixApp(
          RemixSwitch(
            selected: false,
            semanticLabel: _label,
            onChanged: (_) {},
          ),
        );

        expect(
          _expectSingleSwitchNode(tester).getSemanticsData().label,
          _label,
        );
        handle.dispose();
      },
    );

    testWidgets('semantic tap and focus actions activate the whole control', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      final focusNode = FocusNode();
      addTearDown(focusNode.dispose);
      var toggles = 0;

      await tester.pumpRemixApp(
        RemixSwitch(
          selected: false,
          label: _label,
          focusNode: focusNode,
          onChanged: (_) => toggles += 1,
        ),
      );

      final node = _expectSingleSwitchNode(tester);
      node.owner!.performAction(node.id, SemanticsAction.tap);
      await tester.pump();
      expect(toggles, 1);

      node.owner!.performAction(node.id, SemanticsAction.focus);
      await tester.pump();
      expect(focusNode.hasFocus, isTrue);
      handle.dispose();
    });

    testWidgets('excludeSemantics hides the switch and its label', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();

      await tester.pumpRemixApp(
        RemixSwitch(
          selected: false,
          label: _label,
          excludeSemantics: true,
          onChanged: (_) {},
        ),
      );

      expect(find.semantics.byLabel(_label), findsNothing);
      expect(find.text(_label), findsOneWidget);
      handle.dispose();
    });

    test('requires a label or a semanticLabel', () {
      expect(() => RemixSwitch(selected: false), throwsAssertionError);
    });

    test('rejects empty labels', () {
      expect(
        () => RemixSwitch(selected: false, label: ''),
        throwsAssertionError,
      );
      expect(
        () => RemixSwitch(selected: false, label: _label, semanticLabel: ''),
        throwsAssertionError,
      );
    });

    testWidgets('rejects blank visible and semantic labels', (tester) async {
      for (final switchWidget in const <RemixSwitch>[
        RemixSwitch(selected: false, label: '  '),
        RemixSwitch(selected: false, semanticLabel: '\n'),
      ]) {
        await tester.pumpRemixApp(switchWidget);
        expect(tester.takeException(), isA<AssertionError>());
        await tester.pumpWidget(const SizedBox.shrink());
      }
    });
  });

  group('labeled switch layout and styling', () {
    for (final direction in TextDirection.values) {
      testWidgets('uses ambient ${direction.name} visual order', (
        tester,
      ) async {
        await tester.pumpRemixApp(
          RemixSwitch(
            selected: false,
            label: _label,
            onChanged: (_) {},
            style: SwitchStyler().size(32, 18).labelSpacing(12),
          ),
          textDirection: direction,
        );

        final trackRect = tester.getRect(_track());
        final labelRect = tester.getRect(find.text(_label));
        final gap = direction == TextDirection.ltr
            ? labelRect.left - trackRect.right
            : trackRect.left - labelRect.right;
        expect(gap, 12);
        expect(
          direction == TextDirection.ltr
              ? trackRect.left < labelRect.left
              : trackRect.left > labelRect.left,
          isTrue,
        );
      });
    }

    testWidgets('wraps a long label at 3x text scaling when width is bounded', (
      tester,
    ) async {
      const label =
          'Disable every wireless radio and stop all background network use';

      await tester.pumpRemixApp(
        MediaQuery(
          data: const MediaQueryData(textScaler: TextScaler.linear(3)),
          child: SizedBox(
            width: 220,
            child: RemixSwitch(
              selected: false,
              label: label,
              onChanged: (_) {},
              style: SwitchStyler().size(32, 18),
            ),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
      expect(tester.getSize(find.byType(RemixSwitch)).width, 220);
      expect(tester.getSize(find.text(label)).height, greaterThan(48));
    });

    testWidgets('lays out without throwing when the width is unbounded', (
      tester,
    ) async {
      await tester.pumpRemixApp(
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            RemixSwitch(
              selected: false,
              label: _label,
              onChanged: (_) {},
              style: SwitchStyler().size(32, 18).labelSpacing(12),
            ),
          ],
        ),
      );

      expect(tester.takeException(), isNull);
      expect(
        tester.getSize(find.byType(RemixSwitch)).width,
        32 + 12 + tester.getSize(find.text(_label)).width,
      );
    });

    testWidgets('generated label and spacing styles resolve and render', (
      tester,
    ) async {
      await tester.pumpRemixApp(
        RemixSwitch(
          selected: false,
          label: _label,
          onChanged: (_) {},
          style: SwitchStyler()
              .size(32, 18)
              .labelColor(Colors.purple)
              .labelSpacing(14),
        ),
      );

      final trackRect = tester.getRect(_track());
      final labelRect = tester.getRect(find.text(_label));
      expect(labelRect.left - trackRect.right, 14);
      expect(
        tester.widget<Text>(find.text(_label)).style?.color,
        Colors.purple,
      );
    });

    testWidgets('raw styleSpec controls label style and spacing', (
      tester,
    ) async {
      const spec = SwitchSpec(
        container: StyleSpec(
          spec: BoxSpec(
            constraints: BoxConstraints(
              minWidth: 32,
              maxWidth: 32,
              minHeight: 18,
              maxHeight: 18,
            ),
          ),
        ),
        label: StyleSpec(
          spec: TextSpec(style: TextStyle(color: Colors.orange)),
        ),
        labelSpacing: 10,
      );

      await tester.pumpRemixApp(
        RemixSwitch(
          selected: false,
          label: _label,
          onChanged: (_) {},
          styleSpec: spec,
        ),
      );

      final trackRect = tester.getRect(_track());
      final labelRect = tester.getRect(find.text(_label));
      expect(labelRect.left - trackRect.right, 10);
      expect(
        tester.widget<Text>(find.text(_label)).style?.color,
        Colors.orange,
      );
    });
  });

  group('disabled labeled switch behavior', () {
    testWidgets('does not toggle, hover with click cursor, or take focus', (
      tester,
    ) async {
      final focusNode = FocusNode();
      addTearDown(focusNode.dispose);
      var toggles = 0;

      await tester.pumpRemixApp(
        RemixSwitch(
          selected: false,
          enabled: false,
          label: _label,
          focusNode: focusNode,
          onChanged: (_) => toggles += 1,
        ),
      );

      await tester.tap(find.text(_label));
      await tester.pump();
      expect(toggles, 0);

      final mouseRegion = tester.widget<MouseRegion>(
        find
            .descendant(
              of: find.byType(RemixSwitch),
              matching: find.byType(MouseRegion),
            )
            .first,
      );
      expect(mouseRegion.cursor, SystemMouseCursors.basic);

      focusNode.requestFocus();
      await tester.pump();
      expect(focusNode.hasFocus, isFalse);
    });

    testWidgets('a null callback has the same disabled contract', (
      tester,
    ) async {
      final focusNode = FocusNode();
      addTearDown(focusNode.dispose);

      await tester.pumpRemixApp(
        RemixSwitch(selected: false, label: _label, focusNode: focusNode),
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
          RemixSwitch(
            selected: false,
            label: _label,
            enabled: enabled,
            onChanged: (_) {},
            style: SwitchStyler().onDisabled(
              SwitchStyler().wrap(.opacity(0.4)),
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

  group('labeled switch keyboard behavior', () {
    for (final key in [LogicalKeyboardKey.space, LogicalKeyboardKey.enter]) {
      testWidgets('${key.keyLabel} toggles the focused switch', (tester) async {
        var selected = false;
        final focusNode = FocusNode();
        addTearDown(focusNode.dispose);

        await tester.pumpRemixApp(
          StatefulBuilder(
            builder: (context, setState) {
              return RemixSwitch(
                selected: selected,
                label: _label,
                focusNode: focusNode,
                onChanged: (value) => setState(() => selected = value),
              );
            },
          ),
        );

        focusNode.requestFocus();
        await tester.pump();
        await tester.sendKeyEvent(key);
        await tester.pumpAndSettle();

        expect(selected, isTrue);
      });
    }

    testWidgets('tapping the label toggles the switch', (tester) async {
      var selected = false;

      await tester.pumpRemixApp(
        StatefulBuilder(
          builder: (context, setState) {
            return RemixSwitch(
              selected: selected,
              label: _label,
              onChanged: (value) => setState(() => selected = value),
            );
          },
        ),
      );

      await tester.tap(find.text(_label));
      await tester.pumpAndSettle();
      expect(selected, isTrue);

      await tester.tap(find.text(_label));
      await tester.pumpAndSettle();
      expect(selected, isFalse);
    });
  });

  group('SwitchStyler call surface', () {
    test('forwards the labeled switch API', () {
      final switchWidget = SwitchStyler().call(
        selected: false,
        label: _label,
        minimumTapTargetSize: Size.zero,
      );

      expect(switchWidget.label, _label);
      expect(switchWidget.semanticLabel, isNull);
      expect(switchWidget.minimumTapTargetSize, Size.zero);
    });
  });
}
