import 'dart:ui' show CheckedState, SemanticsAction, Tristate;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:naked_ui/naked_ui.dart' show NakedRadio;
import 'package:remix/remix.dart';

import '../../helpers/test_helpers.dart';

/// A rating whose owner records every change and keeps or declines it.
class _Host extends StatefulWidget {
  const _Host({
    this.initial,
    this.keep = true,
    this.allowClear = true,
    this.enabled = true,
    this.style = const RatingStyler.create(),
    required this.log,
  });

  final int? initial;
  final bool keep;
  final bool allowClear;
  final bool enabled;
  final RatingStyler style;
  final List<int?> log;

  @override
  State<_Host> createState() => _HostState();
}

class _HostState extends State<_Host> {
  late int? value = widget.initial;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: RemixRating(
        label: 'Rate this',
        description: 'Tap a star',
        value: value,
        allowClear: widget.allowClear,
        style: widget.style,
        onChanged: widget.enabled
            ? (next) {
                widget.log.add(next);
                if (widget.keep) setState(() => value = next);
              }
            : null,
      ),
    );
  }
}

const _marked = Color(0xFFFF0000);

/// Marks filled stars with a cell color, so a test reads each star's
/// published state from the widget tree.
final _probe = RatingStyler(
  star: RatingStarStyler().onFilled(RatingStarStyler().color(_marked)),
);

Finder _star(int star) => find.bySemanticsLabel('$star of 5 stars');

List<bool> _filled(WidgetTester tester) => [
  for (final radio in find.byType(NakedRadio<int>).evaluate())
    (tester
                    .widget<Box>(
                      find
                          .descendant(
                            of: find.byWidget(radio.widget),
                            matching: find.byType(Box),
                          )
                          .first,
                    )
                    .styleSpec
                    ?.spec
                    .decoration
                as BoxDecoration?)
            ?.color ==
        _marked,
];

SemanticsNode _root(WidgetTester tester) =>
    tester.binding.renderViews.single.owner!.semanticsOwner!.rootSemanticsNode!;

List<SemanticsNode> _radios(WidgetTester tester) =>
    semanticsSubtree(_root(tester))
        .where(
          (node) => node
              .getSemanticsData()
              .flagsCollection
              .isInMutuallyExclusiveGroup,
        )
        .toList();

/// Hover highlights follow the focus highlight mode, which is touch on the
/// test platform until a key or mouse press switches it.
Future<TestGesture> _mouse(WidgetTester tester) async {
  FocusManager.instance.highlightStrategy =
      FocusHighlightStrategy.alwaysTraditional;
  addTearDown(
    () => FocusManager.instance.highlightStrategy =
        FocusHighlightStrategy.automatic,
  );
  final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
  addTearDown(mouse.removePointer);
  return mouse;
}

