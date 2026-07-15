import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:naked_ui/naked_ui.dart';
import 'package:remix/remix.dart';

import '../../helpers/test_helpers.dart';
import '../../helpers/test_methods.dart';

List<RemixToggleGroupItem<String>> _items(
  List<FocusNode> nodes, {
  bool disableMiddle = false,
}) {
  return [
    RemixToggleGroupItem(
      value: 'list',
      label: 'List',
      icon: Icons.view_list,
      focusNode: nodes[0],
    ),
    RemixToggleGroupItem(
      value: 'grid',
      label: 'Grid',
      icon: Icons.grid_view,
      enabled: !disableMiddle,
      focusNode: nodes[1],
    ),
    RemixToggleGroupItem(
      value: 'board',
      label: 'Board',
      icon: Icons.view_kanban,
      focusNode: nodes[2],
    ),
  ];
}

List<FocusNode> _focusNodes() => List.generate(3, (index) => FocusNode());

void _disposeNodes(List<FocusNode> nodes) {
  for (final node in nodes) {
    node.dispose();
  }
}

void main() {
  group('RemixToggleGroup', () {
    testWidgets('renders all items', (tester) async {
      final nodes = _focusNodes();
      addTearDown(() => _disposeNodes(nodes));

      await tester.pumpRemixApp(
        RemixToggleGroup<String>(
          items: _items(nodes),
          selectedValue: 'list',
          onChanged: (_) {},
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(NakedToggleGroup<String>), findsOneWidget);
      expect(find.byType(NakedToggleOption<String>), findsNWidgets(3));
      expect(find.text('List'), findsOneWidget);
      expect(find.text('Grid'), findsOneWidget);
      expect(find.text('Board'), findsOneWidget);
      expect(find.byIcon(Icons.grid_view), findsOneWidget);
    });

    testWidgets('shrink-wraps the segmented-control container', (tester) async {
      final nodes = _focusNodes();
      addTearDown(() => _disposeNodes(nodes));

      await tester.pumpRemixApp(
        FortalToggleGroup<String>(
          items: _items(nodes),
          selectedValue: 'list',
          onChanged: (_) {},
        ),
      );
      await tester.pumpAndSettle();

      final size = tester.getSize(find.byType(FlexBox));
      expect(size.width, lessThan(400));
      expect(size.height, lessThan(100));
    });

    testWidgets('styleSpec preserves vertical layout orientation', (
      tester,
    ) async {
      await tester.pumpRemixApp(
        RemixToggleGroup<String>(
          items: const [
            RemixToggleGroupItem(value: 'list', label: 'List'),
            RemixToggleGroupItem(value: 'grid', label: 'Grid'),
          ],
          selectedValue: 'list',
          onChanged: (_) {},
          orientation: Axis.vertical,
          styleSpec: const RemixToggleGroupSpec(),
        ),
      );
      await tester.pumpAndSettle();

      final listPosition = tester.getTopLeft(find.text('List'));
      final gridPosition = tester.getTopLeft(find.text('Grid'));
      expect(listPosition.dx, gridPosition.dx);
      expect(listPosition.dy, lessThan(gridPosition.dy));
    });

    testWidgets('item context variants compose with item state variants', (
      tester,
    ) async {
      final style = RemixToggleGroupStyler(
        item: RemixToggleGroupItemStyler()
            .foregroundColor(Colors.red)
            .onSelected(
              RemixToggleGroupItemStyler().foregroundColor(Colors.blue),
            )
            .onRtl(
              RemixToggleGroupItemStyler().foregroundColor(Colors.green),
            ),
      );

      await tester.pumpRemixApp(
        RemixToggleGroup<String>(
          items: const [
            RemixToggleGroupItem(value: 'selected', label: 'Selected'),
            RemixToggleGroupItem(value: 'other', label: 'Other'),
          ],
          selectedValue: 'selected',
          onChanged: (_) {},
          style: style,
        ),
        textDirection: TextDirection.rtl,
      );
      await tester.pumpAndSettle();

      expect(
        tester.widget<Text>(find.text('Selected')).style?.color,
        Colors.blue,
      );
      expect(
        tester.widget<Text>(find.text('Other')).style?.color,
        Colors.green,
      );
    });

    testWidgets('tapping an item selects its value', (tester) async {
      final nodes = _focusNodes();
      addTearDown(() => _disposeNodes(nodes));
      String? selected;

      await tester.pumpRemixApp(
        RemixToggleGroup<String>(
          items: _items(nodes),
          selectedValue: 'list',
          onChanged: (value) => selected = value,
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Grid'));
      await tester.pumpAndSettle();

      expect(selected, 'grid');
    });

    testWidgets('a disabled item ignores taps', (tester) async {
      final nodes = _focusNodes();
      addTearDown(() => _disposeNodes(nodes));
      var changes = 0;

      await tester.pumpRemixApp(
        RemixToggleGroup<String>(
          items: _items(nodes, disableMiddle: true),
          selectedValue: 'list',
          onChanged: (_) => changes += 1,
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Grid'));
      await tester.pumpAndSettle();

      expect(changes, 0);
    });

    testWidgets('exposes one tab stop and then exits the group', (
      tester,
    ) async {
      final nodes = _focusNodes();
      final before = FocusNode();
      final after = FocusNode();
      addTearDown(() {
        _disposeNodes(nodes);
        before.dispose();
        after.dispose();
      });

      await tester.pumpRemixApp(
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton(
              focusNode: before,
              autofocus: true,
              onPressed: () {},
              child: const Text('Before'),
            ),
            RemixToggleGroup<String>(
              items: _items(nodes),
              selectedValue: 'grid',
              onChanged: (_) {},
            ),
            TextButton(
              focusNode: after,
              onPressed: () {},
              child: const Text('After'),
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();
      expect(before.hasFocus, isTrue);

      await sendKeyAndSettle(tester, LogicalKeyboardKey.tab);
      expect(nodes[1].hasFocus, isTrue);

      await sendKeyAndSettle(tester, LogicalKeyboardKey.tab);
      expect(after.hasFocus, isTrue);
    });

    for (final (orientation, key) in [
      (Axis.horizontal, LogicalKeyboardKey.arrowRight),
      (Axis.vertical, LogicalKeyboardKey.arrowDown),
    ]) {
      testWidgets('$key moves focus forward without selecting', (tester) async {
        final nodes = _focusNodes();
        addTearDown(() => _disposeNodes(nodes));
        var changes = 0;

        await tester.pumpRemixApp(
          RemixToggleGroup<String>(
            items: _items(nodes),
            selectedValue: 'list',
            onChanged: (_) => changes += 1,
            orientation: orientation,
          ),
        );
        await tester.pumpAndSettle();
        nodes[0].requestFocus();
        await tester.pumpAndSettle();

        await sendKeyAndSettle(tester, key);

        expect(nodes[1].hasFocus, isTrue);
        expect(changes, 0);
      });
    }

    for (final (orientation, key) in [
      (Axis.horizontal, LogicalKeyboardKey.arrowLeft),
      (Axis.vertical, LogicalKeyboardKey.arrowUp),
    ]) {
      testWidgets('$key moves focus backward', (tester) async {
        final nodes = _focusNodes();
        addTearDown(() => _disposeNodes(nodes));

        await tester.pumpRemixApp(
          RemixToggleGroup<String>(
            items: _items(nodes),
            selectedValue: 'grid',
            onChanged: (_) {},
            orientation: orientation,
          ),
        );
        await tester.pumpAndSettle();
        nodes[1].requestFocus();
        await tester.pumpAndSettle();

        await sendKeyAndSettle(tester, key);

        expect(nodes[0].hasFocus, isTrue);
      });
    }

    testWidgets('Home and End move to the first and last item', (tester) async {
      final nodes = _focusNodes();
      addTearDown(() => _disposeNodes(nodes));

      await tester.pumpRemixApp(
        RemixToggleGroup<String>(
          items: _items(nodes),
          selectedValue: 'grid',
          onChanged: (_) {},
        ),
      );
      await tester.pumpAndSettle();
      nodes[1].requestFocus();
      await tester.pumpAndSettle();

      await sendKeyAndSettle(tester, LogicalKeyboardKey.home);
      expect(nodes[0].hasFocus, isTrue);

      await sendKeyAndSettle(tester, LogicalKeyboardKey.end);
      expect(nodes[2].hasFocus, isTrue);
    });

    testWidgets('arrow traversal skips disabled items', (tester) async {
      final nodes = _focusNodes();
      addTearDown(() => _disposeNodes(nodes));

      await tester.pumpRemixApp(
        RemixToggleGroup<String>(
          items: _items(nodes, disableMiddle: true),
          selectedValue: 'list',
          onChanged: (_) {},
        ),
      );
      await tester.pumpAndSettle();
      nodes[0].requestFocus();
      await tester.pumpAndSettle();

      await sendKeyAndSettle(tester, LogicalKeyboardKey.arrowRight);

      expect(nodes[2].hasFocus, isTrue);
      expect(nodes[1].hasFocus, isFalse);
    });

    testWidgets('loop wraps while non-looping navigation clamps', (
      tester,
    ) async {
      final loopingNodes = _focusNodes();
      final clampedNodes = _focusNodes();
      addTearDown(() {
        _disposeNodes(loopingNodes);
        _disposeNodes(clampedNodes);
      });

      await tester.pumpRemixApp(
        RemixToggleGroup<String>(
          items: _items(loopingNodes),
          selectedValue: 'board',
          onChanged: (_) {},
        ),
      );
      await tester.pumpAndSettle();
      loopingNodes[2].requestFocus();
      await tester.pumpAndSettle();
      await sendKeyAndSettle(tester, LogicalKeyboardKey.arrowRight);
      expect(loopingNodes[0].hasFocus, isTrue);

      await tester.pumpRemixApp(
        RemixToggleGroup<String>(
          items: _items(clampedNodes),
          selectedValue: 'board',
          onChanged: (_) {},
          loop: false,
        ),
      );
      await tester.pumpAndSettle();
      clampedNodes[2].requestFocus();
      await tester.pumpAndSettle();
      await sendKeyAndSettle(tester, LogicalKeyboardKey.arrowRight);
      expect(clampedNodes[2].hasFocus, isTrue);
    });

    testWidgets('RTL inverts horizontal arrow direction', (tester) async {
      final nodes = _focusNodes();
      addTearDown(() => _disposeNodes(nodes));

      await tester.pumpRemixApp(
        RemixToggleGroup<String>(
          items: _items(nodes),
          selectedValue: 'grid',
          onChanged: (_) {},
        ),
        textDirection: TextDirection.rtl,
      );
      await tester.pumpAndSettle();
      nodes[1].requestFocus();
      await tester.pumpAndSettle();

      await sendKeyAndSettle(tester, LogicalKeyboardKey.arrowRight);

      expect(nodes[0].hasFocus, isTrue);
    });

    for (final key in [LogicalKeyboardKey.space, LogicalKeyboardKey.enter]) {
      testWidgets('$key activates the focused item', (tester) async {
        final nodes = _focusNodes();
        addTearDown(() => _disposeNodes(nodes));
        String? selected;

        await tester.pumpRemixApp(
          RemixToggleGroup<String>(
            items: _items(nodes),
            selectedValue: 'list',
            onChanged: (value) => selected = value,
          ),
        );
        await tester.pumpAndSettle();
        nodes[1].requestFocus();
        await tester.pumpAndSettle();

        await sendKeyAndSettle(tester, key);

        expect(selected, 'grid');
      });
    }

    testWidgets('a disabled group has no tab stop', (tester) async {
      final nodes = _focusNodes();
      final before = FocusNode();
      final after = FocusNode();
      addTearDown(() {
        _disposeNodes(nodes);
        before.dispose();
        after.dispose();
      });

      await tester.pumpRemixApp(
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton(
              focusNode: before,
              autofocus: true,
              onPressed: () {},
              child: const Text('Before'),
            ),
            RemixToggleGroup<String>(
              items: _items(nodes),
              selectedValue: 'list',
              onChanged: (_) {},
              enabled: false,
            ),
            TextButton(
              focusNode: after,
              onPressed: () {},
              child: const Text('After'),
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();

      await sendKeyAndSettle(tester, LogicalKeyboardKey.tab);

      expect(after.hasFocus, isTrue);
      expect(nodes.every((node) => !node.hasFocus), isTrue);
    });

    testWidgets('icon-only items use their semantic label', (tester) async {
      final semantics = tester.ensureSemantics();

      await tester.pumpRemixApp(
        RemixToggleGroup<String>(
          items: const [
            RemixToggleGroupItem(
              value: 'grid',
              icon: Icons.grid_view,
              semanticLabel: 'Grid view',
            ),
          ],
          selectedValue: 'grid',
          onChanged: (_) {},
        ),
      );
      await tester.pumpAndSettle();

      final option = find.bySemanticsLabel('Grid view');
      expect(option, findsOneWidget);
      expect(
        tester.getSemantics(option),
        isSemantics(
          label: 'Grid view',
          isButton: true,
          isSelected: true,
          hasSelectedState: true,
        ),
      );

      semantics.dispose();
    });

    testWidgets('vertical orientation ignores horizontal arrows', (
      tester,
    ) async {
      final nodes = _focusNodes();
      addTearDown(() => _disposeNodes(nodes));

      await tester.pumpRemixApp(
        RemixToggleGroup<String>(
          items: _items(nodes),
          selectedValue: 'list',
          onChanged: (_) {},
          orientation: Axis.vertical,
        ),
      );
      await tester.pumpAndSettle();
      nodes[0].requestFocus();
      await tester.pumpAndSettle();

      await sendKeyAndSettle(tester, LogicalKeyboardKey.arrowRight);
      expect(nodes[0].hasFocus, isTrue);

      await sendKeyAndSettle(tester, LogicalKeyboardKey.arrowDown);
      expect(nodes[1].hasFocus, isTrue);
    });
  });

  group('item widget states', () {
    late List<FocusNode> selectedNodes;
    widgetControllerTestAt<RemixToggleGroupItemSpec>(
      'selected item exposes selected state',
      index: 1,
      build: () {
        selectedNodes = _focusNodes();
        addTearDown(() => _disposeNodes(selectedNodes));
        return RemixToggleGroup<String>(
          items: _items(selectedNodes),
          selectedValue: 'grid',
          onChanged: (_) {},
        );
      },
      expectedStates: {WidgetState.selected},
    );

    late List<FocusNode> focusedNodes;
    widgetControllerTestAt<RemixToggleGroupItemSpec>(
      'focused item exposes focused state',
      index: 0,
      build: () {
        focusedNodes = _focusNodes();
        addTearDown(() => _disposeNodes(focusedNodes));
        return RemixToggleGroup<String>(
          items: _items(focusedNodes),
          selectedValue: 'grid',
          onChanged: (_) {},
        );
      },
      act: (tester) async {
        focusedNodes[0].requestFocus();
        await tester.pumpAndSettle();
      },
      expectedStates: {WidgetState.focused},
    );
  });
}
