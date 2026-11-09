import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:naked_ui/naked_ui.dart';

import 'semantics_test_utils.dart';

void main() {
  Widget testApp({
    required List<double> values,
    ValueChanged<List<double>>? onChanged,
    double min = 0,
    double max = 100,
    double step = 1,
    double minSpacing = 0,
    bool enabled = true,
    List<FocusNode?>? focusNodes,
    List<String?>? labels,
    List<NakedSliderSemanticFormatterCallback?>? formatters,
    bool excludeSemantics = false,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: NakedSlider(
            values: values,
            min: min,
            max: max,
            step: step,
            minSpacing: minSpacing,
            enabled: enabled,
            focusNodes: focusNodes,
            semanticLabels: labels,
            semanticFormatterCallbacks: formatters,
            excludeSemantics: excludeSemantics,
            onChanged: onChanged,
            child: const SizedBox(width: 240, height: 48),
          ),
        ),
      ),
    );
  }

  List<SemanticsNode> sliderNodes(WidgetTester tester) {
    final root = tester.getSemantics(find.byType(Scaffold));

    return collectSemanticsNodes(
      root,
      (node) => node.getSemanticsData().flagsCollection.isSlider,
    );
  }

  void performAction(
    WidgetTester tester,
    SemanticsNode node,
    ui.SemanticsAction action,
  ) {
    tester.binding.performSemanticsAction(
      ui.SemanticsActionEvent(
        type: action,
        viewId: tester.view.viewId,
        nodeId: node.id,
      ),
    );
  }

  group('NakedSlider semantics', () {
    testWidgets('exposes one independent slider node per thumb', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(
        testApp(
          values: const [20, 50, 80],
          labels: const ['Minimum', 'Target', 'Maximum'],
          onChanged: (_) {},
        ),
      );

      final nodes = sliderNodes(tester);
      expect(nodes, hasLength(3));
      expect(nodes.map(summarizeNode).map((summary) => summary.label), [
        'Minimum',
        'Target',
        'Maximum',
      ]);
      expect(nodes.map(summarizeNode).map((summary) => summary.value), [
        '20%',
        '50%',
        '80%',
      ]);
      for (final summary in nodes.map(summarizeNode)) {
        expect(summary.flags, containsAll(['isSlider', 'hasEnabledState']));
        expect(summary.flags, contains('isEnabled'));
        expect(summary.actions, containsAll(['focus', 'increase', 'decrease']));
      }
      handle.dispose();
    });

    testWidgets('each thumb uses its own semantic formatter', (tester) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(
        testApp(
          values: const [20, 80],
          step: 10,
          formatters: [
            (value) => 'From ${value.round()} dollars',
            (value) => 'To ${value.round()} dollars',
          ],
          onChanged: (_) {},
        ),
      );

      final summaries = sliderNodes(tester).map(summarizeNode).toList();
      expect(summaries[0].value, 'From 20 dollars');
      expect(summaries[0].increasedValue, 'From 30 dollars');
      expect(summaries[0].decreasedValue, 'From 10 dollars');
      expect(summaries[1].value, 'To 80 dollars');
      expect(summaries[1].increasedValue, 'To 90 dollars');
      expect(summaries[1].decreasedValue, 'To 70 dollars');
      handle.dispose();
    });

    testWidgets('disabled thumbs expose values without actions', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(
        testApp(values: const [25, 75], enabled: false, onChanged: (_) {}),
      );

      final summaries = sliderNodes(tester).map(summarizeNode).toList();
      expect(summaries, hasLength(2));
      for (final summary in summaries) {
        expect(summary.flags, containsAll(['isSlider', 'hasEnabledState']));
        expect(summary.flags, isNot(contains('isEnabled')));
        expect(summary.actions, isEmpty);
      }
      handle.dispose();
    });

    testWidgets('focus state belongs only to the focused thumb', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      final first = FocusNode();
      final second = FocusNode();
      addTearDown(first.dispose);
      addTearDown(second.dispose);
      await tester.pumpWidget(
        testApp(
          values: const [25, 75],
          focusNodes: [first, second],
          onChanged: (_) {},
        ),
      );

      second.requestFocus();
      await tester.pump();

      final summaries = sliderNodes(tester).map(summarizeNode).toList();
      expect(summaries[0].flags, isNot(contains('isFocused')));
      expect(summaries[1].flags, contains('isFocused'));
      handle.dispose();
    });

    testWidgets('boundary thumbs omit impossible semantic actions', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(
        testApp(values: const [0, 100], onChanged: (_) {}),
      );

      final summaries = sliderNodes(tester).map(summarizeNode).toList();
      expect(summaries[0].actions, isNot(contains('decrease')));
      expect(summaries[0].decreasedValue, isNull);
      expect(summaries[1].actions, isNot(contains('increase')));
      expect(summaries[1].increasedValue, isNull);
      handle.dispose();
    });

    testWidgets('minimum spacing suppresses blocked semantic actions', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(
        testApp(values: const [40, 50], minSpacing: 10, onChanged: (_) {}),
      );

      final summaries = sliderNodes(tester).map(summarizeNode).toList();
      expect(summaries[0].actions, isNot(contains('increase')));
      expect(summaries[1].actions, isNot(contains('decrease')));
      handle.dispose();
    });

    testWidgets('semantic action changes only its target thumb', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      var values = <double>[20, 80];
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) => NakedSlider(
                values: values,
                step: 5,
                onChanged: (next) =>
                    setState(() => values = List<double>.of(next)),
                child: const SizedBox(width: 240, height: 48),
              ),
            ),
          ),
        ),
      );

      var nodes = sliderNodes(tester);
      performAction(tester, nodes[1], ui.SemanticsAction.decrease);
      await tester.pump();
      expect(values, [20, 75]);

      nodes = sliderNodes(tester);
      performAction(tester, nodes[0], ui.SemanticsAction.increase);
      await tester.pump();
      expect(values, [25, 75]);
      handle.dispose();
    });

    testWidgets('excludeSemantics hides every thumb node', (tester) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(
        testApp(
          values: const [25, 75],
          excludeSemantics: true,
          onChanged: (_) {},
        ),
      );

      expect(sliderNodes(tester), isEmpty);
      handle.dispose();
    });
  });

  testWidgets(
    'semantic focus and Tab traversal retain lower upper identities in RTL',
    (tester) async {
      final handle = tester.ensureSemantics();
      for (final direction in TextDirection.values) {
        for (final values in [
          const [0.0, 100.0],
          const [50.0, 50.0],
        ]) {
          final before = FocusNode(),
              lower = FocusNode(),
              upper = FocusNode(),
              after = FocusNode();
          await tester.pumpWidget(
            MaterialApp(
              home: Directionality(
                textDirection: direction,
                child: Scaffold(
                  body: Center(
                    child: FocusTraversalGroup(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Focus(
                            focusNode: before,
                            child: const SizedBox(height: 8),
                          ),
                          NakedSlider(
                            values: values,
                            focusNodes: [lower, upper],
                            onChanged: (_) {},
                            child: const SizedBox(width: 240, height: 48),
                          ),
                          Focus(
                            focusNode: after,
                            child: const SizedBox(height: 8),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
          performAction(
            tester,
            sliderNodes(tester)[1],
            ui.SemanticsAction.focus,
          );
          await tester.pump();
          expect(upper.hasPrimaryFocus, isTrue);
          before.requestFocus();
          await tester.pump();
          for (final node in [lower, upper, after]) {
            await tester.sendKeyEvent(LogicalKeyboardKey.tab);
            await tester.pump();
            expect(node.hasPrimaryFocus, isTrue);
          }
          await tester.sendKeyDownEvent(LogicalKeyboardKey.shiftLeft);
          for (final node in [upper, lower, before]) {
            await tester.sendKeyEvent(LogicalKeyboardKey.tab);
            await tester.pump();
            expect(node.hasPrimaryFocus, isTrue);
          }
          await tester.sendKeyUpEvent(LogicalKeyboardKey.shiftLeft);
          await tester.pumpWidget(const SizedBox());
          for (final node in [before, lower, upper, after]) {
            node.dispose();
          }
        }
      }
      handle.dispose();
    },
  );

  for (final (minimum, step, gap, spacing) in [
    (1e15, .25, 1.5, 1.0),
    (1e12, 1 / 4096, 6 / 4096, 4 / 4096),
  ]) {
    for (final index in [0, 1]) {
      testWidgets(
        'offset $minimum preserves real spacing headroom for thumb $index',
        (tester) async {
          final handle = tester.ensureSemantics();
          try {
            final focus = FocusNode();
            addTearDown(focus.dispose);
            var values = <double>[minimum, minimum + gap];
            final requests = <List<double>>[];
            await tester.pumpWidget(
              StatefulBuilder(
                builder: (context, setState) => testApp(
                  values: values,
                  min: minimum,
                  max: minimum + 10,
                  step: step,
                  minSpacing: spacing,
                  focusNodes: [
                    index == 0 ? focus : null,
                    index == 1 ? focus : null,
                  ],
                  onChanged: (next) {
                    requests.add(next);
                    setState(() => values = next);
                  },
                ),
              ),
            );

            final action = index == 0
                ? ui.SemanticsAction.increase
                : ui.SemanticsAction.decrease;
            final node = sliderNodes(tester)[index];
            expect(node.getSemanticsData().hasAction(action), isTrue);
            performAction(tester, node, action);
            await tester.pump();
            expect(requests, [
              index == 0
                  ? [minimum + step, minimum + gap]
                  : [minimum, minimum + gap - step],
            ]);

            focus.requestFocus();
            await tester.pump();
            await tester.sendKeyEvent(
              index == 0
                  ? LogicalKeyboardKey.arrowRight
                  : LogicalKeyboardKey.arrowLeft,
            );
            await tester.pump();
            expect(requests, hasLength(2));
            expect(
              values,
              index == 0
                  ? [minimum + 2 * step, minimum + gap]
                  : [minimum, minimum + gap - 2 * step],
            );
            expect(values[1] - values[0], spacing);
            expect(
              sliderNodes(tester)[index].getSemanticsData().hasAction(action),
              isFalse,
            );
            await tester.pumpWidget(const SizedBox());
          } finally {
            handle.dispose();
          }
        },
      );
    }
  }

  testWidgets(
    'packed decimal spacing blocks semantic actions at both domain endpoints',
    (tester) async {
      final handle = tester.ensureSemantics();
      final requests = <List<double>>[];
      await tester.pumpWidget(
        testApp(
          values: const [.1, .2, .3],
          min: .1,
          max: .3,
          step: .1,
          minSpacing: .1,
          onChanged: requests.add,
        ),
      );
      expect(tester.takeException(), isNull);
      final nodes = sliderNodes(tester);
      expect(nodes, hasLength(3));
      for (final node in nodes) {
        final data = node.getSemanticsData();
        expect(data.hasAction(ui.SemanticsAction.increase), isFalse);
        expect(data.hasAction(ui.SemanticsAction.decrease), isFalse);
      }
      expect(requests, isEmpty);
      handle.dispose();
    },
  );

  testWidgets(
    'decimal requests round trip through a controlled arbitrary-thumb host',
    (tester) async {
      final handle = tester.ensureSemantics();
      var values = <double>[.1, .2, .3];
      final requests = <List<double>>[];
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) => NakedSlider(
                values: values,
                min: 0,
                max: 1,
                step: .1,
                minSpacing: .1,
                enableFeedback: false,
                onChanged: (next) {
                  requests.add(next);
                  setState(() => values = next);
                },
                child: const SizedBox(width: 240, height: 48),
              ),
            ),
          ),
        ),
      );
      expect(tester.takeException(), isNull);
      expect(
        sliderNodes(
          tester,
        )[1].getSemanticsData().hasAction(ui.SemanticsAction.increase),
        isFalse,
      );
      expect(
        sliderNodes(
          tester,
        )[1].getSemanticsData().hasAction(ui.SemanticsAction.decrease),
        isFalse,
      );
      for (final index in [0, 1, 2]) {
        performAction(
          tester,
          sliderNodes(tester)[index],
          ui.SemanticsAction.decrease,
        );
        await tester.pump();
        expect(tester.takeException(), isNull);
        expect(values[index], closeTo(index * .1, .000000001));
        expect(values.every((v) => v >= 0 && v <= 1), isTrue);
        for (var i = 1; i < values.length; i++) {
          expect(values[i], greaterThanOrEqualTo(values[i - 1]));
          expect(values[i] - values[i - 1], greaterThanOrEqualTo(.1 - 1e-10));
        }
      }
      expect(requests, hasLength(3));
      expect(() => requests.last[0] = 1, throwsUnsupportedError);
      handle.dispose();
    },
  );

  testWidgets(
    'small domains retain meaningful neighbor headroom and executable semantic actions',
    (tester) async {
      final handle = tester.ensureSemantics();
      try {
        for (final spacing in [0.0, 1e-12]) {
          var values = <double>[0, 1e-11];
          final requests = <List<double>>[];
          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: StatefulBuilder(
                  builder: (context, setState) => NakedSlider(
                    values: values,
                    min: 0,
                    max: 1e-10,
                    step: 1e-12,
                    minSpacing: spacing,
                    enableFeedback: false,
                    onChanged: (next) {
                      requests.add(next);
                      setState(() => values = next);
                    },
                    child: const SizedBox(width: 240, height: 48),
                  ),
                ),
              ),
            ),
          );
          expect(
            sliderNodes(
              tester,
            )[0].getSemanticsData().hasAction(ui.SemanticsAction.increase),
            isTrue,
          );
          expect(
            sliderNodes(
              tester,
            )[1].getSemanticsData().hasAction(ui.SemanticsAction.decrease),
            isTrue,
          );
          performAction(
            tester,
            sliderNodes(tester)[0],
            ui.SemanticsAction.increase,
          );
          await tester.pump();
          expect(requests.single, [1e-12, 1e-11]);
          performAction(
            tester,
            sliderNodes(tester)[1],
            ui.SemanticsAction.decrease,
          );
          await tester.pump();
          expect(values[0], 1e-12);
          expect(values[1], closeTo(9e-12, 1e-26));
          expect(values[0], greaterThanOrEqualTo(0));
          expect(values[1], lessThanOrEqualTo(1e-10));
          expect(values[1] - values[0], greaterThanOrEqualTo(spacing));
          expect(() => requests.last[0] = 0, throwsUnsupportedError);
          expect(tester.takeException(), isNull);
          await tester.pumpWidget(const SizedBox());
        }
      } finally {
        handle.dispose();
      }
    },
  );
}