void main() {
  group('RemixRating', () {
    testWidgets('a screen reader sees a named group of star radios', (
      tester,
    ) async {
      final semantics = tester.ensureSemantics();
      await tester.pumpRemixApp(_Host(initial: 3, log: []));
      await tester.pumpAndSettle();

      final groups = semanticsSubtree(_root(tester)).where(
        (node) => node.getSemanticsData().role == SemanticsRole.radioGroup,
      );
      expect(groups, hasLength(1));
      final named = semanticsSubtree(
        _root(tester),
      ).where((node) => node.getSemanticsData().label == 'Rate this').single;
      expect(named.getSemanticsData().hint, 'Tap a star');

      final radios = _radios(tester);
      expect(radios.map((node) => node.getSemanticsData().label), [
        '1 of 5 stars',
        '2 of 5 stars',
        '3 of 5 stars',
        '4 of 5 stars',
        '5 of 5 stars',
      ]);
      final checked = radios
          .map(
            (node) =>
                node.getSemanticsData().flagsCollection.isChecked ==
                CheckedState.isTrue,
          )
          .toList();
      expect(checked, [false, false, true, false, false]);
      for (final node in radios) {
        expect(node.getSemanticsData().hasAction(SemanticsAction.tap), isTrue);
      }
      // The visible label, value and description are not read twice.
      expect(find.bySemanticsLabel('Good'), findsNothing);
      semantics.dispose();
    });

    testWidgets('a semantic tap commits that star once', (tester) async {
      final semantics = tester.ensureSemantics();
      final log = <int?>[];
      await tester.pumpRemixApp(_Host(log: log));

      tester.semantics.tap(find.semantics.byLabel('4 of 5 stars'));
      await tester.pumpAndSettle();

      expect(log, [4]);
      semantics.dispose();
    });

    testWidgets('a disabled rating exposes disabled radios and never reports', (
      tester,
    ) async {
      final semantics = tester.ensureSemantics();
      final log = <int?>[];
      await tester.pumpRemixApp(_Host(initial: 2, enabled: false, log: log));

      for (final node in _radios(tester)) {
        expect(
          node.getSemanticsData().flagsCollection.isEnabled,
          Tristate.isFalse,
        );
      }
      await tester.tap(_star(4));
      await tester.pumpAndSettle();
      expect(log, isEmpty);
      semantics.dispose();
    });

    testWidgets('tapping a star commits it and fills up to it', (tester) async {
      final log = <int?>[];
      await tester.pumpRemixApp(_Host(log: log, style: _probe));

      await tester.tap(_star(4));
      await tester.pumpAndSettle();

      expect(log, [4]);
      expect(_filled(tester), [true, true, true, true, false]);
      expect(find.text('Great'), findsOneWidget);
    });

    testWidgets('tapping the committed star clears it when allowed', (
      tester,
    ) async {
      final log = <int?>[];
      await tester.pumpRemixApp(_Host(initial: 3, log: log, style: _probe));

      await tester.tap(_star(3));
      await tester.pumpAndSettle();

      expect(log, [null]);
      // The pointer still rests on star 3, yet the stars read as cleared.
      expect(_filled(tester), [false, false, false, false, false]);
      expect(find.text('Not rated'), findsOneWidget);
    });

    testWidgets('tapping the committed star keeps it without allowClear', (
      tester,
    ) async {
      final log = <int?>[];
      await tester.pumpRemixApp(_Host(initial: 3, allowClear: false, log: log));

      await tester.tap(_star(3));
      await tester.pumpAndSettle();

      expect(log, isEmpty);
    });

    testWidgets('hovering previews a value and leaving restores it', (
      tester,
    ) async {
      final log = <int?>[];
      await tester.pumpRemixApp(_Host(initial: 2, log: log, style: _probe));
      final mouse = await _mouse(tester);
      await mouse.addPointer(location: Offset.zero);

      await mouse.moveTo(tester.getCenter(_star(4)));
      await tester.pumpAndSettle();
      expect(_filled(tester), [true, true, true, true, false]);
      expect(find.text('Great'), findsOneWidget);

      await mouse.moveTo(Offset.zero);
      await tester.pumpAndSettle();
      expect(_filled(tester), [true, true, false, false, false]);
      expect(find.text('Fair'), findsOneWidget);
      expect(log, isEmpty);
    });

    testWidgets('a declined change leaves the stars on the owned value', (
      tester,
    ) async {
      final log = <int?>[];
      await tester.pumpRemixApp(_Host(keep: false, log: log, style: _probe));
      final mouse = await _mouse(tester);
      await mouse.addPointer(location: tester.getCenter(_star(3)));
      await tester.pumpAndSettle();

      await mouse.down(tester.getCenter(_star(3)));
      await mouse.up();
      await tester.pumpAndSettle();

      expect(log, [3]);
      expect(_filled(tester), [false, false, false, false, false]);
    });

    testWidgets('arrow keys move the value one star at a time', (tester) async {
      final log = <int?>[];
      await tester.pumpRemixApp(_Host(initial: 2, log: log, style: _probe));

      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pumpAndSettle();
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
      await tester.pumpAndSettle();
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
      await tester.pumpAndSettle();

      expect(log, [3, 2, 1]);
      expect(_filled(tester), [true, false, false, false, false]);
    });

    testWidgets('kept marks the committed value under a preview', (
      tester,
    ) async {
      final keptProbe = RatingStyler(
        star: RatingStarStyler().onKept(RatingStarStyler().color(_marked)),
      );
      await tester.pumpRemixApp(_Host(initial: 3, log: [], style: keptProbe));
      final mouse = await _mouse(tester);
      await mouse.addPointer(location: Offset.zero);
      await mouse.moveTo(tester.getCenter(_star(1)));
      await tester.pumpAndSettle();

      expect(_filled(tester), [true, true, true, false, false]);
      expect(find.text('Poor'), findsOneWidget);
    });

    testWidgets('onRated styles the rating while it shows a value', (
      tester,
    ) async {
      final style = RatingStyler()
          .valueText(TextStyler().color(const Color(0xFF000001)))
          .onRated(
            RatingStyler().valueText(
              TextStyler().color(const Color(0xFF000002)),
            ),
          );
      Color? valueColor() => tester
          .widget<StyledText>(
            find.byWidgetPredicate(
              (widget) => widget is StyledText && widget.text == 'Not rated',
              skipOffstage: false,
            ),
          )
          .styleSpec
          ?.spec
          .style
          ?.color;

      await tester.pumpRemixApp(_Host(log: [], style: style));
      expect(valueColor(), const Color(0xFF000001));

      await tester.tap(_star(2));
      await tester.pumpAndSettle();
      expect(valueColor(), const Color(0xFF000002));
    });

    test('default value labels', () {
      expect(RemixRating.defaultValueLabel(null, 5), 'Not rated');
      expect(RemixRating.defaultValueLabel(1, 5), 'Poor');
      expect(RemixRating.defaultValueLabel(5, 5), 'Excellent');
      expect(RemixRating.defaultValueLabel(3, 7), '3 out of 7');
      expect(RemixRating.defaultStarSemanticLabel(2, 5), '2 of 5 stars');
    });
  });
}
